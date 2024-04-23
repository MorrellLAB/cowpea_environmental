#=============================================
#  rakakpo 11/2023 , UMN, Campus of St Paul  #
#=============================================

#!/usr/bin/env Rscript
# Description: This scripy Perform multiples envGwas for cowpea Bio-varianbles
# rakakpo
# 2022-15-12
# Launching libraries and functions


#Libraries
library(pacman)

p_load("gplots", "LDheatmap", "genetics","ape","RSpectra","EMMREML","scatterplot3d","mlmm","multtest",
       "svd", "tibble", "data.table", "Rcpp", "RcppEigen", "RcppParallel","LEA","lfmm", 
       "parallel", "doParallel", "foreach", "pacman", "GAPIT")

# Check the number of command-line arguments
if (length(commandArgs(trailingOnly = TRUE)) < 2) {
  stop("Usage: script.R <pheno_file> <genotype_file>")
}

# Get phenotype and genotype file paths from command-line arguments
pheno_file =commandArgs(trailingOnly = TRUE)[1]
genotype_file =commandArgs(trailingOnly = TRUE)[2]
# Set the base directory for output
Output ="/panfs/jay/groups/9/morrellp/rakakpo/Cowpea_Environment_Association/envGWAS/GWAS_All_Acc_hmp"
#Loop over pheno variables

phenoName=c("BIO1")#, "BIO10", "BIO11", "BIO12", "BIO13", "BIO14", "BIO15", "BIO16", "BIO17", "BIO18", "BIO19", "BIO2", "BIO3", "BIO4", "BIO5", "BIO6", "BIO7", "BIO8", "BIO9","TMAX", "TMIN", "PREC", "IC1","IC2","IC3")
for (i in phenoName ){
args <- c(i)
# Assigning variables
pheno_variable <- args[1] # Uncomment this line to run on cluster
K <- 5 # Number of counfounding factors to estimate, accessing by PCA or Structure
setwd(Output)

# Getting genotypic data
print("read genotypic data")
genotype <- fread(genotype_file,header = TRUE,)
# Getting phenotypic data
print("read phenotypic data")
pheno <- read.table(paste0(pheno_file), na.strings = "NA", header = TRUE)
pheno_data <- na.exclude(pheno[,c(1,which(colnames(pheno)==pheno_variable))])
row.names(pheno_data) <- pheno_data$ID

# Filtering genotypes according to accessions present in the phenotypic data and the reverse
genotype <- genotype[,c(1,2,3,4,5,6,7,8,9,10,11,which(colnames(genotype) %in% row.names(pheno_data))),with=FALSE]
pheno_data <- pheno_data[which(row.names(pheno_data) %in% colnames(genotype)),]

# Control that genotype and phenotype data are in the same order
print("ensure genotypes and phenotypes are in the same order")
genotype <- cbind(genotype[,c(1,2,3,4,5,6,7,8,9,10,11)],setcolorder(genotype[,-c(1,2,3,4,5,6,7,8,9,10,11)],row.names(pheno_data)))

##Saving list of retained SNPs with their maf in the corresponding dataset and list of individuals
if((dir.exists(paste0("./",pheno_variable))==FALSE)){dir.create(paste0("./",pheno_variable))}
used_snps <- data.frame(genotype[["chrom"]],genotype[["pos"]],genotype[["rs"]])
write.table(used_snps,file = paste(pheno_variable,"/chrpos_",pheno_variable,".txt",sep=""))


# Extract column names from genotype
col_names <- colnames(genotype)
# Create a new data frame with an empty first row
new_data <- data.frame(matrix(NA, nrow = 1, ncol = ncol(genotype)))
# Assign the original column names as colnames and the first row
colnames(new_data) <- col_names
new_data[1,] <- col_names
# Combine the new data frame with the original data frame
genotype_temp <- rbind(new_data, genotype)

# Set column names to empty (NULL)
colnames(genotype_temp) <- NULL

myY=pheno_data; row.names(myY)=NULL
myG=genotype_temp

######################GAPIT
print("Performing GAPIT")
step_dir <- getwd()
if((dir.exists(paste0("./",pheno_variable))==FALSE)){dir.create(paste0("./",pheno_variable))}
setwd(dir = paste0(step_dir,"/",pheno_variable))
myBLINK<-GAPIT(Y=myY,G=myG,PCA.total=5,SNP.MAF=0.02, Major.allele.zero = TRUE,model="Blink")  # check and tune this call, especially regarding PCA.total
myFarmCPU<-GAPIT(Y=myY,G=myG,PCA.total=5, Major.allele.zero = TRUE,model="FarmCPU")

# Setting directory into the variable folder
setwd(dir = step_dir)
print("Gather and save the results")
setwd(paste("./",pheno_variable,sep=""))
# Saving outcomes of the analysis
chrpos <- read.table(paste("chrpos_",pheno_variable,".txt",sep=""))
##Combnine results from multiple analyses
results=myFarmCPU$GWAS[c("SNP","Chromosome","Position","P.value", "effect" )]#; colnames(results) <- c("Chr","Pos","SNP","pv.farmcpu")
##Adding GAPIT results
#results <- merge(myFarmCPU$GWAS[c("P.value", "SNP")],by.x = "SNP",by.y="SNP", sort = FALSE)
results <- merge(results,myBLINK$GWAS[c("P.value","SNP",  "effect", "maf")],by.x = "SNP",by.y="SNP",sort = FALSE)

colnames(results) <- c("SNP","Chr","Pos","pv.farmcpu","effect.farmcpu","pv.blink", "effect.blink", "MAF")

##save results
write.table(results,paste("results_",pheno_variable,".txt",sep=""), sep="\t", quote=F, row.names = F)
setwd(dir = step_dir)
}

