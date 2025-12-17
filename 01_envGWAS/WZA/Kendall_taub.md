# Kendall Tau–b SNP–Environment Association (Cowpea)

This workflow compute per SNPs allele frequencies correlation with environmental variables using **Kendall’s tau-b statistic**.

## Overview

 * Kendall’s tau-b is a non-parametric correlation robust to ties and non-normal data.
 * SNP–environment correlations are computed genome-wide.
 * Analyses are repeated across multiple window sizes (10–50 kb).

## Inputs

  **Genotypes**: PLINK-formatted files
  **Environment/Phenotypes**: CSV file with environmental variables
  **Script**: `kendall_tau_corr_env_test.py`
  
## Outputs
Per-SNP correlation results for each window size:

  * Cowpea_kendall_tau_10000_perSNP.csv
  * Cowpea_kendall_tau_20000_perSNP.csv
    
These per-SNP results are used as input for Windowed Z-score Analysis (WZA) to identify genomic regions enriched for environmental associations.

## Running the Analysis

```bash
sbatch run_cowpea_kendall_wza.sh


