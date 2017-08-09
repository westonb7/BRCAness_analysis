#! /usr/bin/env python
import sys
import re
import glob
import gzip

#######
# NOTE: This script requires a list of the files to be formatted (called "filenames.txt")
#######

writefile = open("mutec_2_aggregated.hg38.tsv", "w")

spazer = 0
counter = 0

writefile.write("Sample_ID\tChromosome\tPosition\tRef\tAlt\tSS ID\n")

#readfile = open("filenames_vcf.txt", "r")
#for line in readfile:
for som_file in glob.glob("/Data/TCGA/SomaticMutations/Mutect2_VCF_BRCA/*reheader.vcf.gz"):
	print som_file
#	line = line.strip()
#	som_file = "/Data/TCGA/SomaticMutations/Mutect2_VCF_BRCA_hg19/" + line

	genFile = gzip.open(som_file, "r")

	#print som_file

	for lines in genFile:
		lines = lines.strip()
		if lines[0] == "#":
			spazer += 1
			ind_search = r'##INDIVIDUAL'
			is_tcgaID = re.search(ind_search, lines)
			#print is_tcgaID
			if (is_tcgaID):
				search = r'NAME=(\w+-\w+-\w+)'
                        	tcga_ID = re.search(search, lines) 
				#print tcga_ID.group(1)
		else:
			lines = lines.split("\t")
			chrom = lines[0]
			position = lines[1]
			ID = lines[2]
			ref = lines[3]
			alt = lines[4]
			qual = lines[5]
			FILTER = lines[6]
			info = lines[7]
			FORMAT = lines[8]
			normal = lines[9]
			tumor = lines[10]

			#ss_search = r'SS=([0-9])'
			#ss_find = re.match(info, ss_search)
			#ss_num = ss_find.group()	
			#if (ss_num == "2"):
			#	ss_id = "Somatic"
			#elif (ss_num == "3"):
			#	ss_id = "LOH"	
			ss_num = "2"
			ss_id = "Somatic"

	
			info_entry = info.split(";")
			info_c = ""
			for entries in info_entry:
				entries = entries.split("|")
				if (info_c != ""):
					info_c += (entries[3] + "|")

			y = info_c.split("|")
			y = [z for z in y if z != ""]
			y = set(y)
			y = sorted(list(y))
			y = ",".join(y)

			if FILTER == "PASS":
				if chrom != "chrM":
					writefile.write(tcga_ID.group(1) + "\t" + chrom + "\t" + position + "\t" + ref + "\t" + alt + "\t"  + ss_id + "\n") 

	genFile.close()

#readfile.close
writefile.close()

