# Cowpea SNP–Environment Association Analysis using WZA method

This repository contains scripts to test genotype–environment associations in cowpea using the non-parametric correlation method of Kendall’s tau-b and to summarize SNP-level signals with Windowed Z-score Analysis (WZA).

 * SNP allele frequencies are tested for association with environmental variables using rank-based correlations.
 * Analyses are run genome-wide and repeated across multiple window sizes (10–50 kb).
 * SNP-level p-values are combined within genomic windows using WZA to identify regions enriched for environmental associations.

## Contents

- **Correlation tests**
  - `kendall_tau_corr_env_test.py`: SNP–environment associations using Kendall’s tau-b
   
- **WZA**
  - `general_WZA_script.py`: Aggregates SNP-level p-values into window-level Z-scores
  
- **SLURM workflows**
  - `run_cowpea_kendall_wza.sh`: Runs Kendall tau-b correlations across multiple window sizes
  - `run_cowpea_wza.sh`: Runs WZA for each environmental variable and window size

