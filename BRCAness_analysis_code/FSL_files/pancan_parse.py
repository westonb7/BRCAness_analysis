#! /usr/bin/env python
import sys
import re

writefile = open("brca_pancan.txt", "w")


## TO DO: 
##	write the genes (column 1 of PANCAM)
##	iterate through samples list file
##	if a sample has "BRCA" for it's type....
##	then iterate through the PANCAM file
##	write the sample name and the weights for genes

count = 0
sample_count = 0
other_count = 0

writefile.write("Sample_ID\t")
geneFile = open("PANCAN25.IlluminaHiSeq_RNASeqV2.tumor_Rsubread_iGenomes2012_TPM_FeatureCounts.txt", "r")
for line in geneFile:
	#get genes
	if count == 0:
		count += 1
	else:
		line = line.strip()
		line = line.split("\t")
		writefile.write(line[0] + "\t")
geneFile.close()

readfile = open("PANCAN25_CancerType_Samples.txt", "r")
for lines in readfile:
	lines = lines.strip()
	line = lines.split("\t")
	if line[1] == "BRCA":
		count = 0
		sample_index = 0
		other_count = 0
		sample_ID = "Error"
		panFile = open("PANCAN25.IlluminaHiSeq_RNASeqV2.tumor_Rsubread_iGenomes2012_TPM_FeatureCounts.txt", "r")
		for linez in panFile:
			if count == 0:
				linex = linez.split("\t")
				count += 1
				for sample in linex:
					other_count += 1
					if line[0] == sample:
						sample_index = other_count
						sample_ID = sample
						writefile.write("\n" + sample + "\t")
			else:
				if sample_index != 0:
					linex = linez.split("\t")
					writefile.write(linex[sample_index] + "\t")
		panFile.close()
print(other_count)
print(sample_count)

readfile.close()
writefile.close()

