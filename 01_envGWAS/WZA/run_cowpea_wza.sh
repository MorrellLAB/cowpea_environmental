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
#script written by Roland A. (10/22/2025)

#This script run WZA on kendall tau-b correlation

set -e
set -o pipefail

# === Load dependencies ===
module load python3/3.10.9_anaconda2023.03_libmamba

# Activate conda environment
source activate /users/9/rakakpo/.conda/envs/snp_env

# Ensure correct C++ libraries
export LD_LIBRARY_PATH=/users/9/rakakpo/.conda/envs/snp_env/lib:$LD_LIBRARY_PATH

# === Define directories ===
INPUT_DIR="/scratch.global/rakakpo/Cowpea_Environment/WZA_ANALYSIS/"
SCRIPT="/users/9/rakakpo/rakakpo/Cowpea_Environment_Association/WZA_analysis/general_WZA_script.py"
cd ${INPUT_DIR}

WINDOW_SIZES=("10000" "20000" "30000" "40000" "50000")
OUTPUT_PREFIX="Cowpea_WZA"
SEP=","

for WIN_SIZE in "${WINDOW_SIZES[@]}"; do
    INPUT_FILE="Cowpea_kendall_tau_${WIN_SIZE}_perSNP.csv"

    # Get list of unique variables
    VARIABLES=$(tail -n +2 "$INPUT_FILE" | cut -d, -f4 | sort | uniq)

    for VAR in $VARIABLES; do
        (           
            # Create a temporary subset CSV with only this variable
            TEMP_FILE="tmp_${VAR}_${WIN_SIZE}.csv"
            awk -v var="$VAR" -F"$SEP" 'NR==1 || $4==var' "$INPUT_FILE" > "$TEMP_FILE"

            # Run WZA on this subset using p_value as summary_stat
            python3 $SCRIPT \
                --correlations "$TEMP_FILE" \
                --summary_stat p_value \
                --window window_id \
                --MAF MAF \
                --output "${OUTPUT_PREFIX}_${VAR}_${WIN_SIZE}.csv" \
                --sep "$SEP"
                --top_candidate_threshold 99

            rm "$TEMP_FILE"
        ) &
    done
done

# Wait for all background jobs to finish
wait
echo "=== All WZA analyses completed successfully! ==="
