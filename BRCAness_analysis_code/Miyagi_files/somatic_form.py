#! /usr/bin/env python
import sys
import re

#######
# NOTE: This script requires a list of the files to be formatted (called "filenames.txt")
#######

writefile = open("somatic_info_hg19.tsv", "w")

spazer = 0
counter = 0

writefile.write("Sample_ID\tChromosome\tPosition\tRef\tAlt\tGene_Name\tSS_ID\tNormal_RD\tNormal_AD\tTumor_RD\tTumor_AD\n")

readfile = open("filenames.txt", "r")
for line in readfile:
	line = line.strip()
	som_file = "/Data/TCGA/Germline_CNV/Data/SomaticMutations/VarScan2_VCF_hg19/" + line

	genFile = open(som_file, "r")

	print som_file

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

			ss_search = 'SS=([0-9])'
			ss_find = re.search(ss_search, info)
			ss_num = ss_find.group(1)	
			if (ss_num == "2"):
				ss_id = "Somatic"
			elif (ss_num == "3"):
				ss_id = "LOH"	

			info_entry = info.split(",")
			info_c = ""
			for entries in info_entry:
				entries = entries.split("|")
				info_c += (entries[3] + "|")

			y = info_c.split("|")
			y = [z for z in y if z != ""]
			y = set(y)
			y = sorted(list(y))
			y = ",".join(y)

			if FILTER == "PASS":
				geneFile = open("../../gencode.v19.annotation.BROCA2.bed", "r")
                		for line in geneFile:
					line = line.strip()
                        		line = line.split("\t")
                        		chroms = line[0]
                        		gene_start = line[1]
                        		gene_end = line[2]
                        		strand = line[3]
                        		gene_name = line[4]			
					norm = normal.split(":")
					tumr = tumor.split(":")
					"""info_entry = info.split(",")
					info_c = ""
					for entries in info_entry:
						entries = entries.split("|")
						info_c += (entries[3] + "|")

					y = info_c.split("|")
					y = [z for z in y if z != ""]
					y = set(y)
					y = sorted(list(y))
					y = ",".join(y)
					#	print norm 
					#	print tumr
					"""

					position = int(position)
					gene_end = int(gene_end)
					gene_start = int(gene_start)

					if (chrom == chroms) and (position <= gene_end) and (position >= gene_start) and (ss_num == "2" or ss_num == "3"):
						writefile.write(tcga_ID.group(1) + "\t" + chrom + "\t" + str(position) + "\t" + ref + "\t" + alt + "\t" + gene_name + "\t" + ss_id + "\t" + norm[3] + "\t" + norm[4] + "\t" + tumr[3] + "\t" + tumr[4] + "\n") 

				geneFile.close()
	genFile.close()

readfile.close
writefile.close()

