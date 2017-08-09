
#insert code here

#library(deconstructSigs)
library(BSgenome)

print("Hello")

mut.to.sigs.input = function(mut.ref, sample.id = 'Sample', chr = 'chr', pos = 'pos', ref = 'ref', alt = 'alt', bsg = NULL){
  
  if(exists("mut.ref", mode = "list")){
    mut.full <- mut.ref
  } else {
    if(file.exists(mut.ref)){
      mut.full <- utils::read.table(mut.ref, sep = "\t", header = TRUE, as.is = FALSE, check.names = FALSE)
    } else {
      stop("mut.ref is neither a file nor a loaded data frame")
    }
  }
  
  mut <- mut.full[,c(sample.id, chr, pos, ref, alt)]
  
  # Only take SNPs for now
  #mut.lengths <- with(mut, nchar(as.character(mut[,ref])))
  #mut.lengths <- with(mut, nchar(as.character(ref)))
  #mut <- mut[which(mut.lengths == 1),]
  #mut$mut.lengths <- nchar(as.character(mut[, ref]))
  mut             <- mut[which(mut[, ref] %in% c('A', 'T', 'C', 'G') & mut[, alt] %in% c('A', 'T', 'C', 'G')),]
  
  # Fix the chromosome names (in case they come from Ensembl instead of UCSC)
  mut[, chr] <- factor(mut[, chr])
  levels(mut[, chr]) <- sub("^([0-9XY])", "chr\\1", levels(mut[, chr]))
  levels(mut[, chr]) <- sub("^MT", "chrM", levels(mut[, chr]))
  levels(mut[, chr]) <- sub("^(GL[0-9]+).[0-9]", "chrUn_\\L\\1", levels(mut[, chr]), perl = T)

  # Check the genome version the user wants to use
  # If set to default, carry on happily
  if(is.null(bsg)){
    # Remove any entry in chromosomes that do not exist in the BSgenome.Hsapiens.UCSC.hg19::Hsapiens object    
    unknown.regions <- levels(mut[, chr])[which(!(levels(mut[, chr]) %in% GenomeInfoDb::seqnames(BSgenome.Hsapiens.UCSC.hg19::Hsapiens)))]
    if (length(unknown.regions) > 0) {
      unknown.regions <- paste(unknown.regions, collapse = ',\ ')
      warning(paste('Check chr names -- not all match BSgenome.Hsapiens.UCSC.hg19::Hsapiens object:\n', unknown.regions, sep = ' '))      
      mut <- mut[mut[, chr] %in% GenomeInfoDb::seqnames(BSgenome.Hsapiens.UCSC.hg19::Hsapiens), ]
    }
    # Add in context
    mut$context = BSgenome::getSeq(BSgenome.Hsapiens.UCSC.hg19::Hsapiens, mut[,chr], mut[,pos]-1, mut[,pos]+1, as.character = T)
  }


