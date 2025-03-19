#!/bin/bash
#SBATCH --account=def-booker
#SBATCH --cpus-per-task=12
#SBATCH --mem=150G
#SBATCH --time=07:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=meg8130@student.ubc.ca
#SBATCH -o scaffolds11_13.%j.out
#SBATCH -e scaffolds11_13.%j.err

minidir=/home/mg615512/scratch/minigraph_out
booker=/home/mg615512/projects/def-booker
shared=${booker}/shared_dougfir
primary=${shared}/interior_douglas_fir/renamed_scaffolds/intDF_primary_11_13.fa
alternate=${shared}/interior_douglas_fir/renamed_scaffolds/intDF_alternate_11_13.fa
out_prefix=${minidir}/interior_11_13_test

export PATH="${booker}/mg615512/bin/minigraph:$PATH"
export PATH="${booker}/mg615512/bin/gfatools:$PATH"

minigraph -cxggs -t 12 -k 22 ${primary} ${alternate} > "${out_prefix}.gfa"
gfatools bubble "${out_prefix}.gfa" > "${out_prefix}.bed"
