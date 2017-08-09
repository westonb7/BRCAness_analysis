#! /usr/bin/env python
import sys
import re

#Note: Rename these file names before running
#readfile = open("quality_list.txt", "r")
listfile = open("signallistfile2.txt", "r")
writefile = open("high_quality.txt", "w")

x = 0

for line in listfile:
	search = r'(gw6\.\w+)' 
	line = line.strip()
	#Note: check this syntax, it's probably wrong
	readfile = open("quality_list.txt", "r")
	x = 0
	for newLine in readfile:	
		if line in newLine:	
			x = 2
	if x == 0:
		writefile.write(line + "\n")	
	readfile.close()

readfile.close()
listfile.close()
writefile.close()

