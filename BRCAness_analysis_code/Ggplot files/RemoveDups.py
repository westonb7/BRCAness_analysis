import sys, os, glob
from operator import itemgetter, attrgetter

inFile = open("../Data/BRCA_all_brca12_unique.txt")

h = inFile.readline().rstrip("\n").split("\t")
indicesToKeep = [h.index("Sample"), h.index("Chromosome"), h.index("Position"), h.index("Ref"), h.index("Alt"), h.index("Gene"), h.index("ExAC_MAF"), h.index("ExAC_Adj_MAF"), h.index("Variant_Class"), h.index("RefCount_Normal"), h.index("AltCount_Normal"), h.index("RefCount_Tumor"), h.index("AltCount_Tumor")]

rowDict = {}
for line in inFile:
    lineItems = line.rstrip("\n").split("\t")
    lineItems = [lineItems[i] for i in indicesToKeep]
    lineItems[-4] = int(lineItems[-4])
    lineItems[-3] = int(lineItems[-3])
    lineItems[-2] = int(lineItems[-2])
    lineItems[-1] = int(lineItems[-1])

    key = "%s__%s__%s__%s" % tuple(lineItems[:4])

    if key not in rowDict:
        rowDict[key] = []

    rowDict[key].append(lineItems)

inFile.close()

for key, value in rowDict.items():
    value.sort(key=itemgetter(-4, -3), reverse=True)
    rowDict[key] = value[0]

outFile = open("TCGA_BRCA_SomaticMutations_All.txt", 'w')
outFile.write("\t".join([h[i] for i in indicesToKeep]) + "\n")
for key, value in sorted(rowDict.items()):
    outFile.write("\t".join([str(x) for x in value]) + "\n")
outFile.close()
