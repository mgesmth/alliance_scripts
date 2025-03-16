#!/bin/bash
#SBATCH --account=def-booker
#SBATCH --cpus-per-task=24
#SBATCH --mem=750G
#SBATCH --time=12:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=meg8130@student.ubc.ca
#SBATCH -o asmcall.%j.out
#SBATCH -e asmcall.%j.err

export PATH="/home/mg615512/projects/def-booker/mg615512/bin/minigraph:$PATH"

booker=/home/mg615512/projects/def-booker
minidir=/home/mg615512/scratch/minigraph_out
primary=${booker}/shared_dougfir/interior_douglas_fir/renamed_scaffolds/interiorDF_primary_scaffrenamed.fa
alt=${booker}/shared_dougfir/interior_douglas_fir/renamed_scaffolds/interiorDF_alternate_scaffrenamed.fa
interior=${minidir}/interior_primalt_renamed.gfa
coastal=${booker}/shared_dougfir/coastal_douglas_fir/coastal_douglas_fir_2025_assembly.fasta
script=${booker}/mg615512/scripts/executables

${script}/call_SVs_fromgraph_minigraph.sh -t 24 -g ${primary} -q ${alt} -o ${minidir}/interior_alt_SVcall
${script}/call_SVs_fromgraph_minigraph.sh -t 24 -g ${interior} -q ${coastal} -o ${minidir}/coastal_SVcall

