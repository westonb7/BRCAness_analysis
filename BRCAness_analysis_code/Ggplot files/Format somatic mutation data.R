library(readr)
library(dplyr)
library(ggplot2)
library(reshape)

somatic_mutation_data <- read_tsv("../Data/BRCA_parsed_hg38.txt")
pathogenic_data <- read_tsv("../Data/SomaticMutations_New.txt")

path_brca1 <- filter(pathogenic_data, MutatedGene=="BRCA1")
path_brca2 <- filter(pathogenic_data, MutatedGene=="BRCA2")


Som_stat <- NULL
new_column <- sapply(somatic_mutation_data$Sample, function(x)
{
  Som_stat <- ""
  if (x %in% path_brca1$Sample) Som_stat = "TRUE"
  else if(x %in% path_brca2$Sample) Som_stat = "TRUE"
  else { Som_stat <- "FALSE" }
  return(Som_stat)
})

somatic_mutation_data$Pathogenic <- new_column

somatic_mutation_data_1 <- filter(somatic_mutation_data, Gene=="BRCA1")
somatic_mutation_data_2 <- filter(somatic_mutation_data, Gene=="BRCA2")

som_tester <- rbind(somatic_mutation_data_1, somatic_mutation_data_2)

write.table(som_tester, file="../Data/Somatic_mutations_pathogenic.txt", append= FALSE, quote=FALSE, sep="\t", row.names=FALSE)
