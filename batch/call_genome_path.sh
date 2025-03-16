#!/bin/bash
#SBATCH --account=def-booker
#SBATCH --cpus-per-task=16
#SBATCH --mem=250G
#SBATCH --time=02:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=meg8130@student.ubc.ca
#SBATCH -o asmcall.%j.out
#SBATCH -e asmcall.%j.err

export PATH="/home/mg615512/projects/def-booker/mg615512/bin/minigraph:$PATH"

minidir=/home/mg615512/scratch/minigraph_out
graph=${minidir}/interior_primalt_renamed_coastal.gfa
alt=/home/mg615512/projects/def-booker/shared_dougfir/interior_douglas_fir/renamed_scaffolds/interiorDF_alternate_scaffrenamed.fa
script=/home/mg615512/projects/def-booker/mg615512/scripts/executables

${script}/call_SVs_fromgraph_minigraph.sh -t 16 -g ${graph} -q ${alt} -o ${minidir}/interior_alt_SVcall

