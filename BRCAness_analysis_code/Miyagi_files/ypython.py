#! /usr/bin/env python
import sys
import re

#Note: Rename these file names before running
readfile = open("mutation_test_edit", "r")
writefile = open("mutation_2test_edit", "w")

for line in readfile:
	line = line.strip()
	#Note: check this syntax, it's probably wrong
	col = line.split("\t")
	#Also check this syntax too.
	if col[1] == "chrGL000209.1":
		print("CHECK")
	else:
		writefile.write(line + "\n")	

readfile.close()
writefile.close()

