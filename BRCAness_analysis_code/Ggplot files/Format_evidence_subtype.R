library(readr)
library(dplyr)

## This script was used to format data for use in several other figure-generating plots, 
##   some of which are no longer used.

## Generate the brca_gen_like files

TCGASubtypeData <- (read_tsv("../Data/TCGA_Subtypes_Mutations_BasicTabFormatted.txt"))
TCGASubtypeData <- TCGASubtypeData[,colSums(is.na(TCGASubtypeData))<nrow(TCGASubtypeData)]

HRR_genes <- c("BRCA1", "BRCA2", "RAD51", "RAD51B", "RAD51D", "DMC1", "XRCC2", "XRCC3", "RAD52", "RAD54L", "RAD54B", "SHFM1", "RAD50", "MRE11A", "NBN", "RBBP8", "MUS81", "EME1", "EME2", "GIYD1", "GIYD2", "GEN1", "CHEK2", "ATM", "TP53", "CDH1", "BRIP1")

germlineMutationData <- read_tsv("../Data/germline_snv_indel.tsv")
germlineMutationFrequencies <- table(germlineMutationData$Gene)

germlineMutationPlotData <- filter(germlineMutationData, Gene %in% HRR_genes)
germlineMutationPlotData$Gene <- factor(germlineMutationPlotData$Gene)

germlineSampleNames <- cbind(germlineMutationPlotData$Sample_ID)

subtypeSamples <- sort(unique(TCGASubtypeData$Patient_ID))
subtypeCategory <- unique(sort(TCGASubtypeData$PAM50))
subtypeData <- filter(TCGASubtypeData, PAM50 %in% subtypeCategory)
subtypeData2 <- filter(subtypeData, Gene %in% HRR_genes)

subtypeDataFrame <- NULL

comboContainer <- inner_join(subtypeData, germlineMutationPlotData)

subtypeGermlinePlotData <- filter(comboContainer, Gene %in% HRR_genes)

subtypeGermlinePlotData$Gene <- factor(subtypeGermlinePlotData$Gene)

cat_data <- (read_tsv("../Data/rtsne_evidence_more_germ.txt"))

Som_stat <- NULL
new_column <- sapply(cat_data$BRCA_evidence, function(x)
{
  Som_stat <- ""
  if (is.na(x)) { Som_stat <- "Other" }
  else if(x == "Deletion_BRCA1") { Som_stat <- "BRCA_like" }
  else if(x == "Deletion_BRCA2") { Som_stat <- "BRCA_like" }
  else if(x == "Germline_BRCA1_mutation") { Som_stat <- "BRCA" }
  else if(x == "Germline_BRCA2_mutation") { Som_stat <- "BRCA" }
  else if(x == "Methylation_BRCA1") { Som_stat <- "BRCA_like" }
  else if(x == "Methylation_BRCA2") { Som_stat <- "BRCA_like" }
  else if(x == "Somatic_BRCA1_mutation") { Som_stat <- "BRCA_like" }
  else if(x == "Somatic_BRCA2_mutation") { Som_stat <- "BRCA_like" }
  else { Som_stat <- "Other" }
  return(Som_stat)
})

cat_data$BRCA_like <- new_column

bat_data <- (read_tsv("../Data/rtsne_mut_more_germ.txt"))

Som_stat <- NULL
new_column <- sapply(bat_data$BRCA_evidence, function(x)
{
  Som_stat <- ""
  if (is.na(x)) { Som_stat <- "Other" }
  else if(x == "Deletion_BRCA1") { Som_stat <- "BRCA_like" }
  else if(x == "Deletion_BRCA2") { Som_stat <- "BRCA_like" }
  else if(x == "Germline_BRCA1_mutation") { Som_stat <- "BRCA" }
  else if(x == "Germline_BRCA2_mutation") { Som_stat <- "BRCA" }
  else if(x == "Methylation_BRCA1") { Som_stat <- "BRCA_like" }
  else if(x == "Methylation_BRCA2") { Som_stat <- "BRCA_like" }
  else if(x == "Somatic_BRCA1_mutation") { Som_stat <- "BRCA_like" }
  else if(x == "Somatic_BRCA2_mutation") { Som_stat <- "BRCA_like" }
  else { Som_stat <- "Other" }
  return(Som_stat)
})

bat_data$BRCA_like <- new_column

write.table(cat_data, file="../Data/rtsne_gen_like.txt", append= FALSE, quote=FALSE, sep="\t", row.names=FALSE)
write.table(bat_data, file="../Data/rtsne_mut_like.txt", append= FALSE, quote=FALSE, sep="\t", row.names=FALSE)


## Generate more files

