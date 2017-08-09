#! /usr/bin/env python
import sys
import re


readList = open("gw6_HG_19.log", "r")
writefile = open("gw6_val.log", "w")

counter = 0
total = 0

for line in readList:
        #search = r'(gw6\.\w+)' 
        #score_search = r'((\d\.\d+))'
        line = line.strip()

        readRaw = open("quality_list.txt", "r")
        for rawLine in readRaw:
                rawLine = rawLine.strip()
                if rawLine in line:
                        writefile.write(line + "\n")                    
        readRaw.close()


readList.close()
writefile.close()

