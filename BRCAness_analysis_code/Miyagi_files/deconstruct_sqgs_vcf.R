
#insert code here

library(deconstructSigs)
library(BSgenome.Hsapiens.UCSC.hg38)

print("Hello")

sigs.input = mut.to.sigs.input(mut.ref = "mutec_2_aggregated.hg38.tsv", sample.id = "Sample_ID", chr = "Chromosome", pos = "Position", ref = "Ref", alt = "Alt", bsg = BSgenome.Hsapiens.UCSC.hg38)

print("World")

rowlow <- row.names(sigs.input)
print(attributes(rowlow))

#output_4.sigs = whichSignatures(tumor.ref = sigs.input, signatures.ref = signatures.nature2013, sample.id="TCGA-AC-A5EH", contexts.needed = TRUE, tri.counts.method="exome")

aggregateWeights <- NULL

########
# Note to self: aggregate weights might not be binding properly
########

for (i in 1:nrow(sigs.input)) {
	output.sigs = whichSignatures(tumor.ref = sigs.input, signatures.ref = signatures.nature2013, sample.id=rowlow[i], contexts.needed = TRUE, tri.counts.method="exome")
	aggregateWeights = rbind(aggregateWeights, output.sigs$weights)

}


write.table(aggregateWeights, "aggregate_weights_4.txt", sep="\t", quote=FALSE, col.names=NA)