evidence_data <- read_tsv("../Data/rtsne_evidence_addition.txt")
new_som_data <- read_tsv("../Data/TCGA_BRCA_SomaticMutations_Filtered_bhs - TCGA_BRCA_SomaticMutations_Filt.tsv")
new_som_data1 <- new_som_data[,1:16]
new_som_data1 <- subset(new_som_data1, c(Sample, Pathogenicity))
colnames(new_som_data1) <- c("Sample_ID", "Pathogenicity")

TCGASubtypeData <- (read_tsv("../Data/TCGA_Subtypes_Mutations_BasicTabFormatted.txt"))
TCGASubtypeData <- TCGASubtypeData[,colSums(is.na(TCGASubtypeData))<nrow(TCGASubtypeData)]
subtypeCategory <- unique(sort(TCGASubtypeData$PAM50))
subtypeData <- filter(TCGASubtypeData, PAM50 %in% subtypeCategory)

colnames(subtypeData)[1] <- "Sample_ID"

reduced_sub_data <- c(subtypeData[,1], subtypeData[,10])

evidence_data <- as.data.frame(evidence_data)
reduced_sub_data <- as.data.frame(reduced_sub_data)

new_evidence <- left_join(evidence_data, reduced_sub_data)
new_evidence <- unique(new_evidence)

Som_stat <- NULL
new_column <- sapply(evidence_data$BRCA_evidence, function(x)
{
  Som_stat <- ""
  if (x == "Deletion_BRCA1") { Som_stat <- "BRCA1" }
  else if(x == "Somatic_BRCA1_mutation") { Som_stat <- "BRCA1" }
  else if(x == "Deletion_BRCA2") { Som_stat <- "BRCA2" }
  else if(x == "Somatic_BRCA2_mutation") { Som_stat <- "BRCA2" }
  else { Som_stat <- "N" }
  return(Som_stat)
})

evidence_data$DelSom <- new_column

write.table(new_evidence, file="../Data/rtsne_evidence_addition.txt", append= FALSE, quote=FALSE, sep="\t", row.names=FALSE)

##  Create a new column with information about any germline mutation, including BRCA1/2 and all non-BRCA1/2

germline_m_data <- read_tsv("../Data/germline_snv_indel.tsv")
germline_short_data <- germline_m_data[,1:2]
colnames(germline_short_data) <- c("Sample_ID", "Other_g_mutation")

evidence_more_extra <- left_join(evidence_data, germline_short_data, by="Sample_ID")
write.table(evidence_more_extra, file="../Data/rtsne_evidence_more_germ.txt", append= FALSE, quote=FALSE, sep="\t", row.names=FALSE)

## a little more editing

rtsne_more <- read_tsv("../Data/rtsne_evidence_more_germ.txt")

Som_stat <- NULL
new_column <- sapply(rtsne_more$Other_g_mutation, function(x)
{
  Som_stat <- ""
  if (is.na(x)) { Som_stat <- "None" }
  else if(x == "BRCA1") { Som_stat <- "BRCA1" }
  else if(x == "BRCA2") { Som_stat <- "BRCA2" }
  else if(x == "ATM") { Som_stat <- "ATM" }
  else if(x == "BARD1") { Som_stat <- "Other" }
  else if(x == "BRIP1") { Som_stat <- "Other" }
  else if(x == "CDH1") { Som_stat <- "Other" }
  else if(x == "CHEK2") { Som_stat <- "CHEK2" }
  else if(x == "PALB2") { Som_stat <- "Other" }
  else if(x == "PTEN") { Som_stat <- "Other" }
  else if(x == "RAD51B") { Som_stat <- "RAD51B" }
  else if(x == "RAD51C") { Som_stat <- "RAD51C" }
  else if(x == "SLX4") { Som_stat <- "Other" }
  else if(x == "TP53") { Som_stat <- "Other" }
  else if(x == "XRCC2") { Som_stat <- "Other" }
  else { Som_stat <- "None" }
  return(Som_stat)
})

rtsne_more$Short_germ_1 <- new_column

write.table(rtsne_more, file="../Data/rtsne_evidence_more_germ.txt", append= FALSE, quote=FALSE, sep="\t", row.names=FALSE)

Som_stat <- NULL
new_column <- sapply(rtsne_more$Other_g_mutation, function(x)
{
  Som_stat <- ""
  if (is.na(x)) { Som_stat <- "None" }
  else if(x == "BRCA1") { Som_stat <- "BRCA1" }
  else if(x == "BRCA2") { Som_stat <- "BRCA2" }
  else if(x == "ATM") { Som_stat <- "ATM" }
  else if(x == "BARD1") { Som_stat <- "None" }
  else if(x == "BRIP1") { Som_stat <- "None" }
  else if(x == "CDH1") { Som_stat <- "None" }
  else if(x == "CHEK2") { Som_stat <- "CHEK2" }
  else if(x == "PALB2") { Som_stat <- "None" }
  else if(x == "PTEN") { Som_stat <- "None" }
  else if(x == "RAD51B") { Som_stat <- "RAD51B" }
  else if(x == "RAD51C") { Som_stat <- "RAD51C" }
  else if(x == "SLX4") { Som_stat <- "None" }
  else if(x == "TP53") { Som_stat <- "None" }
  else if(x == "XRCC2") { Som_stat <- "None" }
  else { Som_stat <- "None" }
  return(Som_stat)
})

