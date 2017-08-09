#! /usr/bin/env python
import sys
import re

#Note: Rename these file names before running
readfile = open("gw6_HG_19.log", "r")
writefile = open("quality_list.txt", "w")

counter = 0
total = 0

for line in readfile:
	search = r'(gw6\.\w+)' 
	score_search = r'((\d\.\d+))'
	line = line.strip()
	#Note: check this syntax, it's probably wrong
	
	if ('WARNING' in line) and ('LRR' in line):
		match = re.search(search, line)
		score = re.search(score_search, line)
		score = float(score.group(1))
		if score < .35:
			writefile.write(match.group(1) + "\n")
			
#		if match:
#			writefile.write("LRR\t" + match.group(1) + "\n")
	if ('WARNING' in line) and ('BAF' in line):
                match = re.search(search, line)
  #              if match:
 #                       writefile.write("BAF\t" + match.group(1) + "\n")		


readfile.close()
writefile.close()

