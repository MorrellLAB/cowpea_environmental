#!/bin/bash
# convert tped/tfam to plink binary
# rakakpo
# 2023-10-03

# requires plink 1.9

# format tped tfam to binary equivalents for each Pheno

for pheno in "BIO1" "BIO10" "BIO11" "BIO12" "BIO13" "BIO14" "BIO15" "BIO16" "BIO17" "BIO18" "BIO19" "BIO2" "BIO3" "BIO4" "BIO5" "BIO6" "BIO7" "BIO8" "BIO9"

do

../plink-1.07-mac-intel/plink --bfile ./data/cowpea_envgwas_OK   --noweb --make-bed --out './data/cowpea_envgwas_'$pheno

#mkdir -p './data/'$pheno
mv './data/cowpea_envgwas_'$pheno'.bed'  './data/'$pheno
mv './data/cowpea_envgwas_'$pheno'.bim'  './data/'$pheno
mv './data/cowpea_envgwas_'$pheno'.fam'  './data/'$pheno

done

# copies of binary files for egwas analyses
#cp ../data/cowpea_gwas.bed ../data/cowpea_envgwas.bed
#cp ../data/cowpea_gwas.bim ../data/cowpea_envgwas.bim
