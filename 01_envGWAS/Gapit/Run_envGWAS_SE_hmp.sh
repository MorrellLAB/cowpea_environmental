#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem=100gb
#SBATCH --tmp=100gb
#SBATCH -t 24:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=rakakpo@umn.edu
#SBATCH -p amd2tb,ram1t
#SBATCH -o %j.out
#SBATCH -e %j.err

#script script.R /path/to/Cowpea_Pheno_Data.txt /path/to/genotype_data/Cowpea_GF_Data.txt


# requires R version 4.0.4

module load R/4.0.4


Rscript /panfs/jay/groups/9/morrellp/rakakpo/Cowpea_Environment_Association/envGWAS/Script/R_envGWAS.V4.SE.hmp.R "/panfs/jay/groups/9/morrellp/rakakpo/Cowpea_Environment_Association/envGWAS/phenotype_data/Cowpea_Pheno_Data_Without_SE.txt" "/panfs/jay/groups/9/morrellp/rakakpo/Cowpea_Environment_Association/envGWAS/genotype_data/SNPs_WithoutSE_MAF0.02.hmp.txt"

