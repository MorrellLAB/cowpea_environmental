#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --mem=12gb
#SBATCH --tmp=8gb
#SBATCH -t 06:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=rakakpo@umn.edu
#SBATCH -p small,ram256g,ram1t
#SBATCH -o %j.out
#SBATCH -e %j.err

set -e
set -o pipefail

# This script will run VCF_to_ESTSFS.py

module load python3/3.8.3_anaconda2020.07_mamba

# User provided input arguments

EST_FILE=/panfs/jay/groups/9/morrellp/rakakpo/Cowpea_Environment_Association/envGWAS/SNP_Orientation/angularis_selected_snp.bed
VCF=/panfs/jay/groups/9/morrellp/rakakpo/Cowpea_Environment_Association/envGWAS/SNP_Orientation/selected_snp.EST
OUT_PREFIX=selected_snp
OUT_DIR=/panfs/jay/groups/9/morrellp/rakakpo/Cowpea_Environment_Association/envGWAS/SNP_Orientation

# Check if our dir exists, if not make it
mkdir -p ${OUT_DIR}

# Go into reference dir
cd ${OUT_DIR}

# Conversion with VCF_to_ESTSFS.py
python3 ${OUT_DIR}/Script/ESTSFS_to_ancestral.py ${VCF} ${EST_FILE} ${OUT_PREFIX} Probabilitypercentagethreshold