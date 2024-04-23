## Introduction

# This is a script is used to convert from plink PED file to 012 file and impute the datafile for association analysis based on DIPLOID data

# We assume that the required libraries are already present on the system.
library(LEA)
library(data.table)
library(trio)
### Genomic data
### Getting the data

#### set working directory
setwd("~/MorrellLab Dropbox/Roland Akakpo/Cowpea_Environmental_assoc/envGWAS_Current/R_PROG/")
### convert the data and reformat to a 012 matrix with missing data coded as 9
#### and save geno file in the work directory in lfmm format
ped2lfmm("./Data/Cowpea_GF_Data.ped")

#### Saving list of ID and loci
if((dir.exists("./generated_files")==FALSE)){dir.create("./generated_files")}
ind=read.table("./Data/Cowpea_GF_Data.nosex", h=F, sep="\t")[,1]
snp=read.table("./Data/Cowpea_GF_Data.map", h=F, sep="\t")[,c(1,4,2)]
write.table(ind,file=paste0("./Data/generated_files/Ind_cowpea_for_envgwas.txt"),quote = FALSE,row.names = FALSE,col.names = FALSE)
write.table(snp,file=paste0("./Data/generated_files/SNPs_cowpea_for_envgwas.txt"),quote = FALSE,row.names = FALSE,col.names = FALSE)

###Copy genotype file into the generated files directory and rename it
file.copy(from="./Data/Cowpea_GF_Data.lfmm", to="./Data/generated_files/genotype.lfmm", 
          overwrite = TRUE, recursive = FALSE, copy.mode = TRUE)

## Genome imputation
# LFMM and cate works only on complete datasets (i.e. no missing data allowed).
# We have to impute missing data in order to proceed with the analysis, this can be done using the snmf function of LEA.

# imputation (using 10 reps, might be more), K choice to be based on PCA, snmf,...
project.snmf = snmf(input.file="./Data/generated_files/genotype.lfmm", K=1:10, entropy=T, ploidy = 2, project="new", rep=2)
best = which.min(cross.entropy(project.snmf, K = 5))
impute(object = project.snmf, input.file="./Data/generated_files/genotype.lfmm", K = 5, run = best)

# cleaning
remove.snmfProject("./Data/generated_files/genotype.snmfProject")
unlink(x = "generated_files/genotype.snmf",recursive = TRUE,force = TRUE)
unlink("generated_files/genotype.geno")
unlink("generated_files/genotype.lfmm")

## Create file containing metadata for future analysis
genotype <- read.lfmm("./Data/generated_files/genotype.lfmm_imputed.lfmm")
genotype=t(genotype)
chrpos = snp ; colnames(chrpos) <- c("#CHROM","POS", "SNP")
geno_imputed <- cbind(chrpos,genotype)
colnames(geno_imputed) <- c(colnames(chrpos),ind)
fwrite(as.data.frame(geno_imputed),"./Data/generated_files/Cowpea_GF_Data.txt")
if((dir.exists("./genotype_data/")==FALSE)){dir.create("./genotype_data/")}
fwrite(as.data.frame(geno_imputed),"./genotype_data/Cowpea_GF_Data.txt")

# Last cleaning
unlink("generated_files/genotype.lfmm_imputed.lfmm")
