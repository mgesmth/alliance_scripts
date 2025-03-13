#!/bin/bash
#SBATCH --job-name=generategraph
#SBATCH --account=def-booker
#SBATCH --cpus-per-task=24
#SBATCH --mem=750G
#SBATCH --time=0-06:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=meg8130@student.ubc.ca
#SBATCH -o generategraph_withcoastal.%j.out
#SBATCH -e generategraph_withcoastal.%j.err

set -o errexit

def_booker=/home/mg615512/projects/def-booker
interior=${def_booker}/mg615512/minigraph_out/interior_primalt.gfa
coastal=${def_booker}/shared_dougfir/coastal_douglas_fir/coastal_douglas_fir_2025_assembly.fasta
out=${def_booker}/projects/def-booker/mg615512/minigraph_out/interior_primalt_coastal
script=${def_booker}/mg615512/scripts/executables

#executable
export PATH="${def_booker}/mg615512/bin/minigraph:$PATH"
export PATH="${def_booker}/mg615512/bin/gfatools:$PATH"

${script}/generate_graph.sh -t 24 -r ${interior} -q ${coastal} -o ${out} && \
${script}/call_SVs_fromgraph.sh -g ${out}.gfa -o ${out}
