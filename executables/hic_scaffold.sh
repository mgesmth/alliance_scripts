#!/bin/bash

if [ $# -le 3 ] ; then
    echo "Usage: hic_scaffold.sh <N-THREADS> <CONTIGS.FA> <HIC_1> <HIC_2> <OUTPUT_PREFIX>"
    echo ""
    echo "A pipeline to align hi-C data to a genome assembly, remove "
    echo "PCR duplicates, and scaffold."
    echo ""
    echo "positional arguments:"
    echo ""
    echo "N-THREADS       Number of threads to be used for mapping."
    echo "CONTIGS.FA      Fasta file containing assembled contigs."
    echo "HIC_1           The path to a fastq file with the sequences of "
    echo "                the first side of Hi-C molecules."
    echo "HIC_2           The path to a fastq file with the sequences of "
    echo "                the second side of Hi-C molecules."
    echo "OUTPUT_PREFIX   The prefix to the paths of generated outputs. "
    echo ""
    echo ""

    exit 0
fi

THREAD=$1
CONTIGS=$2
H1=$3
H2=$4
OUT=$5

#EXECUTABLES >>>>
export PATH="/home/mg615512/projects/def-booker/mg615512/bin/chromap:$PATH" #chromap
export PATH="/home/mg615512/projects/def-booker/mg615512/bin/yahs:$PATH" #yahs
module load StdEnv/2023
module load gcc/12.3
module load samtools/1.20
# <<<<

#CHROMAP - align and remove pcr duplicates
chromap -i -r ${CONTIGS} -o ${CONTIGS}.index
chromap --preset hic --remove-pcr-duplicates -k 22 -w 10 -t ${THREAD} -x ${CONTIGS}.index -r ${CONTIGS} -1 ${H1} -2 ${H2} -o ${OUT}".pairs"

NEWIN=${OUT%.pairs}".pa5"
mv ${OUT}".pairs" ${NEWIN}

#YAHS
samtools faidx ${CONTIGS}
yahs -o ${OUT} ${CONTIGS} ${NEWIN} -e GATC,GANTC,CTNAG,TTAA
