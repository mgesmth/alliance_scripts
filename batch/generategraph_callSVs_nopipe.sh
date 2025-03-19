#!/bin/bash
#SBATCH --job-name=generategraph
#SBATCH --account=def-booker
#SBATCH --cpus-per-task=24
#SBATCH --mem=750G
#SBATCH --time=12:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=meg8130@student.ubc.ca
#SBATCH -o generategraph_nopipe.%j.out
#SBATCH -e generategraph_nopipe.%j.err

#SO over minigraph being a little bitch with my alignment. Ditching the pipe to see if that helps.

booker=/home/mg615512/projects/def-booker
shared=${booker}/shared_dougfir
intprim=${shared}/interior_douglas_fir/renamed_scaffolds/interiorDF_primary_scaffrenamed.fa
intalt=${shared}/interior_douglas_fir/renamed_scaffolds/interiorDF_alternate_scaffrenamed.fa
coastal=${shared}/coastal_douglas_fir/renamed_scaffolds/coastal_douglas_fir_2025_assembly.fasta
out_gfa=/home/mg615512/scratch/minigraph_out/interior_coastal_retry2.gfa
out_bed=/home/mg615512/scratch/minigraph_out/interior_coastal_retry2.bed

#TEST VARIABLES - SUCCESS
#echo $intprim
#echo $intalt
#echo $coastal
#echo ${out_gfa}
#echo ${out_bed}

#EXECUTABLES
export PATH="${booker}/mg615512/bin/minigraph:$PATH"
export PATH="${booker}/mg615512/bin/gfatools:$PATH"

#-U flag is from developer for another genome of similar size
minigraph -cxggs -t 24 -k 21 -U 10,50 ${intprim} ${intalt} ${coastal} > ${out_gfa}
gfatools bubble ${outdir}/interior_coastal_retry2.gfa > ${out_bed}

##TEST - SUCCESS
#minigraph -cxggs -l 10k MT.gfa MT-chimp.fa MT-orangA.fa > test_nopipe.gfa
#gfatools bubble test_nopipe.gfa > test_nopipe.bed
