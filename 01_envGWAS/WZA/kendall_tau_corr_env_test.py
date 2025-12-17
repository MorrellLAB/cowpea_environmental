#!/usr/bin/env python3
"""
Kendall rank SNP–environment association analysis with window ID
"""

import argparse
import pandas as pd
import numpy as np
from pandas_plink import read_plink
from scipy.stats import kendalltau
from statsmodels.stats.multitest import multipletests

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--plink", required=True, help="PLINK file prefix (no extension)")
    parser.add_argument("--meta", required=True, help="Metadata CSV: ID,POP,<variables>")
    parser.add_argument("--window", type=int, default=2000, help="Window size (bp)")
    parser.add_argument("--out", default="kendall_results", help="Output prefix")
    args = parser.parse_args()

    # Load PLINK data
    print("Loading PLINK genotypes...")
    bim, fam, G = read_plink(args.plink)
    geno_array = G.compute().T  # samples x SNPs
    geno = pd.DataFrame(geno_array, columns=bim.snp, index=fam.iid)

    # Load metadata
    print("Loading metadata...")
    meta = pd.read_csv(args.meta)
    geno = geno.merge(meta, left_index=True, right_on="ID")

    env_vars = [c for c in meta.columns if c not in ["ID", "POP"]]
    print(f"Found {len(env_vars)} environmental/phenotypic variables.")

    # Compute allele frequencies per POP
    print("Computing allele frequencies per POP...")
    pop_groups = geno.groupby("POP")
    allele_freqs = pop_groups[bim.snp].mean() / 2.0
    pop_env = pop_groups[env_vars].mean()

    # Compute Kendall correlations
    print("Running per-SNP correlations...")
    results = []
    for snp in allele_freqs.columns:
        snp_freqs = allele_freqs[snp]
        maf = min(snp_freqs.mean(), 1 - snp_freqs.mean())
        chrom = bim.loc[bim.snp == snp, "chrom"].values[0]
        pos = bim.loc[bim.snp == snp, "pos"].values[0]

        for var in env_vars:
            tau, pval = kendalltau(snp_freqs, pop_env[var])
            results.append({
                "SNP": snp,
                "CHR": chrom,
                "POS": pos,
                "Variable": var,
                "tau_b": tau,
                "p_value": pval,
                "MAF": maf
            })

    results_df = pd.DataFrame(results)

    # Assign SNPs to windows
    print("Assigning SNPs to windows...")
    results_df["window_start"] = (results_df["POS"] // args.window) * args.window
    results_df["window_end"] = results_df["window_start"] + args.window - 1
    results_df["window_id"] = results_df["CHR"].astype(str) + ":" + results_df["window_start"].astype(str)

    # Multiple-testing correction
    results_df["FDR_p"] = multipletests(results_df["p_value"], method="fdr_bh")[1]

    # Save output
    print("Saving results...")
    results_df.to_csv(f"{args.out}_perSNP.csv", index=False)
    print("Done.")

if __name__ == "__main__":
    main()
