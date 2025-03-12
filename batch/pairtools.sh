#!/bin/bash
#SBATCH --account=def-booker
#SBATCH --partition=
#SBATCH --cpus-per-task=24
#SBATCH --mem=400G
#SBATCH --time=2-00:00:00
#SBATCH --job-name=pairtools
#SBATCH --mail-type=ALL
#SBATCH --mail-user=meg8130@student.ubc.ca
#SBATCH -o pairtools.%j.out
#SBATCH -e pairtools.%j.err

#SBATCH --job-name=pairtools
#SBATCH --account-name=

#this code is modified from example_pipeline.sh in the pairtools github
#I took out the part with bwa mem, as I've already done that

set -o errexit
set -o nounset
set -o pipefail
#these essential ensure the pipeline exits if any error is thrown

##MY VARIABLES >>>>

module load StdEnv/2023
module load gcc/12.3
module load samtools/1.20
home=/home/mg615512/projects/def-booker/mg615512
scratch=/home/mg615512/scratch
contigs=${home}/contigs
hiCdir=${scratch}/hiC_data

##<<<<

INDEX=${contigs}/intDF011.asm.hic.p_ctg.fasta
CHROM_SIZES=${contigs}/intDF011_final.chrom.sizes
FASTQ1=${hiCdir}/allhiC_R1.fastq.gz
FASTQ2=${hiCdir}/allhiC_R2.fastq.gz
OUTPREFIX=${scratch}/pairtools/intDF011
N_THREADS=8
UNMAPPED_SAM_PATH=${OUTPREFIX}.unmapped.bam
UNMAPPED_PAIRS_PATH=${OUTPREFIX}.unmapped.pairs
NODUPS_SAM_PATH=${OUTPREFIX}.nodups.bam
NODUPS_PAIRS_PATH=${OUTPREFIX}.nodups.pairs
DUPS_SAM_PATH=${OUTPREFIX}.dups.bam
DUPS_PAIRS_PATH=${OUTPREFIX}.dups.pairs

bwa mem -SP5M -t "${N_THREADS}" "${INDEX}" "${FASTQ1}" "${FASTQ2}" | {
    # Classify Hi-C molecules as unmapped/single-sided/multimapped/chimeric/etc
    # and output one line per read, containing the following, separated by \\v:
    #  * triu-flipped pairs
    #  * read id
    #  * type of a Hi-C molecule
    #  * corresponding sam entries
    pairtools parse --chroms-path "{CHROM_SIZES}"
} | {
    # Block-sort pairs together with SAM entries
    pairtools sort --nproc 8 --memory 100G --tmpdir ${scratch}
} | {
    # Remove duplicates, separate mapped and unmapped reads
    pairtools dedup \
        --output \
            >( pairtools split \
                --output-pairs ${NODUPS_PAIRS_PATH} \
                --output-sam ${NODUPS_SAM_PATH} ) \
        --output-dups \
            >( pairtools markasdup \
                | pairtools split \
                    --output-pairs ${DUPS_PAIRS_PATH} \
                    --output-sam ${DUPS_SAM_PATH} ) \
        --output-unmapped >( pairtools split \
            --output-pairs ${UNMAPPED_PAIRS_PATH} \
            --output-sam ${UNMAPPED_SAM_PATH} )

}
