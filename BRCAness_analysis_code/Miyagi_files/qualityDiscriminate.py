#! /usr/bin/env python
import sys
import re


readCNV = open("CNVs_of_interest.txt", "r")
writefile = open("BRCA_list.txt", "w")

counter = 0
total = 0

for line in readCNV:
	search = r'(gw6\.\w+)' 
	#score_search = r'((\d\.\d+))'
	line = line.strip()
	readList = open("quality_list.txt", "r")		
	match = re.search(search, line)

	for readLine in readList:
		readLine = readLine.strip()
		if match.group(1) in readLine:
			writefile.write(line + "\n")			
		#	print "quick brown fox"	
	readList.close()

readList.close()
writefile.close()

