#!/usr/bin/env Rscript
# prep eGWAS
# cjfiscus
# 2021-12-07

#library(pacman)
#p_load(readxl, raster, rgdal)
library(raster)
library(rgdal)
library(readxl)
library(data.table)
library(stringr)

# import data and slice out relevant info
df<-read_excel("IITA_cowpea_core_PP_data.xlsx", sheet="Table1")
df<-as.data.frame(df)
df<-df[,c("AccessionName", "Longitude", "Latitude", "CollectingSource")]

## subset to accessions we have
#acc<-read.table("./data/samples.txt")
#acc=data.frame(df$AccessionName)
#df<-df[df$`Accession name` %in% acc$V1,]

## remove market collected
#rm<-"Market or shop"
df1<-df
df1<-df1[,1:3]
df1<-na.omit(df1)
df1<-df1[,c("AccessionName", "Longitude", "Latitude")]
df1$AccessionName<-str_replace(df1$AccessionName, "Tvu", "TVu")

# compile wc data
files<-list.files(path="~/MorrellLab Dropbox/Roland Akakpo/IITA_CORE_DATA/cowpea_gwas-main/Pheno_data/wc2.1_bio/", pattern=".tif", full.names=T)
rasterStack<-stack(files)

#Read accession name
df<-read.table("512ID_Info.txt", h=T, sep="\t")
df$AccessionName<-str_replace(df$AccessionName, "Tvu", "TVu")
df1<-read.table("512ID_Info.txt", h=T, sep="\t")
df1$AccessionName<-str_replace(df1$AccessionName, "Tvu", "TVu")
df1<-na.omit(df1)
df1<-df1[,c("AccessionName", "Longitude", "Latitude")]
row.names(df1)<-df1$`AccessionName`
df1$`AccessionName`<-NULL
df1$`Serie`<-NULL
worldclimData<-as.data.frame(cbind(row.names(df1), extract(rasterStack, df1)))
names(worldclimData)<-c("ID", "BIO1", "BIO10", "BIO11", "BIO12", "BIO13", "BIO14", 
                        "BIO15", "BIO16", "BIO17", "BIO18", "BIO19", "BIO2", 
                        "BIO3", "BIO4", "BIO5", "BIO6", "BIO7", "BIO8", "BIO9")
worldclimData<-worldclimData[,c("ID", paste0("BIO", seq(1,19)))]

## merge with coordinates
names(df)[1]<-"ID"
m<-merge(df, worldclimData, by="ID")

write.table(worldclimData, "cowpea_worldclim.txt", sep="\t", quote=F, row.names=F)
#####

# write out data as tfam 
acc=data.frame(df$ID)
names(acc)<-"ID"

m<-merge(acc, worldclimData, by="ID", all.x=T)
m<-m[match(acc$ID, m$ID),]

info<-as.data.frame(cbind(m$ID, m$ID, 0, 0, 0))
m<-as.data.frame(cbind(info, m[,2:ncol(m)]))

write.table(m, "cowpea.fam", sep=" ", quote=F, row.names=F, col.names=F)

#write tfam file for each clim data/phenotype
phenoName=c("BIO1", "BIO10", "BIO11", "BIO12", "BIO13", "BIO14", "BIO15", "BIO16", "BIO17", "BIO18", "BIO19", "BIO2", "BIO3", "BIO4", "BIO5", "BIO6", "BIO7", "BIO8", "BIO9")

for (i in phenoName ){
  m2=as.data.frame(cbind(m[,1:5], m[i]))
  write.table(m2, paste0("cowpea_envgwas_",i,".fam"), sep=" ", quote=F, row.names=F, col.names=F)  
}

## export climate vars
vars<-names(m)[6:ncol(m)]
write.table(vars, "worldclim_vars.txt", sep="\t", quote=F, row.names=F, col.names=F)
