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

## read acc ID and coordinates
#df<-read_excel("./data/IITA_cowpea_core_PP_data.xlsx", sheet="Table1")

setwd("~/MorrellLab Dropbox/Roland Akakpo/IITA_CORE_DATA/cowpea_gwas-main/envGWAS/")
df<-read.table("./Data/Sample_cordinates.txt", h=T, sep="\t")
df<-as.data.frame(df)
df<-df[,c("AccessionName", "Longitude", "Latitude")]

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
files<-list.files(path="~/MorrellLab Dropbox/Roland Akakpo/IITA_CORE_DATA/cowpea_gwas-main/envGWAS/Data/Pheno_data/wc2.1_bio/", pattern=".tif", full.names=T)
rasterStack<-stack(files)

row.names(df1)<-df1$`AccessionName`
df1$`AccessionName`<-NULL

worldclimData<-as.data.frame(cbind(row.names(df1), extract(rasterStack, df1)))
names(worldclimData)<-c("ID", "BIO1", "BIO10", "BIO11", "BIO12", "BIO13", "BIO14", 
                        "BIO15", "BIO16", "BIO17", "BIO18", "BIO19", "BIO2", 
                        "BIO3", "BIO4", "BIO5", "BIO6", "BIO7", "BIO8", "BIO9")
worldclimData<-worldclimData[,c("ID", paste0("BIO", seq(1,19)))]

## merge with coordinates
names(df)[1]<-"ID"
m<-merge(df, worldclimData, by="ID")

write.table(worldclimData, "Data/cowpea_worldclim1.txt", sep="\t", quote=F, row.names=F)

#####
