#!/bin/bash

if [[ ( $@ == "--help") ||  $@ == "-h" ]]
then
    echo "Usage: ./gsalign.sh -t <THREADS> -r <REFERENCE> -q <QUERY> -o <PREFIX>"
    echo ""
    echo "Align two genomes with GSAlign."
    echo ""
    echo "dependencies:"
    echo ""
    echo "    GSAlign/1.0.19"
    echo ""
    echo "positional arguments:"
    echo ""
    echo "-t <THREADS>   Number of threads."
    echo "-r <FASTA>     Reference genome in fasta format."
    echo "-q <QUERY>     Query genome in fasta format."
    echo "-o <PREFIX>    Prefix for output file."
    echo "-f <maf/aln>	 Output format (default maf)"
    echo "-u 		 Output only unique alignments."
    echo ""
    echo ""
	exit 0
fi

#defaults
format=1
unique="false"

OPTSTRING="t:r:q:o:fu"
while getopts ${OPTSTRING} opt
do
    case ${opt} in
	t) threads="${OPTARG}";;
	r) reference="${OPTARG}";;
	q) query="${OPTARG}";;
	o) out_prefix="${OPTARG}";;
	f) case "${OPTARG}" in
	 maf) format=1 ;;
	 aln) format=2 ;;
	esac ;;
	u) unique="true" ;;
        :)
         echo "option ${OPTARG} requires an argument."
         exit 1
	;;
        ?)
         echo "invalid option: ${OPTARG}"
         exit 1
	;;
    esac
done

if [ "$unique" == "false" ] ; then
GSAlign -t "${threads}" -r "${reference}" -q "${query}" -o "${out_prefix}" -fmt "${format}"
else
GSAlign -t "${threads}" -r "${reference}" -q "${query}" -o "${out_prefix}" -fmt "${format}" -unique "true"
fi
