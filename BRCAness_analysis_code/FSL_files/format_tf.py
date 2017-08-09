#! /usr/bin/env python
import sys
import re

writefile = open("tf_HiSeqV2_re.tsv", "w")
readfile = open("RABIT_BRCA.HiSeq.V2", "r")

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
				writefile.write(line[0] + "\t" + start[(shark - 1)] + "\t" + line[shark] + "\n")
				shark += 1	
writefile.close()
readfile.close()

