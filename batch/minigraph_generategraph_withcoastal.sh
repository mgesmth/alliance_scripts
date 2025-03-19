#!/bin/bash
#SBATCH --job-name=generategraph
#SBATCH --account=def-booker
#SBATCH --cpus-per-task=24
#SBATCH --mem=750G
#SBATCH --time=0-12:30:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=meg8130@student.ubc.ca
#SBATCH -o generategraph_withcoastal.%j.out
#SBATCH -e generategraph_withcoastal.%j.err

def_booker=/home/mg615512/projects/def-booker
interior_prim=${def_booker}/shared_dougfir/interior_douglas_fir/renamed_scaffolds/interiorDF_primary_scaffrenamed.fa
interior_alt=${def_booker}/shared_dougfir/interior_douglas_fir/renamed_scaffolds/interiorDF_alternate_scaffrenamed.fa
coastal=${def_booker}/shared_dougfir/coastal_douglas_fir/renamed_scaffolds/coastal_douglas_fir_2025_assembly.fasta
out1=/home/mg615512/scratch/minigraph_out/interior_primalt_renamed_retry
out2=/home/mg615512/scratch/minigraph_out/interior_primalt_renamed_coastal_retry
script=${def_booker}/mg615512/scripts/executables
thread="24"

#executable
export PATH="${def_booker}/mg615512/bin/minigraph:$PATH"
export PATH="${def_booker}/mg615512/bin/gfatools:$PATH"

#${script}/generate_graph.sh -t ${thread} -r ${interior_prim} -q ${interior_alt} -o ${out1}
${script}/generate_graph.sh -t ${thread} -r "${out1}.gfa" -q ${coastal} -o ${out2}
${script}/call_SVs_fromgraph_gfatools.sh -g "${out1}.gfa" -o ${out1}
${script}/call_SVs_fromgraph_gfatools.sh -g "${out2}.gfa" -o ${out2}