rtsne_more$Short_germ_2 <- new_column
write.table(rtsne_more, file="../Data/rtsne_evidence_more_germ.txt", append= FALSE, quote=FALSE, sep="\t", row.names=FALSE)

##  Do the same thing but for mutation signature data

mut_data <- read_tsv("../Data/rtsne_mut_sig_addition.txt")

germline_m_data <- read_tsv("../Data/germline_snv_indel.tsv")
germline_short_data <- germline_m_data[,1:2]
colnames(germline_short_data) <- c("Sample_ID", "Other_g_mutation")

evidence_more_mut <- left_join(mut_data, germline_short_data, by="Sample_ID")
write.table(evidence_more_mut, file="../Data/rtsne_mut_more_germ.txt", append= FALSE, quote=FALSE, sep="\t", row.names=FALSE)

## Just a bit more editing

rtsne_more_mut <- read_tsv("../Data/rtsne_mut_more_germ.txt")

Som_stat <- NULL
new_column <- sapply(rtsne_more_mut$Other_g_mutation, function(x)
{
  Som_stat <- ""
  if (is.na(x)) { Som_stat <- "None" }
  else if(x == "BRCA1") { Som_stat <- "BRCA1" }
  else if(x == "BRCA2") { Som_stat <- "BRCA2" }
  else if(x == "ATM") { Som_stat <- "ATM" }
  else if(x == "BARD1") { Som_stat <- "Other" }
  else if(x == "BRIP1") { Som_stat <- "Other" }
  else if(x == "CDH1") { Som_stat <- "Other" }
  else if(x == "CHEK2") { Som_stat <- "CHEK2" }
  else if(x == "PALB2") { Som_stat <- "PALB2" }
  else if(x == "PTEN") { Som_stat <- "Other" }
  else if(x == "RAD51B") { Som_stat <- "Other" }
  else if(x == "RAD51C") { Som_stat <- "Other" }
  else if(x == "SLX4") { Som_stat <- "Other" }
  else if(x == "TP53") { Som_stat <- "Other" }
  else if(x == "XRCC2") { Som_stat <- "Other" }
  else { Som_stat <- "None" }
  return(Som_stat)
})

rtsne_more_mut$Short_germ_1 <- new_column

write.table(rtsne_more_mut, file="../Data/rtsne_mut_more_germ.txt", append= FALSE, quote=FALSE, sep="\t", row.names=FALSE)

Som_stat <- NULL
new_column <- sapply(rtsne_more_mut$Other_g_mutation, function(x)
{
  Som_stat <- ""
  if (is.na(x)) { Som_stat <- "None" }
  else if(x == "BRCA1") { Som_stat <- "BRCA1" }
  else if(x == "BRCA2") { Som_stat <- "BRCA2" }
  else if(x == "ATM") { Som_stat <- "ATM" }
  else if(x == "BARD1") { Som_stat <- "None" }
  else if(x == "BRIP1") { Som_stat <- "None" }
  else if(x == "CDH1") { Som_stat <- "None" }
  else if(x == "CHEK2") { Som_stat <- "CHEK2" }
  else if(x == "PALB2") { Som_stat <- "PALB2" }
  else if(x == "PTEN") { Som_stat <- "None" }
  else if(x == "RAD51B") { Som_stat <- "RAD51B" }
  else if(x == "RAD51C") { Som_stat <- "RAD51C" }
  else if(x == "SLX4") { Som_stat <- "None" }
  else if(x == "TP53") { Som_stat <- "None" }
  else if(x == "XRCC2") { Som_stat <- "None" }
  else { Som_stat <- "None" }
  return(Som_stat)
})

rtsne_more_mut$Short_germ_2 <- new_column
write.table(rtsne_more_mut, file="../Data/rtsne_mut_more_germ.txt", append= FALSE, quote=FALSE, sep="\t", row.names=FALSE)

## Incorporating the new somatic filtered data, it's going to look messy here

rtsne_more <- read_tsv("../Data/rtsne_gen_like.txt")
rtsne_more_mut <- read_tsv("../Data/rtsne_mut_like.txt")

