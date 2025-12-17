# Kendall Tau–b SNP–Environment Association (Cowpea)
This workflow compute per SNPs allele frequencies correlation with environmental variables using **Kendall’s tau-b statistic**.

## Overview

- Kendall’s tau-b is a non-parametric correlation robust to ties and non-normal data.
- SNP–environment correlations are computed genome-wide.
- Analyses are repeated across multiple window sizes (10–50 kb).

## Inputs

- **Genotypes**: PLINK-formatted files
- **Environment/Phenotypes**: CSV file with environmental variables
- **Script**: `kendall_tau_corr_env_test.py`

## Running the Analysis

```bash
sbatch run_cowpea_kendall_wza.sh
