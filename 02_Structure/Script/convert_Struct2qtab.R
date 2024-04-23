# Used to run the convertion of structure output in a usable table
# rakakpo
# January 2023
#St. Paul - UMN 
#dir=getwd() #: set directory in the output folder
#setwd(paste(dir,"/unCorrAllFreq", sep=""))
source("/Users/rakakpo/MorrellLab\ Dropbox/Roland\ Akakpo/Cowpea_Environmental_assoc/STRUCTURES/STRUCTURE_PITCHARD/Script/struct2qtab.R")
struct2qtab("Cowpea_GF_data_for_struct.recode.strct_in","/Users/rakakpo/MorrellLab\ Dropbox/Roland\ Akakpo/Cowpea_Environmental_assoc/STRUCTURES/STRUCTURE_PITCHARD/With_Admix/CorrAllFreq/Output/cowpea_struct_corr_all-freq_k5_run2_f")
