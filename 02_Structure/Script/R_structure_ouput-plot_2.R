#Barplot of population structure among the qraces. 
setwd("/Users/rakakpo/MorrellLab Dropbox/Roland Akakpo/Cowpea_Environmental_assoc/STRUCTURES/STRUCTURE_PITCHARD/Str_Plot/")
#setwd("/Users/rakakpo/MorrellLab Dropbox/Roq Akakpo/IITA_CORE_DATA/cowpea_gwas-main/STRUCTURES/STRUCTURE_PITCHARD/Without_Admix")
#load libraries
library("tess3r")
library("Cairo")
library("maps")
library("maptools")
#library("RColorBrewer"); cols <- brewer.pal(9,"Set1")
library(data.table) 
rm(list=ls())

#Read data

coord=read.table("Sample_cordinates.txt", quote = "", sep="\t", h=T) # One row per sample with longitude and latitude
Qmatrix<-read.csv("cowpea_Ancestry.K5.Q.csv")
#colnames(Qmatrix)<-c("Samples","Pop1","Pop2","Pop3","Pop4","Pop5")
head(Qmatrix)

#Add column names according to the K value used. Move external parenthesis as needed.
# Color choice
my.colors =c("gold","brown","darkturquoise", "darkgreen","darkblue")
#my.colors =rainbow(5)
my.palette<- CreatePalette(my.colors, 5)


Data_str<-Qmatrix[,2:6]

# Set coordinates file in the same order as Popfile

Data.Coord.countries=merge(Qmatrix, coord, by.x = "ID",by.y="Samples", sort = FALSE)

# Retrieve coordinates

coo=Data.Coord.countries[,8:9]; colnames(coo)=NULL

# Convert the Qmatrix into a tess3r format q
#Qmatrix

q=Data_str
q <- q/apply(q, 1, sum)
q=as.qmatrix(q)

##Population structure plot k=5 pdf
pdf("Ancestry_barplot_Sample_map_k5.pdf",width=10.5,height=4)
#par(mfrow=c(2,1))
barplot(q, border=NA, space=0, col.palette = my.palette, axisnames=F)
#Legend
legend(inset=-0.3,"bottom",legend=c("Pop1","Pop2","Pop3", "Pop4","Pop5"),
                              fill=c("gold","brown","darkturquoise", "darkgreen","darkblue"), xpd=T,horiz=T)
dev.off() 

##Population structure plot k=5 k=5 png
CairoPNG("Ancestry_barplot_k5.png",units = "cm",width = 10.5,height = 4,res = 600) #File name
#par(mar = c(4, 1, 1, 1))
barplot(q, border=NA, space=0, col.palette = my.palette, axisnames=F)->bp
#Legend
legend(inset=-0.2,"bottom",legend=c("Sudanian","Sahelian","Guinea-Congolian", "SouthEast","Northeast",
  "East Africa"), fill=c("gold","brown","darkturquoise", "darkgreen","darkblue"), xpd=T,horiz=T)
dev.off() 

##Population structure map k=5 pdf
pdf("Ancestry_map.K5.pdf", paper = 'a4') 
plot(q, coo, method = "map.max", interpol = FieldsKrigModel(1000), resolution = c(1200,1200),
    xlab="", ylab="", ce=.8, col.palette = my.palette)
map(add = T)
dev.off()

##Population structure map k=5 only color samples

Pop1=subset(Data.Coord.countries,Data.Coord.countries$Assignment==1)
Pop2=subset(Data.Coord.countries,Data.Coord.countries$Assignment==2)
Pop3=subset(Data.Coord.countries,Data.Coord.countries$Assignment==3)
Pop4=subset(Data.Coord.countries,Data.Coord.countries$Assignment==4)
Pop5=subset(Data.Coord.countries,Data.Coord.countries$Assignment==5)
Pop6=subset(Data.Coord.countries,Data.Coord.countries$Assignment==6)

pdf("Samples_map.K5.pdf", paper = 'a4')  #File name

plot(coo, method = "map.max", resolution = c(1200,1200), xlab="", ylab="", cex=.6)
points(Pop1$Longitude,Pop1$Latitude,col=adjustcolor("gold",alpha.f = 0.9), cex=.6)
points(Pop2$Longitude,Pop2$Latitude,col=adjustcolor("brown",alpha.f = 0.9), cex=.6)
points(Pop3$Longitude,Pop3$Latitude,col=adjustcolor("darkturquoise",alpha.f = 0.9), cex=.6)
points(Pop4$Longitude,Pop4$Latitude,col=adjustcolor("darkgreen",alpha.f = 0.9), cex=.6)
points(Pop5$Longitude,Pop5$Latitude,col=adjustcolor("darkblue",alpha.f = 0.9), cex=.6)
points(Pop6$Longitude,Pop6$Latitude,col=adjustcolor("gray",alpha.f = 0.9),cex=.6)
map(add = T)

# Add a legend
legend("bottomleft", legend = c("10", "9", "8", "7", "<6"),
       fill = c(adjustcolor("gold", alpha.f = 0.9), adjustcolor("brown", alpha.f = 0.9),
                adjustcolor("darkturquoise", alpha.f = 0.9), adjustcolor("darkgreen", alpha.f = 0.9),
                adjustcolor("darkblue", alpha.f = 0.9), adjustcolor("gray", alpha.f = 0.9)),
       title = "Populations", cex = 0.8)


dev.off()

