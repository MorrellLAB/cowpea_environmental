#!/usr/bin/env Rscript
# This script is used to extract growing period Temperature Max-Min and Precipitation data from the mean monthly whole data file
# rakakpo
# Saint-Paul, MN, 10/20/2022
library(data.table)
#read monthly data
dt=fread("./TMIN/Raw_tmin_monthly_data.txt")

  temp1=subset(dt[,c(1,2,12,13)], dt$Country=="Burkina Faso") ; names(temp1)=c("ID", "Country", "Mounth1", "Mounth2")
  temp2=subset(dt[,c(1,2,12,13)], dt$Country=="Cameroon") ; names(temp2)=c("ID", "Country", "Mounth1", "Mounth2")
  temp3=subset(dt[,c(1,2,12,13)], dt$Country=="Ghana") ; names(temp3)=c("ID", "Country", "Mounth1", "Mounth2")
  temp4=subset(dt[,c(1,2,12,13)], dt$Country=="Mali") ; names(temp4)=c("ID", "Country", "Mounth1", "Mounth2")
  temp5=subset(dt[,c(1,2,12,13)], dt$Country=="Niger") ; names(temp5)=c("ID", "Country", "Mounth1", "Mounth2")
  temp6=subset(dt[,c(1,2,12,13)], dt$Country=="Nigeria") ; names(temp6)=c("ID", "Country", "Mounth1", "Mounth2")
  temp7=subset(dt[,c(1,2,12,13)], dt$Country=="Uganda") ; names(temp7)=c("ID", "Country", "Mounth1", "Mounth2")
  temp8=subset(dt[,c(1,2,6,7)], dt$Country=="Zambia") ; names(temp8)=c("ID", "Country", "Mounth1", "Mounth2")
  temp9=subset(dt[,c(1,2,6,7)], dt$Country=="Mozambique") ; names(temp9)=c("ID", "Country", "Mounth1", "Mounth2")
  temp10=subset(dt[,c(1,2,8,8)], dt$Country=="Kenya") ; names(temp10)=c("ID", "Country", "Mounth1", "Mounth2")
  temp11=subset(dt[,c(1,2,11,11)], dt$Country=="Ethiopia") ; names(temp11)=c("ID", "Country", "Mounth1", "Mounth2")
  temp12=subset(dt[,c(1,2,6,6)], dt$Country=="Malawi") ; names(temp12)=c("ID", "Country", "Mounth1", "Mounth2")
  temp13=subset(dt[,c(1,2,9,10)], dt$Country=="Tanzania") ; names(temp13)=c("ID", "Country", "Mounth1", "Mounth2")
  temp14=subset(dt[,c(1,2,13,14)], dt$Country=="Benin") ; names(temp14)=c("ID", "Country", "Mounth1", "Mounth2")
  temp15=subset(dt[,c(1,2,13,13)], dt$Country=="Chad" & dt$Ecology=="Soudanian" ) ; names(temp15)=c("ID", "Country", "Mounth1", "Mounth2")
  temp16=subset(dt[,c(1,2,14,14)], dt$Country=="Chad" & dt$Ecology=="Sahelian" ) ; names(temp16)=c("ID", "Country", "Mounth1", "Mounth2")
  temp17=subset(dt[,c(1,2,13,14)], dt$Country=="Togo") ; names(temp17)=c("ID", "Country", "Mounth1", "Mounth2")
  temp18=subset(dt[,c(1,2,11,11)], dt$Country=="Egypt") ; names(temp18)=c("ID", "Country", "Mounth1", "Mounth2")
  temp19=subset(dt[,c(1,2,13,14)], dt$Country=="Senegal") ; names(temp19)=c("ID", "Country", "Mounth1", "Mounth2")
  
  tmin=rbindlist(list(temp1,temp2,temp3, temp4,temp5,temp6, temp7,temp8,temp9, temp10,temp11,temp12,temp13,temp14, temp15, temp16, temp17, temp18, temp19))        
  tmin$mean <- rowMeans(tmin[,c('Mounth1', 'Mounth2')], na.rm=TRUE)

  
#save tmin without missing data in fam format
tmin=na.omit(tmin)
info<-as.data.frame(cbind(tmin$ID, tmin$ID, 0, 0, 0))
tfam<-as.data.frame(cbind(info, tmin$mean))
write.table(tfam, "./TMIN/cowpea_envgwas_TMIN.fam", sep="\t", quote=F, row.names=F, col.names=F)


