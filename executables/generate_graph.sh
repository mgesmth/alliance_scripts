#!/bin/bash

if [[ ( $@ == "--help") ||  $@ == "-h" ]]
then
    echo "Usage: ./generate_graph.sh -t <THREADS> -r <REF.FA/GFA> -q <QUERY1.FA> -x <QUERY2.FA> -y <QUERY3.FA> -z <QUERY4.FA> -o <OUT_PREFIX>"
    echo ""
    echo "A script to generate a genome alignment graph (GFA) of up to 5 genomes using minigraph."
    echo ""
    echo "positional arguments:"
    echo ""
    echo "-t <THREADS>         Number of threads to use for mapping."
    echo "-l <CHAINLEN>        Minimum chain length to consider. Default 50k."
    echo "-r <REF.FA/.GFA>     Path to the reference genome to use in graph generation."
    echo "-q <QUERY1.FA>       Path to the first query genome to be aligned to the reference."
    echo "-x <QUERY2.FA>       Path to the second query genome to be aligned. Optional."
    echo "-y <QUERY3.FA>       Path to the third query genome to be aligned. Optional."
    echo "-z <QUERY4.FA>       Path to the fourth query genome to be aligned. Optional."
    echo "-o <OUTPUT_PREFIX>   The prefix to the paths of generated graph. "
    echo ""
    echo ""
	exit 0
fi

#Defaults
chain="50k"

OPTSTRING="t:r:q:o:xyzl"
while getopts ${OPTSTRING} opt
do
    case ${opt}
        in
	t)
	 threads=${OPTARG};;
	r)
	 reference=${OPTARG};;
	q)
	 queries=${OPTARG};;
	o)
	 output_prefix=${OPTARG};;
	x)
         eval nextopt=\${$OPTIND}
	 #if the next positional parameter is not an option flag, define query2 as the parameter:
	 if [[ -n $nextopt && $nextopt != -* ]] ; then
	  OPTIND=$((OPTIND + 1))
	  queries+=" $nextopt"
	 fi
	;;
	y)
         eval nextopt=\${$OPTIND}
         #if the next positional parameter is not an option flag, define query2 as the parameter:
         if [[ -n $nextopt && $nextopt != -* ]] ; then
          OPTIND=$((OPTIND + 1))
          queries+=" $nextopt"
         fi
	;;
        z)
         eval nextopt=\${$OPTIND}
         #if the next positional parameter is not an option flag, define query2 as the parameter:
         if [[ -n $nextopt && $nextopt != -* ]] ; then
          OPTIND=$((OPTIND + 1))
          queries+=" $nextopt"
         fi
	;;
        l)
         eval nextopt=\${$OPTIND}
         if [[ -n $nextopt && $nextopt != -* ]] ; then
          OPTIND=$((OPTIND + 1))
          chain="$nextopt"
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

set -o errexit
set -o nounset
set -o pipefail

minigraph -cxggs -t ${threads} -l ${chain} $reference $queries > ${output_prefix}.gfa
