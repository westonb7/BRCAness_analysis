
inDirPath = commandArgs()[7]
outDirPath = commandArgs()[8]

library(ff)
library(crlmm)

pkgs <- annotationPackages()
crlmm.pkgs <- pkgs[grep("Crlmm", pkgs)]
crlmm.pkgs[grep("human", crlmm.pkgs)]

#The 'ocSamples' and 'ocProbesets' functions (from oligoClasses) are used to declare how many markers and smaples to read at once. 
#Smaller numbers will reduce needed ram, but increase run-time.
#Default settings can be checked by typing commands without parameters

#ocProbesets(50e3)
#ocSamples(200)

#There are two approaches to making a CNSet container:
#1: Using the 'genotype' call for 'constructAffy'
#2: using the '[' method.

####
#
# Note: below I put in "commented-out" versions of both approaches. 
# You will need to come back to adjust this later.
#
####

comment_approach_1='

ldPath(outdir)
if(!file.exists(outdir)) dir.create(outdir)
require(genomewidesnp6Crlmm) & require(hapmapsnp6)
path <- system.file("celFiles", package="hapmapsnp6")
celfiles <- list.celfiles(path, full.names=TRUE)
exampleSet <- genotype(celfiles, batch=rep("1", 3), cdfName="genomewidesnp6")
ldPath()
tmp <- crlmm:::constructAffy(celfiles, batch=rep("1", 3), cdfName="genomewidesnp6")
invisible(open(exampleSet))
exampleSet

invisible(open(exampleSet))
class(A(exampleSet))
filename(A(exampleSet))
as.matrix(A(exampleSet)[1:5, ])
(A(exampleSet))[1:5, ]

'
comment_approach_2='

cnset.subset <- exampleSet[1:5, ]
show(cnset.subset)

'

#Will need to replace "exampleSet" with the appropriate variable
library(Biobase)
fvarLabels(exampleSet)

position(exampleSet)[1:10]
chromosome(exampleSet)[1:10]

is.snp <- isSnp(exampleSet)
table(is.snp)

snp.index <- which(is.snp)
np.index <- which(!is.snp)
chr1.index <- which(chromosome(exampleSet) == 1)

ls(assayData(exampleSet))

scores <- as.matrix(snpCallProbability(exampleSet)[1:5, 1:2])
i2p(scores)

batch(exampleSet)

#Note: the following commands might need to be edited, since all the subjects are female

varLabels(exampleSet)
class(exampleSet$gender)
invisible(open(exampleSet$gender))
exampleSet$gender
c("male", "female")[exampleSet$gender[]]
invisible(close(exampleSet$gender))
varLabels(protocolData(exampleSet))
protocolData(exampleSet)$ScanDate







