#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --mem=12gb
#SBATCH --tmp=8gb
#SBATCH -t 24:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=rakakpo@umn.edu
#SBATCH -p msismall
#SBATCH -o %j.out
#SBATCH -e %j.err
#script writed by Roland A. (10/22/2025)

#This script run kendall tau-b correlation

set -e
set -o pipefail

#dDependencies
module load python3/3.10.9_anaconda2023.03_libmamba
module load parallel
source activate /users/9/rakakpo/.conda/envs/snp_env
export LD_LIBRARY_PATH=/users/9/rakakpo/.conda/envs/snp_env/lib:$LD_LIBRARY_PATH

GENO_FILE="/users/9/rakakpo/rakakpo/Cowpea_Environment_Association/WZA_analysis/Cowpea_GF_Data_new"
PHENO_FILE="/users/9/rakakpo/rakakpo/Cowpea_Environment_Association/WZA_analysis/Cowpea_Pheno_Data_all.csv"
SCRIPT="/users/9/rakakpo/rakakpo/Cowpea_Environment_Association/WZA_analysis/kendall_tau_corr_env_test.py"
OUT_DIR="/scratch.global/rakakpo/Cowpea_Environment/WZA_ANALYSIS"

mkdir -p ${OUT_DIR}
cd ${OUT_DIR}

# Run the script for each window size in parallel
parallel -j 5 "
  echo '▶ Running window size {} bp';
  /users/9/rakakpo/.conda/envs/snp_env/bin/python3 $SCRIPT \
    --plink ${GENO_FILE} \
    --meta ${PHENO_FILE} \
    --window {} \
    --out ${OUT_DIR}/Cowpea_kendall_tau_{}
" ::: 10000 20000 30000 40000 50000

echo "All window-size analyses completed successfully!"