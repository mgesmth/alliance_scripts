#!/bin/bash
#SBATCH --job-name=generategraph
#SBATCH --account=def-booker
#SBATCH --partition=cpularge_bynode_b4
#SBATCH --cpus-per-task=40
#SBATCH --mem=750G
#SBATCH --time=2-23:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=meg8130@student.ubc.ca
#SBATCH -o generategraph.%j.out
#SBATCH -e generategraph.%j.err

def_booker=/home/mg615512/projects/def-booker
int_prim=${def_booker}/shared_dougfir/interior_douglas_fir/interior_douglas_fir_cbp_assembly.fa
int_alt=${def_booker}/shared_dougfir/interior_douglas_fir/interior_douglas_fir_cbp_H1_assembly.fa
out=/home/mg615512/scratch/minigraph_out/interior_primalt
script=${def_booker}/mg615512/scripts/executables

#minigraph executable
export PATH="${def_booker}/mg615512/bin/minigraph:$PATH"

${script}/generate_graph.sh -t 24 -r ${int_prim} -q ${int_alt} -o ${out}
