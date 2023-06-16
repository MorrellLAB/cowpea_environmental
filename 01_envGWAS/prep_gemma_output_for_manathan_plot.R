#!/usr/bin/env Rscript
# This script is used to prepare gemma output in a suitable format for manhatan plot
# rakakpo007
# 2022-06-28
#load library

library(data.table)

# list of clim variable 
phenoName=c("BIO1", "BIO10", "BIO11", "BIO12", "BIO13", "BIO14", "BIO15", "BIO16", "BIO17", "BIO18", "BIO19", "BIO2", "BIO3", "BIO4", "BIO5", "BIO6", "BIO7", "BIO8", "BIO9")
#read output result and write clean reslt for manhatan plot
for (i in phenoName ){
  res=fread(paste0("./",i,"/results/",i,".assoc.txt"))
  res=as.data.table(res[,c("chr", "rs", "ps", "p_score")])
  names(res)=c("CHR",	"SNP",	"BP",	"P")
  write.table(res, paste0("./",i,"/results/",i,".assoc.clean.txt"), sep="\t", quote=F, row.names=F)  
}