#save Sample
tminID=data.frame(subset(tmin[,c(1,1)])) ; names(tminID)=NULL
write.table(tminID, "./TMIN/TminID.txt", sep="\t", quote=F, row.names=F, col.names=F)


#Extract TMAX monthly data


#read monthly data
dt=fread("./TMAX/Raw_tmax_monthly_data.txt")

temp1=subset(dt[,c(1,2,12,13)], dt$Country=="Burkina Faso") ; names(temp1)=c("ID", "Country", "Mounth1", "Mounth2")
temp2=subset(dt[,c(1,2,12,13)], dt$Country=="Cameroon") ; names(temp2)=c("ID", "Country", "Mounth1", "Mounth2")
temp3=subset(dt[,c(1,2,12,13)], dt$Country=="Ghana") ; names(temp3)=c("ID", "Country", "Mounth1", "Mounth2")
temp4=subset(dt[,c(1,2,12,13)], dt$Country=="Mali") ; names(temp4)=c("ID", "Country", "Mounth1", "Mounth2")
temp5=subset(dt[,c(1,2,12,13)], dt$Country=="Niger") ; names(temp5)=c("ID", "Country", "Mounth1", "Mounth2")
temp6=subset(dt[,c(1,2,12,13)], dt$Country=="Nigeria") ; names(temp6)=c("ID", "Country", "Mounth1", "Mounth2")
temp7=subset(dt[,c(1,2,12,13)], dt$Country=="Uganda") ; names(temp7)=c("ID", "Country", "Mounth1", "Mounth2")
temp8=subset(dt[,c(1,2,6,7)], dt$Country=="Zambia") ; names(temp8)=c("ID", "Country", "Mounth1", "Mounth2")
temp9=subset(dt[,c(1,2,6,7)], dt$Country=="Mozambique") ; names(temp9)=c("ID", "Country", "Mounth1", "Mounth2")
temp10=subset(dt[,c(1,2,8,8)], dt$Country=="Kenya") ; names(temp10)=c("ID", "Country", "Mounth1", "Mounth2")
temp11=subset(dt[,c(1,2,11,11)], dt$Country=="Ethiopia") ; names(temp11)=c("ID", "Country", "Mounth1", "Mounth2")
temp12=subset(dt[,c(1,2,6,6)], dt$Country=="Malawi") ; names(temp12)=c("ID", "Country", "Mounth1", "Mounth2")
temp13=subset(dt[,c(1,2,9,10)], dt$Country=="Tanzania") ; names(temp13)=c("ID", "Country", "Mounth1", "Mounth2")
temp14=subset(dt[,c(1,2,13,14)], dt$Country=="Benin") ; names(temp14)=c("ID", "Country", "Mounth1", "Mounth2")
temp15=subset(dt[,c(1,2,13,13)], dt$Country=="Chad" & dt$Ecology=="Soudanian" ) ; names(temp15)=c("ID", "Country", "Mounth1", "Mounth2")
temp16=subset(dt[,c(1,2,14,14)], dt$Country=="Chad" & dt$Ecology=="Sahelian" ) ; names(temp16)=c("ID", "Country", "Mounth1", "Mounth2")
temp17=subset(dt[,c(1,2,13,14)], dt$Country=="Togo") ; names(temp17)=c("ID", "Country", "Mounth1", "Mounth2")
temp18=subset(dt[,c(1,2,11,11)], dt$Country=="Egypt") ; names(temp18)=c("ID", "Country", "Mounth1", "Mounth2")
temp19=subset(dt[,c(1,2,13,14)], dt$Country=="Senegal") ; names(temp19)=c("ID", "Country", "Mounth1", "Mounth2")


tmax=rbindlist(list(temp1,temp2,temp3, temp4,temp5,temp6, temp7,temp8,temp9, temp10,temp11,temp12,temp13,temp14, temp15, temp16, temp17, temp18, temp19))       
tmax$mean <- rowMeans(tmax[,c('Mounth1', 'Mounth2')], na.rm=TRUE)


#save tmax without missing data in fam format
tmax=na.omit(tmax)
info<-as.data.frame(cbind(tmax$ID, tmax$ID, 0, 0, 0))
tfam<-as.data.frame(cbind(info, tmax$mean))
write.table(tfam, "./TMAX/cowpea_envgwas_TMAX.fam", sep="\t", quote=F, row.names=F, col.names=F)


