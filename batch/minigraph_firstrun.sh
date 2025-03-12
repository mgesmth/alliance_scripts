#!/bin/bash
#SBATCH --account=def-booker
#SBATCH --partition=cpularge_bycore_b4
#SBATCH --cpus-per-task=24
#SBATCH --mem=700G
#SBATCH --time=2-00:00:00
#SBATCH --job-name=minigraph
#SBATCH --mail-type=ALL
#SBATCH --mail-user=meg8130@student.ubc.ca
#SBATCH -o minigraph.%j.out
#SBATCH -e minigraph.%j.err

home=/home/mg615512/projects/def-booker/mg615512
shared=/home/mg615512/projects/def-booker/shared_dougfir/interior_douglas_fir
scratch=/home/mg615512/scratch/mg615512
interior_prim=${shared}/interior_douglas_fir_cbp_assembly.fa
interior_alt=${shared}/interior_douglas_fir_cbp_H1_assembly.fa

export PATH="/home/mg615512/projects/def-booker/mg615512/bin/minigraph:$PATH" #minigraph executable

minigraph -cxggs -t32 $interior_prim $interior_alt > ${scratch}/interior_primary_alternate.gfa
