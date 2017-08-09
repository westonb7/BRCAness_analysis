#! /usr/bin/env python
import sys
import re




genFile = open("../gencode.v19.annotation.BROCA2.bed", "r")

for line in genFile:
        line = line.strip()
        line = line.split("\t")
        chrom = line[0]
        gene_start = line[1]
        gene_end = line[2]
        strand = line[3]
        gene_name = line[4]

        gene_start = int(gene_start)
        gene_end = int(gene_end)
        chrm_search = r'chr(\d+)'
        chrm = re.search(chrm_search, chrom)
        chrom = chrm.group(1)
