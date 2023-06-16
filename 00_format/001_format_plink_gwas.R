#!/usr/bin/env Rscript
# format cowpea genos and phenos into plink text
# rakakpo
# 2022-15-12
setwd("~/MorrellLab Dropbox/Roland Akakpo/IITA_CORE_DATA/cowpea_gwas-main/data2/Controle/")
library(pacman)
p_load("readxl", "stringr", "tidyr", "data.table", "fastDummies", "Rcpp", "openxlsx", "xlsx", "readxl")

# FORMAT GENOTYPES INTO TPED
## read in sheet 1
df1<-read_excel("SNPs_Roland_Maria_Data.xlsx")

## shape up data
### remove extra rows at top
#df<-df1[4:nrow(df1),]
df1<-as.data.frame(df1)
#names(df1)<-df1[1,]
#df1<-df1[2:nrow(df1),]

### remove extra rows at bot
#df1<-df1[complete.cases(df1),]

##########
# create tped formatted
## format columns 1-4
#info<-df1[,1:3]
info<-read.table("iSelect_cowpea_668acc.txt", sep="\t", h=T)
info$dummy<-0
info<-info[,c("CHR", "ID", "dummy", "POS")]
names(info)<-c("chr", "id", "dummy", "bp")

## format genotypes
calls<-df1[,2:ncol(df1)]
samps<-str_replace(names(calls), "Tvu", "TVu")

## set missing to 0
calls<-as.data.frame(apply(calls, 2, str_replace, pattern="--", replacement="00"))

## split cols 
df2 <- as.data.frame(unlist(lapply(calls, data.table::tstrsplit, ""),
                              recursive = FALSE))

## combine with first four cols
out<-as.data.frame(cbind(info, df2))

## cleanup
rm(calls); rm(df1); rm(df2); rm(info)

## filter markers not placed on chr
out<-out[!out$chr=="XX",]

## write out table
write.table(out, "cowpea.tped", sep=" ", quote=F, row.names=F, col.names=F)
##########


# FORMAT PHENOTYPES INTO TFAM
## phenotypes
## read in data
#df1<-read_excel("../data/ID-TVu CrossReference (Tchamba_11August2020).xls", sheet="Cowpea characterization")
#df2<-read_excel("../data/IITA-Cowpea collection-Cowpea Evaluation.xls")

#df1<-merge(df1, df2, by="ID")
df1=worldclimData
colnames(df1)[1]="Accession name"
df1<-df1[df1$'Accession name' %in% samps,]
df1$`Thrips screening`<-NULL
df1$`Pod bugs screening`<-NULL

## generate list of columns to make into dummies (encode qual traits)
dums<-as.data.frame(cbind(names(df1), unlist(lapply(df1, is.character))))
dums<-dums[dums$V2=="TRUE",]
df<-df1[,colnames(df1) %in% dums$V1]
dums<-dums[!dums$V1=="ID"]
dums<-dums$V1

## subset numeric data & log
df2<-df1[,!colnames(df1) %in% dums]
df2$ID<-NULL
df2[,2:ncol(df2)]<-log(df2[,2:ncol(df2)] + min(df2[,2:ncol(df2)], na.rm = T))

## code vars w/ dummy vars
df<-dummy_cols(df, select_columns=dums, ignore_na=T)
df<-df[,!colnames(df) %in% dums]

## merge data
df<-merge(df2, df, by="Accession name")

## match ids with genotype data
lst<-as.data.frame(cbind(samps, 1))
names(lst)[1]<-"Accession name"
df2<-merge(lst, df, by=c("Accession name"), all.x=T)
df2$V2<-NULL
df2<-df2[match(samps,df2$`Accession name`),]
all.equal(df2$`Accession name`, samps)

# format output
## add first five cols
out2<-as.data.frame(cbind(df2$'Accession name', df2$'Accession name', 0, 0, 0))
out2<-as.data.frame(cbind(out2, df2[,2:ncol(df2)]))

## format phenotype names
phenos<-as.data.frame(names(out2)[6:ncol(out2)])
phenos$N<-1:nrow(phenos)
names(phenos)<-c("trait", "N")
phenos<-phenos[,c("N", "trait")]

## remove duplicate phenotypes
### define dups
ind<-c(seq(105,143), seq(198,251))
dups<-phenos[row.names(phenos) %in% ind,2]

### rm dups from output
out2<-out2[,!names(out2) %in% dups]
phenos<-as.data.frame(names(out2)[6:ncol(out2)])
phenos$N<-1:nrow(phenos)
names(phenos)<-c("trait", "N")
phenos<-phenos[,c("N", "trait")]

# write out all data
write.table(out3, "./data/test_plink/cowpea.tfam", sep=" ", quote=F, row.names=F, col.names=F)
write.table(phenos, "./data/phenotypes.txt", 
            quote=F, row.names=F, col.names=F, sep="\t")
write.table(samps, "./data/samples.txt", quote=F, row.names=F, col.names=F)
