#!/bin/bash
#SBATCH --job-name=generategraph
#SBATCH --account=def-booker
#SBATCH --cpus-per-task=24
#SBATCH --mem=460G
#SBATCH --time=6:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=meg8130@student.ubc.ca
#SBATCH -o generategraph_nopipe.%j.out
#SBATCH -e generategraph_nopipe.%j.err

#SO over minigraph being a little bitch with my alignment. Ditching the pipe to see if that helps.
#these scaffolds are ~98% of interior, ~93% of coastal

booker=/home/mg615512/projects/def-booker
minidir=/home/mg615512/scratch/minigraph_out
shared=${booker}/shared_dougfir
intprim=${minidir}/interiorDF_primary_scaffrenamed_13.fa
intalt=${minidir}/interiorDF_alternate_scaffrenamed_13.fa
out=${minidir}/interior_first20scaffolds

#TEST VARIABLES - SUCCESS
#echo $intprim
#echo $intalt
#echo $coastal
#echo ${out_gfa}
#echo ${out_bed}

#EXECUTABLES
export PATH="${booker}/mg615512/bin/minigraph-0.20:$PATH"
export PATH="${booker}/mg615512/bin/gfatools:$PATH"

#-U flag is from developer for another genome of similar size
minigraph -cxggs -t 24 -U 10,50 ${intprim} ${intalt} > ${out}.gfa
gfatools bubble ${out}.gfa > ${out}.bed

##TEST - SUCCESS
#minigraph -cxggs -l 10k MT.gfa MT-chimp.fa MT-orangA.fa > test_nopipe.gfa
#gfatools bubble test_nopipe.gfa > test_nopipe.bed
