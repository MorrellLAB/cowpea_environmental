# Windowed Z-score Analysis (WZA) of SNP–Environment Associations in Cowpea

This workflow summarizes SNP-level Kendall tau-b results using **Windowed Z-score Analysis (WZA)** to identify genomic regions enriched for environmental associations.

* Individual SNP correlations are often weak and noisy.
* WZA aggregates SNP-level p-values within genomic windows.
* Analyses are performed separately for each environmental variable.
* Multiple window sizes improve robustness and interpretability.

## Inputs

* Per-SNP correlation files from Kendall tau-b analysis  
  (e.g. `Cowpea_kendall_tau_20000_perSNP.csv`)
* **Script**: `general_WZA_script.py`

## Outputs

Window-based WZA results for each variable and window size:
   
    - Cowpea_WZA_bio05_20000.csv
    -  Cowpea_WZA_bio12_20000.csv
    -  Cowpea_WZA_bio05_50000.csv


## Running WZA

- Subsets SNPs by environmental variable
- Computes window-level Z-scores

```bash
sbatch run_cowpea_wza.sh
