
library(stringr)
data.out<- list.files(full.names = F, pattern = "_k5_run")
data <- data.frame(NA_col = rep(NA, 5)) 

for(i in 1: length(data.out)){
  f <- readLines(data.out[i])
  s.line <- grep("Variance of ln likelihood",f,
              value=TRUE)
varl <- as.numeric(str_extract_all(s.line,"[0-9.]+")[[1]][1])
data[i,1] <- paste0("Run",i)  # Adding new variable to data
data[i,2] <- varl 
}
colnames(data)=c("Run","VarLik")
write.table(data,paste("Variance_likeliood.txt"),quote = FALSE,row.names = FALSE)
