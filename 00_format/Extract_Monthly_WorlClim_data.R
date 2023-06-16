#!/usr/bin/env Rscript
# This script is used to extract mean monthly clim data from a raster wordclim data
# rakakpo
# Saint-Paul, MN, 10/20/2022
setwd("~/MorrellLab Dropbox/Roland Akakpo/IITA_CORE_DATA/cowpea_gwas-main/envGWAS/")

library(raster)
library(readxl)

# Import WorldClim Max Temp data
temp1 <- raster("../Pheno_data/wc2.1_tmax/wc2.1_30s_tmax_01.tif")
temp2 <- raster("../Pheno_data/wc2.1_tmax/wc2.1_30s_tmax_02.tif")
temp3 <- raster("../Pheno_data/wc2.1_tmax/wc2.1_30s_tmax_03.tif")
temp4 <- raster("../Pheno_data/wc2.1_tmax/wc2.1_30s_tmax_04.tif")
temp5 <- raster("../Pheno_data/wc2.1_tmax/wc2.1_30s_tmax_05.tif")
temp6 <- raster("../Pheno_data/wc2.1_tmax/wc2.1_30s_tmax_06.tif")
temp7 <- raster("../Pheno_data/wc2.1_tmax/wc2.1_30s_tmax_07.tif")
temp8 <- raster("../Pheno_data/wc2.1_tmax/wc2.1_30s_tmax_08.tif")
temp9 <- raster("../Pheno_data/wc2.1_tmax/wc2.1_30s_tmax_09.tif")
temp10 <- raster("../Pheno_data/wc2.1_tmax/wc2.1_30s_tmax_10.tif")
temp11 <- raster("../Pheno_data/wc2.1_tmax/wc2.1_30s_tmax_11.tif")
temp12 <- raster("../Pheno_data/wc2.1_tmax/wc2.1_30s_tmax_12.tif")

#Take a look at temp1
temp1

## read acc ID and coordinates
#df<-read_excel("./data/IITA_cowpea_core_PP_data.xlsx", sheet="Table1")
df<-read.table("./Data/512ID_Info.txt", h=T, sep="\t")
df<-as.data.frame(df)
df<-df[,c("AccessionName", "Longitude", "Latitude")]
acc <- data.frame(df, row.names="AccessionName")


# Extract data from WorldClim for acc
temp.data <- acc 
temp.data$Jan <- extract(temp1, acc)
temp.data$Feb <- extract(temp2, acc)
temp.data$Mar <- extract(temp3, acc)
temp.data$Apr <- extract(temp4, acc)
temp.data$May <- extract(temp5, acc)
temp.data$Jun <- extract(temp6, acc)
temp.data$Jul <- extract(temp7, acc)
temp.data$Aug <- extract(temp8, acc)
temp.data$Sep <- extract(temp9, acc)
temp.data$Oct <- extract(temp10, acc)
temp.data$Nov <- extract(temp11, acc)
temp.data$Dec <- extract(temp12, acc)

#take a lokk at the data extracted

head(temp.data)

#Save data
if (file.exists("TMAX")){
  write.table(temp.data, "./TMAX/Raw.tmax_monthly_data.txt",  quote = F, row.names = T) 
  } else {
  dir.create("TMAX")
  write.table(temp.data, "./Raw.TMAX/tmax_monthly_data.txt",  quote = F, row.names = T)
}

# Import WorldClim Min Temp data
temp1 <- raster("../Pheno_data/wc2.1_tmin/wc2.1_30s_tmin_01.tif")
temp2 <- raster("../Pheno_data/wc2.1_tmin/wc2.1_30s_tmin_02.tif")
temp3 <- raster("../Pheno_data/wc2.1_tmin/wc2.1_30s_tmin_03.tif")
temp4 <- raster("../Pheno_data/wc2.1_tmin/wc2.1_30s_tmin_04.tif")
temp5 <- raster("../Pheno_data/wc2.1_tmin/wc2.1_30s_tmin_05.tif")
temp6 <- raster("../Pheno_data/wc2.1_tmin/wc2.1_30s_tmin_06.tif")
temp7 <- raster("../Pheno_data/wc2.1_tmin/wc2.1_30s_tmin_07.tif")
temp8 <- raster("../Pheno_data/wc2.1_tmin/wc2.1_30s_tmin_08.tif")
temp9 <- raster("../Pheno_data/wc2.1_tmin/wc2.1_30s_tmin_09.tif")
temp10 <- raster("../Pheno_data/wc2.1_tmin/wc2.1_30s_tmin_10.tif")
temp11 <- raster("../Pheno_data/wc2.1_tmin/wc2.1_30s_tmin_11.tif")
temp12 <- raster("../Pheno_data/wc2.1_tmin/wc2.1_30s_tmin_12.tif")

