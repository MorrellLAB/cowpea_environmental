#!/bin/bash -l

# Peter L. Morrell - 11 April 2024 - Falcon Heights, MN

set -e
set -o pipefail

# Usage: Provide a list of SNP positions in the form chromsome:position 
# (e.g, Vu01:20060064). The other required input is the named of a VCF file 
# indexed by bcftools. The current version of the script is designed to report
# all individuals with the alternate allele in the homozygous or heterozygous 
# state. Use --ref flag to get reference alleles (0/0) instead.

# Default to alternate alleles
ALLELE_PATTERN="/0\/1|1\/1/"
ALLELE_TYPE="alternate"

# Parse command line arguments
while [[ $# -gt 2 ]]; do
    case $1 in
        --ref)
            ALLELE_PATTERN="/0\/0/"
            ALLELE_TYPE="reference"
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--ref] <snp_positions_file> <vcf_file>"
            exit 1
            ;;
    esac
done

if [[ $# -lt 2 ]]; then
    echo "Usage: $0 [--ref] <snp_positions_file> <vcf_file>"
    echo "  --ref: Select reference alleles (0/0) instead of alternate (0/1|1/1)"
    exit 1
fi

module load bcftools/1.16-gcc-8.2.0-5d4xg4y

readarray -t SNP_POS < $1
VCF=$2

printf "Selecting %s alleles\n" "$ALLELE_TYPE"
printf '%s\n' "${SNP_POS[@]}"

for i in "${SNP_POS[@]}"
    do
    bcftools view -r "$i" "$VCF" |
    bcftools query -f '[%CHROM\t%POS\t%ID\t%SAMPLE\t%GT\n]' |
    awk -v FS='\t' -v OFS='\t' '$5 ~ '"$ALLELE_PATTERN"' {print $1, $2, $3, $4}'
    done

