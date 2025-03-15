#!/bin/bash

if [[ ( $@ == "--help") ||  $@ == "-h" ]]
then
    echo "Usage: ./call_SVs_fromgraph.sh -g <ALN.GFA> -o <OUT_PREFIX>"
    echo ""
    echo "Call structural variation from a GFA file (pop bubbles) and output."
    echo ""
    echo "dependencies:"
    echo ""
    echo "    gfatools/0.5"
    echo ""
    echo "positional arguments:"
    echo ""
    echo "-g <ALN.GFA>         Path to genome alignment graph."
    echo "-o <OUTPUT_PREFIX>   The prefix to bed file to be generated. "
    echo ""
    echo ""
	exit 0
fi

OPTSTRING="g:o:"
while getopts ${OPTSTRING} opt
do
    case ${opt}
        in
	g)
	 graph=${OPTARG};;
	o)
	 output_prefix=${OPTARG};;
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

gfatools bubble ${graph} > ${output_prefix}.bed
