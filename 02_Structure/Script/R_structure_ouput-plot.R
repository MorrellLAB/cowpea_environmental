#Barplot of population structure among the qraces. 
setwd("/Users/rakakpo/MorrellLab Dropbox/Roland Akakpo/IITA_CORE_DATA/cowpea_gwas-main/STRUCTURES/STRUCTURE_PITCHARD/With_Admix")
#setwd("/Users/rakakpo/MorrellLab Dropbox/Roq Akakpo/IITA_CORE_DATA/cowpea_gwas-main/STRUCTURES/STRUCTURE_PITCHARD/Without_Admix")
#load libraries
library("tess3r")
library("Cairo")
library("maps")
#library("RColorBrewer"); cols <- brewer.pal(9,"Set1")
library(data.table) 
rm(list=ls())

#Read data

coord=read.table("../Data/Cordinates.txt", quote = "", sep="\t", h=T) # One row per sample with longitude and latitude
Qmatrix<-read.csv("./CorrAllFreq/Ancestry.K5.Qr5.csv")
head(Qmatrix)

#Add column names according to the K value used. Move external parenthesis as needed.
# Color choice
my.colors =c("gold","brown","darkturquoise", "darkgreen","darkblue")
#my.colors =rainbow(5)
my.palette<- CreatePalette(my.colors, 4)
colnames(Qmatrix)<-c("Samples","Pop1","Pop2","Pop3","Pop4","Pop5")
#Select pops by majority assignment
head(Qmatrix)

#sort Qmatrixmatrix
Pop1<-subset(Qmatrix, Qmatrix$Pop1 > Qmatrix$Pop2 & Qmatrix$Pop1 >Qmatrix$Pop3 & Qmatrix$Pop1 >Qmatrix$Pop4 & Qmatrix$Pop1 >Qmatrix$Pop5)
Pop2<-subset(Qmatrix, Qmatrix$Pop2 > Qmatrix$Pop1 & Qmatrix$Pop2 >Qmatrix$Pop3 & Qmatrix$Pop2 >Qmatrix$Pop4 & Qmatrix$Pop2 >Qmatrix$Pop5)
Pop3<-subset(Qmatrix, Qmatrix$Pop3 > Qmatrix$Pop1 & Qmatrix$Pop3 >Qmatrix$Pop2 & Qmatrix$Pop3 >Qmatrix$Pop4 & Qmatrix$Pop3 >Qmatrix$Pop5)
Pop4 <- subset(Qmatrix, Qmatrix$Pop4 > Qmatrix$Pop1 & Qmatrix$Pop4 >Qmatrix$Pop2 & Qmatrix$Pop4 >Qmatrix$Pop3 & Qmatrix$Pop4 >Qmatrix$Pop5) 
Pop5 <- subset(Qmatrix, Qmatrix$Pop5 > Qmatrix$Pop1 & Qmatrix$Pop5 >Qmatrix$Pop2 & Qmatrix$Pop5>Qmatrix$Pop3 & Qmatrix$Pop5 >Qmatrix$Pop4) 

# Order each population by majority of assignment based on that population
Pop1_or<-Pop1[order(Pop1$Pop1, decreasing=T),]
Pop2_or<-Pop2[order(Pop2$Pop2, decreasing=T),]
Pop3_or<-Pop3[order(Pop3$Pop3, decreasing=T),]
Pop4_or<-Pop4[order(Pop4$Pop4, decreasing=T),]
Pop5_or<-Pop5[order(Pop5$Pop5, decreasing=T),]

# Join all the ordered populations and order the outfile folowing the noumber of accession per pop 

Data_str<-rbind(as.data.frame(Pop1_or),as.data.frame(Pop2_or),as.data.frame(Pop3_or),as.data.frame(Pop4_or),as.data.frame(Pop5_or)) 
#Data_str<-Data_str[c(1,5,2,3,6,4)]
#colnames(K_str5)<-c("Samples","K1","K2","K3","K4","K5")
#Delect temp file

rm(list=ls(pattern="Pop"))

# Set coordinates file in the same order as Popfile

Data.Coord.countries=merge(Data_str, coord, by.x = "Samples",by.y="Samples", sort = FALSE)

# Retrieve coordinates

coo=Data.Coord.countries[,7:8]; colnames(coo)=NULL

# Convert the Qmatrix into a tess3r format q
#Qmatrix

q=Data_str[2:6]
q <- q/apply(q, 1, sum)
q=as.qmatrix(q)

##Population structure plot k=5 pdf
pdf("Ancestry_barplot_k5.pdf",width=10.5,height=4)
barplot(q, border=NA, space=0, col.palette = my.palette, axisnames=F)
#Legend
legend(inset=-0.2,"bottom",legend=c("Guineo-Congolian","Northeast Africa","Guinean","Sahelian",
  "East Africa"), fill=c("gold","brown","darkturquoise", "darkgreen","darkblue"), xpd=T,horiz=T)
dev.off() 

##Population structure plot k=5 k=5 png
CairoPNG("Ancestry_barplot_k5.png",units = "cm",width = 10.5,height = 4,res = 600) #File name
#par(mar = c(4, 1, 1, 1))
barplot(q, border=NA, space=0, col.palette = my.palette, axisnames=F)->bp
#Legend
legend(inset=-0.2,"bottom",legend=c("Guineo-Congolian","Northeast Africa","Guinean","Sahelian",
    "East Africa"), fill=c("gold","brown","darkturquoise", "darkgreen","darkblue"), xpd=T,horiz=T)
dev.off() 

##Population structure map k=5 pdf
pdf("Ancestry_map.K5.pdf", paper = 'a4') 
plot(q, coo, method = "map.max", interpol = FieldsKrigModel(1000), resolution = c(1200,1200),
    xlab="", ylab="", cex = .4, col.palette = my.palette)
map(add = T)
dev.off()

##Population structure map k=5 pdf

CairoPNG("Ancestry_map.K5.png",units = "cm",width = 10.5,height = 4,res = 600) #File name
#par(mar = c(4, 1, 1, 1))
plot(q, coo, method = "map.max", interpol = FieldsKrigModel(1000), resolution = c(1200,1200),
     xlab="", ylab="", cex = .4, col.palette = my.palette)
map(add = T)
dev.off()

save.image(file = "Struct_with_admix_Corr.RData")
