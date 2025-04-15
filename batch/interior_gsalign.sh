#!/bin/bash
#SBATCH --job-name=gsalign
#SBATCH --account=def-booker
#SBATCH -c 24
#SBATCH --mem=450G
#SBATCH --time=12:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=meg8130@student.ubc.ca
#SBATCH -o gsalign_interior.%j.out
#SBATCH -e gsalign_interior.%j.err

home=/home/mg615512/projects/def-booker/mg615512
scratch=/home/mg615512/scratch
shared=/home/mg615512/projects/def-booker/shared_dougfir
primary=${shared}/interior_douglas_fir/renamed_scaffolds/interiorDF_primary_scaffrenamed_1Mb.fa
alternate=${shared}/interior_douglas_fir/renamed_scaffolds/interiorDF_alternate_scaffrenamed_1Mb.fa
output_prefix="interior_gsalign"
output="${scratch}/${output_prefix}"

export PATH="${home}/bin/GSAlign/bin:$PATH"
export PATH="${home}/scripts/executables:$PATH"

gsalign.sh -t 24 -u -r "${primary}" -q "${alternate}" -o "${output}"
cut -d " " -f1-6 "${output}.maf" > "${home}/GSAlign/${output_prefix}_noseq.maf"

#Get by scaffold info

cd ${home}/GSAlign
mkdir byscaffold_matches_interior && cd byscaffold_matches_interior
cut -f1 ${shared}/interior_douglas_fir/renamed_scaffolds/interiorDF_primary_scaffrenamed_1Mb.fa.fai > ./prim_scaffold_list.txt

for scaffold in `cat ../prim_scaffold_list.txt` ; do
	#make a directory for each primary scaffold
	mkdir ${scaffold}
	#grep all the lines corresponding to each primary scaffold + the score and alt scaffold in question
	grep -C 1 "${scaffold}" "../${output_prefix}_noseq.maf" > ./"${scaffold}"/"${scaffold}_allalternate.txt"
	#Make a file to report the number of alignment between the primary scaffold and each aligned alt scaffold
	touch ./"${scaffold}"/countedalignments.txt
	#grab all of the alternate scaffolds that have an alignment with that scaffold to iterate over (awk using . as field sep to get rid of "qry.")
	 for alt in `cut -d " " -f2 "./${scaffold}/${scaffold}_allalternate.txt" | grep "qry" | uniq | awk -F "." '{print $2}'` ; do
		#count is the number of times the alt scaffold aligned to the primary scaffold
		count=`grep "${alt}" ./"${scaffold}"/"${scaffold}_allalternate.txt" | wc -l`
		#add the name of the alt scaffold and the count to the counted alignments file
		echo -e "${alt}\t${count}" >> ./"${scaffold}"/countedalignments.txt
		#just create a file containing all the alignments between the primary scaffold and the specific alt scaffold (for scores)
		grep -B 2 "${alt}" ./"${scaffold}"/"${scaffold}_allalternate.txt" > ./"${scaffold}"/"${scaffold}.${alt}.txt"
	 done
	rm ./"{scaffold}"/"{scaffold}_allalternate.txt"
	sort -gr -k2 ./"${scaffold}"/countedalignments.txt > ./"${scaffold}"/countedalignments_sorted.txt
	rm ./"${scaffold}"/countedalignments.txt
done
