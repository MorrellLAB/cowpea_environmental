#!/usr/bin/env python3
"""
Spearman rank SNP–environment association analysis
=================================================

Inputs:
  --plink   : prefix of PLINK .bed/.bim/.fam files
  --meta    : CSV with columns: ID, POP, <env/phenotype variables...>
  --window  : window size in bp (default 2000)
  --out     : output prefix
"""

import argparse
import pandas as pd
import numpy as np
np.float = float
from pandas_plink import read_plink
from scipy.stats import spearmanr
from statsmodels.stats.multitest import multipletests

# ---------------------------------------------------------------------
def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--plink", required=True, help="PLINK file prefix (no extension)")
    parser.add_argument("--meta", required=True, help="Metadata CSV: ID,POP,<variables>")
    parser.add_argument("--window", type=int, default=2000, help="Window size (bp)")
    parser.add_argument("--out", default="spearman_results", help="Output prefix")
    args = parser.parse_args()

    # === Load PLINK data ===
    print("Loading PLINK genotypes...")
    (bim, fam, G) = read_plink(args.plink)
    geno_array = G.compute().T  # samples x SNPs

    # Convert to DataFrame with correct row labels
    geno = pd.DataFrame(geno_array, columns=bim.snp, index=fam.iid)

    # === Load metadata ===
    print("Loading metadata...")
    meta = pd.read_csv(args.meta)

    # Merge genotypes with metadata on sample ID
    geno = geno.merge(meta, left_index=True, right_on="ID")

    env_vars = [c for c in meta.columns if c not in ["ID", "POP"]]
    print(f"Found {len(env_vars)} environmental/phenotypic variables.")

    # === Compute allele frequencies per POP ===
    print("Computing allele frequencies per POP...")
    pop_groups = geno.groupby("POP")
    allele_freqs = pop_groups[bim.snp].mean() / 2.0  # genotype dosage 0/1/2 -> freq

    # === Prepare POP-level variable means ===
    pop_env = pop_groups[env_vars].mean()

    # === Compute Spearman correlations ===
    print("Running per-SNP correlations...")
    results = []
    for snp in allele_freqs.columns:
        snp_freqs = allele_freqs[snp]
        maf = min(snp_freqs.mean(), 1 - snp_freqs.mean())
        chrom = bim.loc[bim.snp == snp, "chrom"].values[0]
        pos = bim.loc[bim.snp == snp, "pos"].values[0]

        for var in env_vars:
            rho, pval = spearmanr(snp_freqs, pop_env[var])
            results.append({
                "SNP": snp,
                "CHR": chrom,
                "POS": pos,
                "Variable": var,
                "rho": rho,
                "p_value": pval,
                "MAF": maf
            })

    results_df = pd.DataFrame(results)

    # === Assign SNPs to windows ===
    print("Assigning SNPs to windows...")
    results_df["window"] = (results_df["POS"] // args.window).astype(int)

    # === Multiple-testing correction ===
    results_df["FDR_p"] = multipletests(results_df["p_value"], method="fdr_bh")[1]

    # === Summarize by window ===
    window_summary = (
        results_df.groupby(["CHR", "window", "Variable"])
        .agg(
            mean_rho=("rho", "mean"),
            mean_MAF=("MAF", "mean"),
            min_p_value=("p_value", "min"),
            n_SNPs=("SNP", "count")
        )
        .reset_index()
    )

    # === Write outputs ===
    print("Saving results...")
    results_df.to_csv(f"{args.out}_perSNP.csv", index=False)
    window_summary.to_csv(f"{args.out}_perWindow.csv", index=False)
    print("Done.")

# ---------------------------------------------------------------------
if __name__ == "__main__":
    main()
