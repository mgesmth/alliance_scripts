#!/bin/bash

if [[ ( $@ == "--help") ||  $@ == "-h" ]]
then
    echo "Usage: ./call_SVs_fromgraph_minigraph.sh -t <THREADS> -l <CHAINLEN> -g <ALN.GFA> -q <QUERY.FA> -o <OUT_PREFIX>"
    echo ""
    echo "Call structural variation from a GFA file."
    echo ""
    echo "dependencies:"
    echo ""
    echo "    minigraph/0.5"
    echo ""
    echo "positional arguments:"
    echo ""
    echo "-t <THREADS>         Number of threads to use for alignment. Default 1."
    echo "-l <CHAINLEN>        Minimum chain length to consider. Default 50k."
    echo "-g <ALN.GFA>         Path to genome alignment graph."
    echo "-q <QUERY.FA>        Path to the query genome to be tracked through alignment."
    echo "-o <OUTPUT_PREFIX>   The prefix to bed file to be generated. "
    echo ""
    echo ""
	exit 0
fi

#DEFAULTS
threads=1
chain="50k"

OPTSTRING="g:q:o:tl"
while getopts ${OPTSTRING} opt
do
    case ${opt}
        in
	g)
	 graph=${OPTARG};;
	q)
	 query=${OPTARG};;
	o)
	 output_prefix=${OPTARG};;
        t)
         eval nextopt=\${$OPTIND}
         #if the next positional parameter is not an option flag, define query2 as the parameter:
         if [[ -n $nextopt && $nextopt != -* ]] ; then
          OPTIND=$((OPTIND + 1))
          threads=$nextopt
	 fi
        ;;
        l)
         eval nextopt=\${$OPTIND}
         #if the next positional parameter is not an option flag, define query2 as the parameter:
         if [[ -n $nextopt && $nextopt != -* ]] ; then
          OPTIND=$((OPTIND + 1))
          chain=$nextopt
         fi
        ;;
	:)
         echo 'option -${OPTARG} requires an argument.'
         exit 1
	;;
        ?)
         echo 'invalid option: ${OPTARG}'
         exit 1
	;;
    esac
done

minigraph -cxasm --call -t ${threads} -l ${chain} ${graph} ${query} > ${output_prefix}.bed

