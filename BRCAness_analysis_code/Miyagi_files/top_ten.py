#! /usr/bin/env python
import sys
import re

writefile = open("ten_genes.txt", "w")

spazer = 0
counter = 0

genfile = open("../../gencode.v19.annotation.BROCA2.bed", "r")
for Line in genfile:
	Line = Line.strip()
	genes = Line.split("\t")
	counter = 0
	readfile = open("somatic_info_hg19.tsv", "r")
	for line in readfile:
		line = line.strip()
		tab = line.split("\t")
		gene_name = tab[5]	
		if genes[4] in line:
			counter += 1
	writefile.write(genes[4] + "\t" + str(counter) + "\n")
	readfile.close()

genfile.close()
writefile.close()

list1 = ""
newread = open("ten_genes.txt", "r")
for line in newread:
	line = line.strip()
	line = line.split("\t")	
	if spazer == 0:
		list1 += (line[1])
		spazer += 1
	else:
		list1 += ("," + line[1])

list1 = list1.split(",")
list1 = [int(x) for x in list1]
list1.sort()

print list1
newread.close()

lines_seen = set()
writefile = open("new_ten.txt", "w")
for item in list1:
	newread = open("ten_genes.txt", "r")
	for lines in newread:
        	lines = lines.strip()
		linej = lines.split("\t")
		if (str(item) == linej[1]) and (lines not in lines_seen):
			writefile.write(lines + "\n")	
			lines_seen.add(lines)
	newread.close()
writefile.close()

