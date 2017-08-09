#!/bin/bash

#rm ./testdir/*.ff
#Rscript --vanilla process_SNP_array.R testdir testdir

# PennCNV
pennCNVDir=/Software/penncnv
dataDir=Data/CNV_SNP_Array/BI__Genome_Wide_SNP_6/Level_1
aptDir=/Software/apt-1.18.0-x86_64-intel-linux/bin
libDir=PennCNVFiles/lib/CD_GenomeWideSNP_6_rev3/Full/GenomeWideSNP_6/LibFiles
hapDir=/Data/TCGA/Germline_CNV/PennCNVFiles/gw6/lib
binDir=/Data/TCGA/Germline_CNV/PennCNVFiles/gw6/bin
aptPennDir=/Data/TCGA/Germline_CNV/PennCNVFiles/apt
splitDir=/Data/TCGA/Germline_CNV/splitHG19Files

#ls $libDir/GenomeWideSNP_6.cdf
#ls $libDir/GenomeWideSNP_6.birdseed.models
#ls $libDir/GenomeWideSNP_6.specialSNPs
#ls PennCNVFiles/CEL
#ls Data/CNV_SNP_Array/BI__Genome_Wide_SNP_6/Level_1

#echo "cel_files" > /tmp/cel_files
#ls -d -1 $dataDir/* >> /tmp/cel_files

#Substep 1.1
#$aptDir/apt-probeset-genotype -c $libDir/GenomeWideSNP_6.cdf -a birdseed --read-models-birdseed $libDir/GenomeWideSNP_6.birdseed.models --special-snps $libDir/GenomeWideSNP_6.specialSNPs --out-dir PennCNVFiles/apt --cel-files /tmp/cel_files

#Substep 1.2
#$aptDir/apt-probeset-summarize --cdf-file $libDir/GenomeWideSNP_6.cdf --analysis quant-norm.sketch=50000,pm-only,med-polish,expr.genotype=true --target-sketch $hapDir/hapmap.quant-norm.normalization-target.txt --out-dir $aptPennDir --cel-files /tmp/cel_files listfile

#fgrep male $aptDir/birdseed.report.txt | cut -f 1,2 > $aptDir/file_sex

#Substep 1.3
#$binDir/generate_affy_geno_cluster.pl $aptPennDir/birdseed.calls.txt $aptPennDir/birdseed.confidences.txt $aptPennDir/quant-norm.pm-only.med-polish.expr.summary.txt -locfile $hapDir/affygw6.hg19.pfb -sexfile $aptPennDir/file_sex -out $binDir/gw6.genocluster

#Substep 1.4
#$binDir/normalize_affy_geno_cluster.pl $binDir/gw6.genocluster $aptPennDir/quant-norm.pm-only.med-polish.expr.summary.txt -locfile $hapDir/affygw6.hg19.pfb -out $binDir/gw6.lrr_baf.txt

#$pennCNVDir/kcolumn.pl $binDir/gw6.lrr_baf.txt split 2 --start_split 2001 --end_split 3000 -tab -head 3 -name -out gw6

#ls /Data/TCGA/Germline_CNV/splitHG19Files > /Data/TCGA/Germline_CNV/splitHG19Files/signallistfile.txt

#source ~/perl5/perlbrew/etc/bashrc
#perlbrew use perl-5.8.8

#perl $pennCNVDir/detect_cnv.pl -test -hmm $hapDir/affygw6.hmm -pfb $hapDir/affygw6.hg19.pfb -list $splitDir/signallistfile.txt -log gw6_HG_19.log -out gw6_HG_19.rawcnv

#$pennCNVDir/visualize_cnv.pl -format plot -signal $splitDir/gw6.WRIED_p_TCGA_143_147_150_Hahn_N_GenomeWideSNP_6_A05_799860 gw6_HG_19.rawcnv 


