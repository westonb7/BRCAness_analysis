#! /usr/bin/env python
import sys
import re


readList = open("quality_list.txt", "r")
writefile = open("gw6_val.rawcnv", "w")

counter = 0
total = 0

for line in readList:
	#search = r'(gw6\.\w+)' 
	#score_search = r'((\d\.\d+))'
	line = line.strip()

	readRaw = open("gw6_HG_19.rawcnv", "r")		
	for rawLine in readRaw:
		rawLine = rawLine.strip()
		if line in rawLine:
			writefile.write(rawLine + "\n")			
	readRaw.close()


readList.close()
writefile.close()

