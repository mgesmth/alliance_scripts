#!/bin/bash
#SBATCH --job-name=generategraph
#SBATCH --account=def-booker
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G
#SBATCH --time=0-00:00:30
#SBATCH --mail-type=ALL
#SBATCH --mail-user=meg8130@student.ubc.ca
#SBATCH -o generategraph_test.%j.out
#SBATCH -e generategraph_test.%j.err

def_booker=/home/mg615512/projects/def-booker
#int_prim=${def_booker}/shared_dougfir/interior_douglas_fir/interior_douglas_fir_cbp_assembly.fa
#int_alt=${def_booker}/shared_dougfir/interior_douglas_fir/interior_douglas_fir_cbp_H1_assembly.fa
ref=${def_booker}/mg615512/bin/minigraph/test/MT-human.fa
query=${def_booker}/mg615512/bin/minigraph/test/MT-orangA.fa
#out=/home/mg615512/scratch/minigraph_out/interior_primalt
out=${def_booker}/mg615512/bin/minigraph/test/MAR13_test
script=${def_booker}/mg615512/scripts/executables

#executable
export PATH="${def_booker}/mg615512/bin/minigraph:$PATH"
export PATH="${def_booker}/mg615512/bin/gfatools:$PATH"

#${script}/generate_graph.sh -t 24 -r ${int_prim} -q ${int_alt} -o ${out}
${script}/generate_graph.sh -t t -r ${ref} -q ${query} -o ${out}
${script}/call_SVs_fromgraph.sh -g ${out}.gfa -o ${out}