rtsne_more_mut_1 <- left_join(rtsne_more_mut, new_som_data1)
rtsne_more_1 <- left_join(rtsne_more, new_som_data1)


Som_stat <- NULL
extraFunc <- function(x,y)
{
  Som_stat <- ""
  if (is.na(x)) { Som_stat <- "N" }
  else if(x == "1" && y == "S1") { Som_stat <- "S1" }
  else if(x == "1" && y == "S2") { Som_stat <- "S2" }
  else if(x == "0") { Som_stat <- "N" }
  else { Som_stat <- "N" }
  return(Som_stat)
}

new_column <- mapply(extraFunc, rtsne_more_mut_1$Pathogenicity, rtsne_more_mut_1$Som)
rtsne_more_mut_1$Som_1 <- new_column

new_column <- mapply(extraFunc, rtsne_more_1$Pathogenicity, rtsne_more_1$Som)
rtsne_more_1$Som_1 <- new_column

rtsne_more_1 <- rtsne_more_1[,-8]
colnames(rtsne_more_1)[21] <- c("Som")

rtsne_more_mut_1 <- rtsne_more_mut_1[,-8]
colnames(rtsne_more_mut_1)[19] <- c("Som")

## Regenerate previously derived information based on somatic mutation info

#rtsne_more_mut_1 <- read_tsv("../Data/rtsne_more_m_shirt.txt")
#rtsne_more_1 <- read_tsv("../Data/rtsne_more_g_shirt.txt")

rtsne_more_1 <- within(rtsne_more_1, B1A[B1A == 'S' & Som != 'S1'] <- 'N')
rtsne_more_1 <- within(rtsne_more_1, B2A[B2A == 'S' & Som != 'S2'] <- 'N')
rtsne_more_1 <- within(rtsne_more_1, AnyBRCA1[AnyBRCA1 == 'Y' & B1A == 'N' ] <- 'N')
rtsne_more_1 <- within(rtsne_more_1, AnyBRCA2[AnyBRCA2 == 'Y' & B2A == 'N'] <- 'N')
rtsne_more_1 <- within(rtsne_more_1, Aberration[Aberration == 'BRCA1' & B1A == 'N'] <- 'N')
rtsne_more_1 <- within(rtsne_more_1, Aberration[Aberration == 'BRCA2' & B2A == 'N'] <- 'N')
rtsne_more_1 <- within(rtsne_more_1, BRCA_like[BRCA_like == 'BRCA_like' & B2A == 'N' & B1A == 'N'] <- 'Other')
rtsne_more_1 <- within(rtsne_more_1, BRCA_evidence[BRCA_evidence == 'Somatic_BRCA1_mutation' & B1A == 'N'] <- 'None')
rtsne_more_1 <- within(rtsne_more_1, BRCA_evidence[BRCA_evidence == 'Somatic_BRCA2_mutation' & B2A == 'N'] <- 'None')

rtsne_more_mut_1 <- within(rtsne_more_mut_1, B1A[B1A == 'S' & Som != 'S1'] <- 'N')
rtsne_more_mut_1 <- within(rtsne_more_mut_1, B2A[B2A == 'S' & Som != 'S2'] <- 'N')
rtsne_more_mut_1 <- within(rtsne_more_mut_1, AnyBRCA1[AnyBRCA1 == 'Y' & B1A == 'N' ] <- 'N')
rtsne_more_mut_1 <- within(rtsne_more_mut_1, AnyBRCA2[AnyBRCA2 == 'Y' & B2A == 'N'] <- 'N')
rtsne_more_mut_1 <- within(rtsne_more_mut_1, Aberration[Aberration == 'BRCA1' & B1A == 'N'] <- 'N')
rtsne_more_mut_1 <- within(rtsne_more_mut_1, Aberration[Aberration == 'BRCA2' & B2A == 'N'] <- 'N')
rtsne_more_mut_1 <- within(rtsne_more_mut_1, BRCA_like[BRCA_like == 'BRCA_like' & B2A == 'N' & B1A == 'N'] <- 'Other')
rtsne_more_mut_1 <- within(rtsne_more_mut_1, BRCA_evidence[BRCA_evidence == 'Somatic_BRCA1_mutation' & B1A == 'N'] <- 'None')
rtsne_more_mut_1 <- within(rtsne_more_mut_1, BRCA_evidence[BRCA_evidence == 'Somatic_BRCA2_mutation' & B2A == 'N'] <- 'None')

write.table(rtsne_more_mut_1, file="../Data/rtsne_more_m_shirt.txt", append= FALSE, quote=FALSE, sep="\t", row.names=FALSE)
write.table(rtsne_more_1, file="../Data/rtsne_more_g_shirt.txt", append= FALSE, quote=FALSE, sep="\t", row.names=FALSE)

