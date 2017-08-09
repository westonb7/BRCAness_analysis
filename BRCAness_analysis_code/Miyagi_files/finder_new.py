#! /usr/bin/env python
import sys
import re

#Note: Rename these file names before running
readfile = open("gw6_val.rawcnv", "r")
writefile = open("new_list_cnv.txt", "w")

counter = 0

for line in readfile:
	search_chr = r'chr(\d+)'
	search = r'\:(\d+)\-(\d+)' 
	line = line.strip()
	col = line.split()

	#Note: check this syntax, it's probably wrong
	chromosome = re.search(search_chr, col[0])	
	match = re.search(search, col[0])
#########Test code#######
#	if counter < 10:
#		print "CHR: " +  chromosome.group(1)
#		print match.group(1) + " to " + match.group(2)
#		counter += 1

	varOne = int(match.group(1))
	varTwo = int(match.group(2))

	if (chromosome.group(1) == "13") or (chromosome.group(1) == "17"):
#		print "Range: " + match.group(1) + " to " + match.group(2) 
		if(varTwo > 41196312) and (varOne < 41277500):
			writefile.write("BRCA_1\t" + line + '\n')
		#elif(varTwo > 41196312) and (varTwo < 41277500):
		#	writefile.write("BRCA_1\t" + line + '\n')
		elif(varTwo > 32889617) and (varOne < 32973809):
                        writefile.write("BRCA_2\t" + line + '\n')
                #elif(varTwo > 32889617) and (varTwo < 32973809):
                #        writefile.write("BRCA_2\t" + line + '\n')
                elif(varTwo > 7571720) and (varOne < 7590868):
                        writefile.write("TP53\t" + line + '\n')
		#elif(varTwo > 7571720) and (varTwo < 7590868):
                #        writefile.write("TP53\t" + line + '\n')


readfile.close()
writefile.close()