#Take a look at temp1
temp1

## read acc ID and coordinates
#df<-read_excel("./data/IITA_cowpea_core_PP_data.xlsx", sheet="Table1")
df<-read.table("./Data/512ID_Info.txt", h=T, sep="\t")
df<-as.data.frame(df)
df<-df[,c("AccessionName", "Longitude", "Latitude")]
acc <- data.frame(df, row.names="AccessionName")


# Extract data from WorldClim for acc
temp.data <- acc 
temp.data$Jan <- extract(temp1, acc)
temp.data$Feb <- extract(temp2, acc)
temp.data$Mar <- extract(temp3, acc)
temp.data$Apr <- extract(temp4, acc)
temp.data$May <- extract(temp5, acc)
temp.data$Jun <- extract(temp6, acc)
temp.data$Jul <- extract(temp7, acc)
temp.data$Aug <- extract(temp8, acc)
temp.data$Sep <- extract(temp9, acc)
temp.data$Oct <- extract(temp10, acc)
temp.data$Nov <- extract(temp11, acc)
temp.data$Dec <- extract(temp12, acc)

#take a lokk at the data extracted

head(temp.data)

#Save data
if (file.exists("TMIN")){
  write.table(temp.data, "./TMIN/Raw.tmin_monthly_data.txt",  quote = F, row.names = T) 
} else {
  dir.create("TMIN")
  write.table(temp.data, "./TMIN/Raw.tmin_monthly_data.txt",  quote = F, row.names = T)
}

# Import WorldClim Precipitation data
temp1 <- raster("../Pheno_data/wc2.1.prec/wc2.1_30s_prec_01.tif")
temp2 <- raster("../Pheno_data/wc2.1.prec/wc2.1_30s_prec_02.tif")
temp3 <- raster("../Pheno_data/wc2.1.prec/wc2.1_30s_prec_03.tif")
temp4 <- raster("../Pheno_data/wc2.1.prec/wc2.1_30s_prec_04.tif")
temp5 <- raster("../Pheno_data/wc2.1.prec/wc2.1_30s_prec_05.tif")
temp6 <- raster("../Pheno_data/wc2.1.prec/wc2.1_30s_prec_06.tif")
temp7 <- raster("../Pheno_data/wc2.1.prec/wc2.1_30s_prec_07.tif")
temp8 <- raster("../Pheno_data/wc2.1.prec/wc2.1_30s_prec_08.tif")
temp9 <- raster("../Pheno_data/wc2.1.prec/wc2.1_30s_prec_09.tif")
temp10 <- raster("../Pheno_data/wc2.1.prec/wc2.1_30s_prec_10.tif")
temp11 <- raster("../Pheno_data/wc2.1.prec/wc2.1_30s_prec_11.tif")
temp12 <- raster("../Pheno_data/wc2.1.prec/wc2.1_30s_prec_12.tif")

#Take a look at temp1
temp1

## read acc ID and coordinates
#df<-read_excel("./data/IITA_cowpea_core_PP_data.xlsx", sheet="Table1")
df<-read.table("./Data/512ID_Info.txt", h=T, sep="\t")
df<-as.data.frame(df)
df<-df[,c("AccessionName", "Longitude", "Latitude")]
acc <- data.frame(df, row.names="AccessionName")


# Extract data from WorldClim for acc
temp.data <- acc 
temp.data$Jan <- extract(temp1, acc)
temp.data$Feb <- extract(temp2, acc)
temp.data$Mar <- extract(temp3, acc)
temp.data$Apr <- extract(temp4, acc)
temp.data$May <- extract(temp5, acc)
temp.data$Jun <- extract(temp6, acc)
temp.data$Jul <- extract(temp7, acc)
temp.data$Aug <- extract(temp8, acc)
temp.data$Sep <- extract(temp9, acc)
temp.data$Oct <- extract(temp10, acc)
temp.data$Nov <- extract(temp11, acc)
temp.data$Dec <- extract(temp12, acc)

#take a lokk at the data extracted

head(temp.data)

#Save extrated data

if (file.exists("PREC")){
  write.table(temp.data, "./PREC/Raw.prec_monthly_data.txt",  quote = F, row.names = T) 
} else {
  dir.create("PREC")
  write.table(temp.data, "./PREC/Raw.prec_monthly_data.txt",  quote = F, row.names = T)
}

