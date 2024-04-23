#!/bin/bash
# fit mlm with gemma
# rakakp007

# requires GEMMA 0.98.5

for pheno in "TMIN" "TMAX" "PREC"# "BIO1" "BIO10" "BIO11" "BIO12" "BIO13" "BIO14" "BIO15" "BIO16" "BIO17" "BIO18" "BIO19" "BIO2" "BIO3" "BIO4" "BIO5" "BIO6" "BIO7" "BIO8" "BIO9" "TMIN" "TMAX" "PREC"

do
# define variables 
GENO='./'$pheno'/cowpea_envgwas_'$pheno # plink basename
KINSHIP='./'$pheno'/results/'relmtx_envgwas.cXX.txt # relatedness mtx
EIGEND='./'$pheno'/results/'relmtx_envgwas.eigenD.txt # relatedness mtx Eigen decomposition Vector
EIGENU='./'$pheno'/results/'relmtx_envgwas.eigenU.txt # relatedness mtx Eigen decomposition Value
COL=1 # line in PHENOS and col (5 + N) in .fam 
#PHENOS='./data/Initial_Data/worldclim_vars.txt' # list of phenotypes/climate vars
#PHENO_NAME=$(head -n "$COL" "$PHENOS" | tail -n 1 | cut -f1) # parsed pheno/var name
OUT='./'$pheno'/results'

# association with mlm
echo $pheno
#gemma -debug -bfile $GENO -n $COL -gk $KINSHIP -lmm 4 -outdir $OUT -o $pheno
gemma -debug -bfile $GENO -n $COL -d $EIGEND -u $EIGENU  -lmm 4 -outdir $OUT -o $pheno

done


# prep file for mannhatan plot

#echo "prep plot file"

#R CMD BATCH "./scripts/006_prep_result_plot.R"


#for pheno in "BIO1" "BIO10" "BIO11" "BIO12" "BIO13" "BIO14" "BIO15" "BIO16" "BIO17" "BIO18" "BIO19" "BIO2" "BIO3" "BIO4" "BIO5" "BIO6" "BIO7" "BIO8" "BIO9" #"TMIN" "TMAX" "PREC"

#do

#cp './'$pheno'/results/'Candidates_*.csv  ~/MorrellLab\ Dropbox/Roland\ Akakpo/COWPEA/Gwas_Results/Candidate_files

#done

