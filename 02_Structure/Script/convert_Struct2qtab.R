# Used to run the convertion of structure output in a usable table
# rakakpo
# January 2023
#St. Paul - UMN 
#dir=getwd() #: set directory in the output folder
#setwd(paste(dir,"/unCorrAllFreq", sep=""))
source("~/MorrellLab Dropbox/Roland Akakpo/IITA_CORE_DATA/cowpea_gwas-main/STRUCTURES/STRUCTURE_PITCHARD/Script/struct2qtab.R")
struct2qtab("../../Data/cowpea_snp_for_structure_pruned_data.recode.strct_in","cowpea_struct_corr_all-freq_k5_run4_f")

