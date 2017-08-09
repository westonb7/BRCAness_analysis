
#insert code here

library(deconstructSigs)

sigs.input = mut.to.sigs.input(mut.ref = "mutation_2test_edit", sample.id = "sample", chr = "chr", pos = "start", ref = "reference", alt = "alt")

#print(head(sigs.input))

rowlow <- row.names(sigs.input)
print(attributes(rowlow))

#output_1.sigs = whichSignatures(tumor.ref = sigs.input, signatures.ref = signatures.nature2013, sample.id="TCGA-AN-A0XU-01", contexts.needed = TRUE, tri.counts.method="exome")

#output_2.sigs = whichSignatures(tumor.ref = sigs.input, signatures.ref = signatures.nature2013, sample.id="TCGA-D8-A27M-01", contexts.needed = TRUE, tri.counts.method="exome")

#output_3.sigs = whichSignatures(tumor.ref = sigs.input, signatures.ref = signatures.nature2013, sample.id="TCGA-BH-A0WA-01", contexts.needed = TRUE, tri.counts.method="exome")

#output_4.sigs = whichSignatures(tumor.ref = sigs.input, signatures.ref = signatures.nature2013, sample.id="TCGA-AC-A5EH", contexts.needed = TRUE, tri.counts.method="exome")


aggregateWeights <- NULL

########
# Note to self: aggregate weights might not be binding properly
########

for (i in 1:nrow(sigs.input)) {
	output.sigs = whichSignatures(tumor.ref = sigs.input, signatures.ref = signatures.nature2013, sample.id=rowlow[i], contexts.needed = TRUE, tri.counts.method="exome")
	aggregateWeights = rbind(aggregateWeights, output.sigs$weights)

}

#print(aggregateWeights)

write.table(aggregateWeights, "aggregate_weights_2.txt", sep="\t", quote=FALSE, col.names=NA)

#write(aggregateWeights, file = "aggregate_weights.txt")
#print("Quick")

#lapply(aggregateWeights, write, "aggregate_weights.txt", append=TRUE, ncolumns= 1000)

#print("Fox")

#LS.df = as.data.frame(do.call(rbind, LS))

#pdf("signature_plot_1.pdf", width = 12, height = 6) 
#graphics.off

#makePie(output.sigs)
#plotSignatures(output_1.sigs)

#pdf("signature_plot_2.pdf", width = 12, height = 6)
#graphics.off
#plotSignatures(output_2.sigs)

#pdf("signature_plot_3.pdf", width = 12, height = 6)
#graphics.off
#plotSignatures(output_3.sigs)

#pdf("signature_plot_4.pdf", width = 5, height = 5)
#graphics.off
#plotSignatures(output_4.sigs)

#write(output.sigs, file = "deconstruct_output.txt", append = FALSE, ncolumns = if(is.character(output.sigs)) 1 else 5, sep = "\t")



