#! /usr/bin/env python
import sys
import re

writefile = open("somatic_CNV.tsv", "w")
readfile = open("../Data/Gistic2_CopyNumber_Gistic2_all_thresholded.by_genes", "r")

count = 0
shark = 0

writefile.write("Sample\tGene_Symbol\tValue\n")

for line in readfile:
	line = line.strip()
	
	if count == 0:
		start = line.split("\t")
		count += 1
	else: 
		line = line.split("\t")
		shark = 0
		for elem in line:
			if shark == 0:
				shark += 1
			else:
				writefile.write(start[(shark)] + "\t" + line[0] + "\t" + line[shark] + "\n")
				shark += 1	
writefile.close()
readfile.close()

