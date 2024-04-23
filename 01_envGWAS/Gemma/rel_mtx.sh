#!/bin/bash
# calc relatedness mtx w/ gemma
# rakakp007

# requires GEMMA 0.98.4

# define vars

for pheno in "BIO1" "BIO10" "BIO11" "BIO12" "BIO13" "BIO14" "BIO15" "BIO16" "BIO17" "BIO18" "BIO19" "BIO2" "BIO3" "BIO4" "BIO5" "BIO6" "BIO7" "BIO8" "BIO9" #"TMIN" "TMAX" "PREC" 

do
GENO1='./'$pheno'/cowpea_envgwas_'$pheno
OUT='./'$pheno'/results'

# calc centered relatedness matrix for envgwas
gemma -bfile "$GENO1" -gk 1 -outdir "$OUT" -o relmtx_envgwas


done


