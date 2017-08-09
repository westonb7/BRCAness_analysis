
inDirPath = commandArgs()[7]
outDirPath = commandArgs()[8]

library(oligoClasses)
library2(crlmm)
library2(ff)

cdfName <- "genomewidesnp6"

ldPath(outDirPath)

ocProbesets(100000)
ocSamples(200)

celFiles <- list.celfiles(inDirPath, full.names=TRUE, pattern=".CEL")

#batches = c("batch1", "batch1")
batches = c(rep("batch1", 10), rep("batch2", 10))

cnSet <- constructAffyCNSet(celFiles, batch=batches, cdfName=cdfName, genome="hg19")

cnrmaAffy(cnSet)

validCEL(celFiles)
snprmaAffy(cnSet)
#genotypeAffy(cnSet, gender=NULL)
genotypeAffy(cnSet)
table(c("male", "female")[cnSet$gender[]])

print(cnSet)
print(object.size(cnSet), units="Mb")

#The following code makes a histogram of the SNR (signal-to-noise ratio) values for HapMap samples

library(lattice)
invisible(open(cnSet$SNR))
snr <- cnSet$SNR[]
close(cnSet$SNR)

print(histogram(~snr, panel=function(...){ panel.histogram(...)}, breaks=25, xlim=range(snr), xlab="SNR"))

#This code fits a linear model to the normalized intensities.
crlmmCopynumber(cnSet)

#This code was directly copy and pasted from the vignette
nms <- ls(batchStatistics(cnSet))
cls <- rep(NA, length(nms))
for(i in seq_along(nms)) cls[i] <- class(batchStatistics(cnSet)[[nms[i]]])[1] 
all(cls == "ff_matrix")

#This code was directly copy and pasted from the vignette
chr1.index <- which(chromosome(cnSet) == 1)
open(cnSet)

#This seems to be a near repeat of the above code, but with some variables changed
cnSet2 <- cnSet[chr1.index, ]
close(cnSet)
for(i in seq_along(nms)) cls[i] <- class(batchStatistics(cnSet2)[[nms[i]]])[1] 
all(cls == "matrix")

#I set the which(chromosome(cnSet) variable to 17 to check for copy number variants on that chromosome. the vignette uses 20 for the example
#tmp <- totalCopynumber(cnSet, i=seq_len(nrow(cnSet)), j=1:2)
#dim(tmp)
#tmp2 <- totalCopynumber(cnSet, i=which(chromosome(cnSet) == 17), j=seq_len(ncol(cnSet))) 
#dim(tmp2)

#snp.index <- which(isSnp(cnSet) & !is.na(chromosome(cnSet)))
#ca <- CA(cnSet, i=snp.index, j=1:2)
#cb <- CB(cnSet, i=snp.index, j=1:2)

#It seems this code is for creating a container for log R ratios and B allele frequencies
library(VanillaICE)
open(cnSet)
oligoSetList <- BafLrrSetList(cnSet)
close(cnSet)
show(oligoSetList)
class(oligoSetList)
## oligoSnpSet of first chromosome
oligoSetList[[1]]

hmmOpts <- hmm.setup(tmp2, c("hom-del", "hem-del", "normal", "amp"), copynumberStates = c(0:3), normalIndex = 3, log.initialP = rep(log(1/4), 4), prGenotypeHomozygous = c(0.8, 0.99, 0.7, 0.75))

fit.cn <- hmm(tmp2, hmmOpts, verbose = FALSE, TAUP = 1e+10)
hmm.df <- as.data.frame(fit.cn)
print(hmm.df[, c(2:4, 7:9)])



#This code is for retrieving the log R ratios and B allele frequencies by lrr and baf accessors
#lrrList <- lrr(oligoSetList)
#class(lrrList)
#class(lrrList[[1]])
#print(lrrList[[1]])
#stop()
#dim(lrrList[[1]]) ## log R ratios for chromosome 1.
#bafList <- baf(oligoSetList)
#dim(bafList[[1]]) ## B allele frequencies for chromosome 1

#This is my second attempt at getting to the chart shown in the paper

print("test 1")


cnSet$celFiles <- sampleNames(cnSet)
#sampleNames(cnSet) <- getHapMapIds(cnSet)
sampleNames(cnSet)[1:5]


marker.index <- which(chromosome(cnSet) == 8)
sample.index <- match("NA19007", sampleNames(cnSet))
batch.index <- which(batch(cnSet) == batch(cnSet)[sample.index])
invisible(open(cnSet))
shelfSet <- cnSet[marker.index, batch.index]
shelfSet <- shelfSet[order(position(shelfSet)), ]
invisible(close(cnSet))
dup.index <- which(duplicated(position(shelfSet)))
if (length(dup.index) > 0) shelfSet <- shelfSet[-dup.index, ]

print("test 2")

tcn <- rawCopynumber(shelfSet, i = seq(length = nrow(shelfSet)), j = seq(length = ncol(shelfSet)))
sds <- robustSds(tcn)

print("test 3")

sample.index <- match("NA19007", sampleNames(shelfSet))
j <- match("NA19007", sampleNames(shelfSet))
redonSet <- new("oligoSnpSet", copyNumber = tcn[, j, drop = FALSE], cnConfidence = 1/sds[, j, drop = FALSE], call = as.matrix(calls(shelfSet)[, j, drop = FALSE]), callProbability = as.matrix(snpCallProbability(shelfSet)[, j, drop = FALSE]), phenoData = phenoData(shelfSet)[j, ], featureData = featureData(shelfSet))

print("test 4")

copyNumber(redonSet) <- copyNumber(redonSet) - median(copyNumber(redonSet),na.rm = TRUE) + 2

hmmOpts <- hmm.setup(redonSet, c("hom-del", "hem-del", "normal", "amp"), copynumberStates = c(0:3), normalIndex = 3, log.initialP = rep(log(1/4), 4), prGenotypeHomozygous = c(0.8, 0.99, 0.7, 0.75))

fit.cn <- hmm(redonSet, hmmOpts, verbose = FALSE, TAUP = 1e+10)
hmm.df <- as.data.frame(fit.cn)
print(hmm.df[, c(2:4, 7:9)])




