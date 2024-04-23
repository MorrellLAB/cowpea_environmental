Descriptions of the scripts

# 1.	Ped2Geno_for_association_analysis.R

This is a script is used to convert from plink PED file to 012 file and impute the datafile for association analysis based on DIPLOID data

# 2.	Run_envGWAS_SE.sh
This script perform GWAS analysis on the Dataset without SE accessions.  
It requires R_envGWAS.V4.R, Genotype and Phenotype Data.   
Please fill out user provided argument fields and submit script as job.


# 3.	Run_envGWAS_all.sh

This script perform GWAS analysis on the whole Dataset including SE accessions. 
It requires R_envGWAS.V4.R, Genotype and Phenotype Data.   
Please fill out user provided argument fields and submit script as job.

# 4.	R_envGWAS.V4.R
This is the main script to perform envGWAS. It uses three GWAS methods: LFMM, BLINK and FarmCPU. Only BLINK and FarmCPU interested us. 
Line 34: Set the number of counfounding factors to estimate. That is accessing by PCA or Structure
Lines 105 and 106: Run Blink and Farmcpu Gwas. The "Major.allele.zero = TRUE" Flag indicate we want the effect computed to be respective to the minor alleles.
#How do the Minor alleles frequency is calculated?
Before considering minor alleles in the dataset, Gapit calculate the allele frequencies for each variant in the dataset. It can do this by counting the number of 0 i.e. homozygous reference alleles, the number of 1 I.e.  heterozygous alleles, and the number of 2 i.e. homozygous alternate alleles and dividing them by the total number of alleles for each variant. This will return the frequency of the minor allele (the 1 or 2) in the population. 

# 5.	R_manhattan_plotsV4_fdr.R
This script produces plots for the association analysis. It will also produce tables of candidates loci using a FDR threshold


