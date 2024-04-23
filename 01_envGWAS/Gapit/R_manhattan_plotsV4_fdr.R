#############################################################
#  rakakpo 09/2023 , UMN, Campus of St Paul                #
#############################################################

#!/usr/bin/env Rscript
# Perform manhattan plot on the multiples envGWAS output
# rakakpo
# 2023/09/14

# This script produces plots for the association analysis
# It will also produce tables of candidates loci using a FDR threshold

#### Getting the arguments from the script invocation ####

# args <- commandArgs(TRUE) # Uncomment to run via a qsub call
setwd("~/MorrellLab Dropbox/Roland Akakpo/Cowpea_Environmental_assoc/envGWAS_Current/GWAS_All_Acc/")

phenoName=c("BIO1", "BIO10", "BIO11", "BIO12", "BIO13", "BIO14", "BIO15", "BIO16", "BIO17", "BIO18", "BIO19", "BIO2", "BIO3", "BIO4", "BIO5", "BIO6", "BIO7", "BIO8", "BIO9","TMAX", "TMIN", "PREC","IC1","IC2","IC3")
for (i in phenoName ){
  
args <- c(i,5) # Set the understudy variable and the Bonferroni threshold
pheno_variable <- args[1]

ifelse(is.na(args[2]),fdr <- 5,fdr <- as.numeric(args[2]))
print(paste("FDR is set to",fdr))


print("loading libraries")
library(RColorBrewer) 
#cols <- brewer.pal(12,"Set3")
library(qqman)
library(Cairo)
library(qvalue)

#### Reading data ####
print("reading data")
data <- read.table(paste("./",pheno_variable,"/results_",pheno_variable,".txt",sep=""))
#mlmm.threshold <- read.table(paste("./",pheno_variable,"/mlmm_threshold_",pheno_variable,".txt",sep=""))

#### Get total number of SNPs ####
#print("Get total number of SNPs")
#nb_snps <- dim(data)[[1]]
## Calculate Bonferroni corrected P-value threshold
#bonferroni_threshold <- 0.05/nb_snps
#threshold_pvalue <- bonferroni_threshold

for(a in c("farmcpu","blink")){

#### Computing FDR ####
print("computing FDR")
assign(paste0("qv.",a,".",pheno_variable,sep=""),
       qvalue(p = data[paste("pv.",a,sep="")],
              fdr = fdr/100))
assign(paste("candidates.",a,".",pheno_variable,sep=""),
       which(get(paste("qv.",a,".",pheno_variable,sep=""))$significant))

}
#### Manhattan plots ####
if((dir.exists(paste0("./",pheno_variable,"/Manhattan_Plots"))==FALSE)){dir.create(paste0("./",pheno_variable,"/Manhattan_Plots"))}

##### PDF plots #####


######################BLINK
pdf(paste0("./",pheno_variable,"/Manhattan_Plots/",pheno_variable,"_BLINK.pdf",sep=""),paper = 'a4r')# File name
par(mfrow=c(2,1))
manhattan(x = data,chr = "Chromosome.gapit",bp = "Pos",p = "pv.blink",snp = "SNP",
          genomewideline = ifelse(test = length(get(paste("candidates.blink.",pheno_variable,sep="")))>0,
                                  yes = -log10(max(data[get(paste("candidates.blink.",pheno_variable,sep="")),
                                                        paste("pv.blink",sep="")])),
                                  no = FALSE),
          suggestiveline = FALSE, col = c("blue4", "orange3"), main=paste(pheno_variable,"BLINK"))
qq(pvector = data$pv.blink,main=paste("qqplot BLINK",pheno_variable))
dev.off()
######################FARMCPU
pdf(paste0("./",pheno_variable,"/Manhattan_Plots/",pheno_variable,"_FARMCPU.pdf",sep=""),paper = 'a4r')# File name
par(mfrow=c(2,1))
manhattan(x = data,chr = "Chromosome.gapit",bp = "Pos",p = "pv.farmcpu",snp = "SNP",
          genomewideline = ifelse(test = length(get(paste("candidates.farmcpu.",pheno_variable,sep="")))>0,
                                  yes = -log10(max(data[get(paste("candidates.farmcpu.",pheno_variable,sep="")),
                                                        paste("pv.farmcpu",sep="")])),
                                  no = FALSE),
          suggestiveline = FALSE, col = c("blue4", "orange3"), main=paste(pheno_variable,"FARMCPU"))
qq(pvector = data$pv.farmcpu,main=paste("qqplot FARMCPU",pheno_variable))
dev.off()
#### PNG format #####

print("producing PNG manhattan plots")


######################BLINK
CairoPNG(filename = paste("./",pheno_variable,"/Manhattan_Plots/",pheno_variable,"_BLINK.png",sep=""),units = "cm",width = 21,height = 29.7,res = 600) #File name
par(mfrow=c(2,1))
manhattan(x = data,chr = "Chromosome.gapit",bp = "Pos",p = "pv.blink",snp = "SNP",
          genomewideline = ifelse(test = length(get(paste("candidates.blink.",pheno_variable,sep="")))>0,
                                  yes = -log10(max(data[get(paste("candidates.blink.",pheno_variable,sep="")),
                                                        paste("pv.blink",sep="")])),
                                  no = FALSE),
          suggestiveline = FALSE, col = c("blue4", "orange3"), main=paste(pheno_variable,"BLINK"))
qq(pvector = data$pv.blink,main=paste("qqplot BLINK",pheno_variable))
dev.off()
######################FARMCPU
CairoPNG(filename = paste("./",pheno_variable,"/Manhattan_Plots/",pheno_variable,"_FARMCPU.png",sep=""),units = "cm",width = 21,height = 29.7,res = 600) #File name
par(mfrow=c(2,1))
manhattan(x = data,chr = "Chromosome.gapit",bp = "Pos",p = "pv.farmcpu",snp = "SNP",
          genomewideline = ifelse(test = length(get(paste("candidates.farmcpu.",pheno_variable,sep="")))>0,
                                  yes = -log10(max(data[get(paste("candidates.farmcpu.",pheno_variable,sep="")),
                                                        paste("pv.farmcpu",sep="")])),
                                  no = FALSE),
          suggestiveline = FALSE, col = c("blue4", "orange3"), main=paste(pheno_variable,"FARMCPU"))
qq(pvector = data$pv.farmcpu,main=paste("qqplot FARMCPU",pheno_variable))
dev.off()

#### Saving candidates lists ####
print("saving candidates lists")
if((dir.exists(paste0("./",pheno_variable,"/Candidates"))==FALSE)){dir.create(paste0("./",pheno_variable,"/Candidates"))}
for(a in c("farmcpu","blink")){
    write.table(x=(data[get(paste("candidates.",a,".",pheno_variable,sep="")),
                        c("SNP","Chr","Pos",paste("pv.",a,sep=""))]),
                file = paste0("./",pheno_variable,"/Candidates","/candidates_",pheno_variable,"_",a,"_fdr",fdr,"perc.txt"),
                quote = FALSE,
                row.names = FALSE)
}

}
