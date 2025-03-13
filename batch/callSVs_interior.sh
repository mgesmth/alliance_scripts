#!/bin/bash
#SBATCH --job-name=generategraph
#SBATCH --account=def-booker
#SBATCH --cpus-per-task=12
#SBATCH --mem=150G
#SBATCH --time=0-01:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=meg8130@student.ubc.ca
#SBATCH -o callSVs_interior.%j.out
#SBATCH -e callSVs_interior.%j.err

set -o errexit

def_booker=/home/mg615512/projects/def-booker
interior=${def_booker}/mg615512/minigraph_out/interior_primalt.gfa
out=${def_booker}/mg615512/minigraph_out/interior_SVs
script=${def_booker}/mg615512/scripts/executables

#executable
export PATH="${def_booker}/mg615512/bin/gfatools:$PATH"

${script}/call_SVs_fromgraph.sh -g ${interior} -o ${out}
