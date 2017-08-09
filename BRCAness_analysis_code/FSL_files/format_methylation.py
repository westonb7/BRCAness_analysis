#! /usr/bin/env python
import sys
import re

writefile = open("methyl_brca.tsv", "w")
readfile = open("../Data/methyl_brca_re.tsv", "r")

count = 0
shark = 0

writefile.write("Sample\tIdentifier\tValue\n")

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
				writefile.write(line[0] + "\t" + start[(shark)] + "\t" + line[shark] + "\n")
				shark += 1	
writefile.close()
readfile.close()

