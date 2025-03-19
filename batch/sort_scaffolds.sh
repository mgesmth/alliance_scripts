#!/bin/bash
#SBATCH --account=def-booker
#SBATCH --cpus-per-task=1
#SBATCH --mem=20G
#SBATCH --time=00:30:00

out=/home/mg615512/scratch/coastalDF_scaffrenamed_sorted.fa
in_file=/home/mg615512/projects/def-booker/shared_dougfir/coastal_douglas_fir/renamed_scaffolds/coastal_douglas_fir_2025_assembly.fasta

module load StdEnv/2023
module load seqkit/2.5.1

cp ${in_file}.fai ${infile}2.fai

seqkit sort -l -r -2 -U ${in_file} > ${out}
