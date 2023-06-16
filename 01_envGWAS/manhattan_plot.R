#!/usr/bin/env Rscript
# This script is used to produce manathan plot for enGWAS output
# It will also produce tables of candidates loci using a Boneferoni threshold
# rakakpo
# 06/24/2022

print("loading libraries")
library(RColorBrewer); cols <- brewer.pal(12,"Set3")
library(qqman)
library(Cairo)
library(qvalue)
library(ggplot2)

#setwd("~/MorrellLab Dropbox/Roland Akakpo/IITA_CORE_DATA/cowpea_gwas-main/envGWAS/")

# list of clim variable 
phenoName=c("TMIN", "TMAX", "PREC")#, "BIO12", "BIO13", "BIO14", "BIO15", "BIO16", "BIO17", "BIO18", "BIO19", "BIO2", "BIO3", "BIO4", "BIO5", "BIO6", "BIO7", "BIO8", "BIO9")


#read output result and write clean reslt for manhatan plot
for (pheno_variable in phenoName ){
###Load output from Gemma
#pheno_variable='BIO1'
dir_file <- paste0(pheno_variable,"/results/")
file.name <- paste0(pheno_variable,".assoc.clean.txt")
path.file <- paste(dir_file, file.name, sep="")
gwas.results <- read.delim(path.file, sep="\t")
gwas.results[43210:43242,1]="12"
gwas.results$CHR <- as.numeric(gwas.results$CHR)
#### Manhattan plots ####
print("Manhattan plots")
#Get a vector of the SNPs with significant value and display the Manhattan plot with bonferroni threshold 
# Select SNPs above the Bonferroni corrected p-value threshold by using the argument "bonferroni"

# Calculate Bonferroni threshold with risk 5%

## Get total number of SNPs
nb_snps <- dim(gwas.results)[[1]]
## Calculate Bonferroni corrected P-value threshold
bonferroni_threshold <- 0.05/nb_snps
threshold_pvalue <- bonferroni_threshold
  
### Saving candidates lists ####
print("saving candidates lists")
gwas_significant <- subset(gwas.results, P < threshold_pvalue)
write.csv(gwas_significant, file=paste0(dir_file,"Candidates_",pheno_variable,".csv"), row.names = FALSE)
write.csv(gwas.results, file=paste0(dir_file,"All_SNP_Results_",pheno_variable,".csv"), row.names = FALSE)
###Saviing  plot

##Suggestive line = Bonferroni corrected P-value threshold => blue line

#### PDF format #####
pdf(paste0(dir_file,"manhattan_plots_", pheno_variable,".pdf"), paper = 'A4') # File name
par(mfrow=c(2,1))
manhattan(gwas.results, highlight=NULL, main=pheno_variable, suggestiveline = -log10(threshold_pvalue), genomewideline = FALSE)
###QQ plot of the p-values
qq(gwas.results$P, main=pheno_variable)
dev.off() 

#### PNG format #####

CairoPNG(paste0(dir_file,"manhattan_plots_", pheno_variable,".png"), units = "cm",width = 21,height = 29.7,res = 600) # File name
par(mfrow=c(2,1))
manhattan(gwas.results, highlight=NULL, main=pheno_variable, suggestiveline = -log10(threshold_pvalue), genomewideline = FALSE)
###QQ plot of the p-values
qq(gwas.results$P, main=pheno_variable)
dev.off() 

#### TIFF format #####

tiff(paste0(dir_file,"manhattan_plots_", pheno_variable,".tiff"), units = "cm",width = 21,height = 29.7,res = 600) # File name
par(mfrow=c(2,1))
manhattan(gwas.results, highlight=NULL, main=pheno_variable, suggestiveline = -log10(threshold_pvalue), genomewideline = FALSE)
###QQ plot of the p-values
qq(gwas.results$P, main=pheno_variable)
dev.off() 
}
getwd()
