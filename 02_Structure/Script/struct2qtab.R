# This R function is used to extract ancestry probability from structure analysis output
# rakakpo
# 11/04/2022
#St. Paul - UMN 
library(stringr)
library(ggplot2)
library(data.table)

struct2qtab<-function(data.in,data.out){
#Read Structure input file , The intitial SNP datafile
data.in<-read.table(data.in,skip=1)	
#Read Structure output
data.out<-readLines(data.out)
#Parsing structure output file and grabs the q score
q.start <- grep("Inferred ancestry of individuals:",data.out, value=FALSE)
ind <- grep("Run parameters:",data.out, value=FALSE)+1
k.ind<-grep("populations assumed",data.out, value=FALSE)
k<-data.out[k.ind]
k<-as.numeric(str_extract_all(k,"[0-9.A-Za-z_]+")[[1]][1])

ind<-data.out[ind]	 				 
ind<-as.numeric(str_extract_all(ind,"[0-9.A-Za-z_]+")[[1]][1])
q.end<-1+ind+q.start		
q.tab<-data.out[(q.start+2):q.end]
q.struc<-t(sapply(str_extract_all(q.tab,"[0-9.A-Za-z_]+"),as.character))

ncol.q.struc<-dim(q.struc)[2]

q.struc<-q.struc[,c(2,(ncol.q.struc-k+1):(ncol.q.struc))]
q.struc<-data.frame(q.struc)
kgroup<- k
#Replace Individual name by original names from the Structure Input File
 q.struc[,1]<-data.in[,1]
write.csv(q.struc,paste("Ancestry.K",kgroup, ".Q", ".csv",sep=""),row.names=F)
}
