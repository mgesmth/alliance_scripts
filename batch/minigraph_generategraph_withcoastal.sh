#!/bin/bash
#SBATCH --job-name=generategraph
#SBATCH --account=def-booker
#SBATCH --partition=cpularge_bynode_b4
#SBATCH --cpus-per-task=24
#SBATCH --mem=750G
#SBATCH --time=0-05:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=meg8130@student.ubc.ca
#SBATCH -o generategraph_withcoastal.%j.out
#SBATCH -e generategraph_withcoastal.%j.err

def_booker=/home/mg615512/projects/def-booker
interior=${def_booker}/mg615512/minigraph_out/interior_primalt.gfa
coastal=${def_booker}/shared_dougfir/coastal_douglas_fir/coastal_douglas_fir_2025_assembly.fasta
out=${def_booker}/projects/def-booker/mg615512/minigraph_out/interior_primalt_coastal
script=${def_booker}/mg615512/scripts/executables

#minigraph executable
export PATH="${def_booker}/mg615512/bin/minigraph:$PATH"

${script}/generate_graph.sh -t 24 -r ${interior} -q ${int_alt} -o ${out}
