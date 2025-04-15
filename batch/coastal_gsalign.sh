#!/bin/bash
#SBATCH --job-name=gsalign
#SBATCH --account=def-booker
#SBATCH -c 24
#SBATCH --mem=450G
#SBATCH --time=23:30:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=meg8130@student.ubc.ca
#SBATCH -o gsalign_coastal.%j.out
#SBATCH -e gsalign_coastal.%j.err

home=/home/mg615512/projects/def-booker/mg615512
scratch=/home/mg615512/scratch
shared=/home/mg615512/projects/def-booker/shared_dougfir
primary=${shared}/interior_douglas_fir/renamed_scaffolds/interiorDF_primary_scaffrenamed_1Mb.fa
#alternate=${shared}/interior_douglas_fir/renamed_scaffolds/interiorDF_alternate_scaffrenamed_1Mb.fa
coastal=${shared}/coastal_douglas_fir/renamed_scaffolds/coastalDF_scaffrenamed_sorted_1Mb.fa
out_prefix="coastal_gsalign"
output="${scratch}/${out_prefix}"

export PATH="${home}/bin/GSAlign/bin:$PATH"
export PATH="${home}/scripts/executables:$PATH"

gsalign.sh -t 24 -u -r "${primary}" -q "${coastal}" -o "${output}"
cut -d " " -f1-6 "${output}.maf" > "${home}/GSAlign/${out_prefix}_noseq.maf"

#Get by scaffold info

cd ${home}/GSAlign
mkdir byscaffold_matches_coastal && cd byscaffold_matches_coastal
cut -f1 ${shared}/interior_douglas_fir/renamed_scaffolds/interiorDF_primary_scaffrenamed_1Mb.fa.fai > ./prim_scaffold_list.txt

for scaffold in `cat ../prim_scaffold_list.txt` ; do
	#make a directory for each primary scaffold
	mkdir ${scaffold}
	#grep all the lines corresponding to each primary scaffold + the score and alt scaffold in question
	grep -C 1 "${scaffold}" ../coastal_gsalign_noseq.maf > ./"${scaffold}"/"${scaffold}_allcoastal.txt"
	#Make a file to report the number of alignment between the primary scaffold and each aligned alt scaffold
	touch ./"${scaffold}"/countedalignments.txt
	#grab all of the alternate scaffolds that have an alignment with that scaffold to iterate over (awk using . as field sep to get rid of "qry.")
	 for coa in `cut -d " " -f2 "./${scaffold}/${scaffold}_allcoastal.txt" | grep "qry" | uniq | awk -F "." '{print $2}'` ; do
		#count is the number of times the alt scaffold aligned to the primary scaffold
		count=`grep "${coa}" ./"${scaffold}"/"${scaffold}_allcoastal.txt" | wc -l`
		#add the name of the alt scaffold and the count to the counted alignments file
		echo -e "${coa}\t${count}" >> ./"${scaffold}"/countedalignments.txt
		#just create a file containing all the alignments between the primary scaffold and the specific alt scaffold (for scores)
		grep -B 2 "${coa}" ./"${scaffold}"/"${scaffold}_allcoastal.txt" > ./"${scaffold}"/"${scaffold}.${coa}.txt"
	 done
	rm ./"{scaffold}"/"{scaffold}_allcoastal.txt"
	sort -gr -k2 ./"${scaffold}"/countedalignments.txt > ./"${scaffold}"/countedalignments_sorted.txt
	rm ./"${scaffold}"/countedalignments.txt
done
