#!/bin/bash
#SBATCH --job-name=scaffold
#SBATCH --account=def-booker
#SBATCH --partition=cpularge_bycore_b4
#SBATCH --cpus-per-task=24
#SBATCH --mem=500G
#SBATCH --time=3-00:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=meg8130@student.ubc.ca
#SBATCH -o scaffold.%j.o
#SBATCH -e scaffold.%j.e

#DIR STRUCTURE>>>>
home=/home/mg615512/projects/def-booker/mg615512
scratch=/home/mg615512/scratch
hiC_dir=${scratch}/hiC_data
#<<<<

#VARIABLES>>>
assembly=${home}/contigs/intDF011.asm.hic.p_ctg.fasta
hic1=${hiC_dir}/allhiC_R1.fastq.gz
hic2=${hiC_dir}/allhiC_R2.fastq.gz
output_prefix=${scratch}/scaffold/intDF011
threads=24
#<<<<

#TEST
#assembly=${home}/bin/chromap/test/ref.fa
#hic1=${home}/bin/chromap/test/read1.fq
#hic2=${home}/bin/chromap/test/read2.fq
#output_prefix=${home}/testout
#threads=2

${home}/scripts/hic_scaffold.sh ${threads} ${assembly} ${hic1} ${hic2} ${output_prefix}