#save Sample
tmaxID=data.frame(subset(tmax[,c(1,1)])) ; names(tmaxID)=NULL
write.table(tmaxID, "./TMAX/TmaxID.txt", sep="\t", quote=F, row.names=F, col.names=F)




#Extract data for precipitation

#read monthly data
dt=fread("./PREC/Raw_prec_monthly_data.txt")

temp1=subset(dt[,c(1,2,12,13)], dt$Country=="Burkina Faso") ; names(temp1)=c("ID", "Country", "Mounth1", "Mounth2")
temp2=subset(dt[,c(1,2,12,13)], dt$Country=="Cameroon") ; names(temp2)=c("ID", "Country", "Mounth1", "Mounth2")
temp3=subset(dt[,c(1,2,12,13)], dt$Country=="Ghana") ; names(temp3)=c("ID", "Country", "Mounth1", "Mounth2")
temp4=subset(dt[,c(1,2,12,13)], dt$Country=="Mali") ; names(temp4)=c("ID", "Country", "Mounth1", "Mounth2")
temp5=subset(dt[,c(1,2,12,13)], dt$Country=="Niger") ; names(temp5)=c("ID", "Country", "Mounth1", "Mounth2")
temp6=subset(dt[,c(1,2,12,13)], dt$Country=="Nigeria") ; names(temp6)=c("ID", "Country", "Mounth1", "Mounth2")
temp7=subset(dt[,c(1,2,12,13)], dt$Country=="Uganda") ; names(temp7)=c("ID", "Country", "Mounth1", "Mounth2")
temp8=subset(dt[,c(1,2,6,7)], dt$Country=="Zambia") ; names(temp8)=c("ID", "Country", "Mounth1", "Mounth2")
temp9=subset(dt[,c(1,2,6,7)], dt$Country=="Mozambique") ; names(temp9)=c("ID", "Country", "Mounth1", "Mounth2")
temp10=subset(dt[,c(1,2,8,8)], dt$Country=="Kenya") ; names(temp10)=c("ID", "Country", "Mounth1", "Mounth2")
temp11=subset(dt[,c(1,2,11,11)], dt$Country=="Ethiopia") ; names(temp11)=c("ID", "Country", "Mounth1", "Mounth2")
temp12=subset(dt[,c(1,2,6,6)], dt$Country=="Malawi") ; names(temp12)=c("ID", "Country", "Mounth1", "Mounth2")
temp13=subset(dt[,c(1,2,9,10)], dt$Country=="Tanzania") ; names(temp13)=c("ID", "Country", "Mounth1", "Mounth2")
temp14=subset(dt[,c(1,2,13,14)], dt$Country=="Benin") ; names(temp14)=c("ID", "Country", "Mounth1", "Mounth2")
temp15=subset(dt[,c(1,2,13,13)], dt$Country=="Chad" & dt$Ecology=="Soudanian" ) ; names(temp15)=c("ID", "Country", "Mounth1", "Mounth2")
temp16=subset(dt[,c(1,2,14,14)], dt$Country=="Chad" & dt$Ecology=="Sahelian" ) ; names(temp16)=c("ID", "Country", "Mounth1", "Mounth2")
temp17=subset(dt[,c(1,2,13,14)], dt$Country=="Togo") ; names(temp17)=c("ID", "Country", "Mounth1", "Mounth2")
temp18=subset(dt[,c(1,2,11,11)], dt$Country=="Egypt") ; names(temp18)=c("ID", "Country", "Mounth1", "Mounth2")
temp19=subset(dt[,c(1,2,13,14)], dt$Country=="Senegal") ; names(temp19)=c("ID", "Country", "Mounth1", "Mounth2")


prec=rbindlist(list(temp1,temp2,temp3, temp4,temp5,temp6, temp7,temp8,temp9, temp10,temp11,temp12,temp13,temp14, temp15, temp16, temp17, temp18, temp19))               
prec$mean <- rowMeans(prec[,c('Mounth1', 'Mounth2')], na.rm=TRUE)

#save prec without missing data in fam format
prec=na.omit(prec)
info<-as.data.frame(cbind(prec$ID, prec$ID, 0, 0, 0))
tfam<-as.data.frame(cbind(info, prec$mean))
write.table(tfam, "./PREC/cowpea_envgwas_PREC.fam", sep="\t", quote=F, row.names=F, col.names=F)


#save Sample
precID=data.frame(subset(prec[,c(1,1)])) ; names(precID)=NULL
write.table(precID, "./PREC/PrecID.txt", sep="\t", quote=F, row.names=F, col.names=F)


