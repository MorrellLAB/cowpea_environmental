# Running sample_rank.py

* For any SNP that is an outlier in Fst or SPA analysis, we only have high allele frequency differentiation or a steep allele frequency gradient. 
* Which environmental factors could be associated with driving allele frequency differences?
* We find all individuals carrying the alternate (or derived) allele and ask if they occur in locations with extreme temperatures or precipitation.
* For cowpea, this is high temperature and low precipitation. We sort each sample by its value, so each sample has a rank.
  
## Creating input files
* To create the input from SNP genotypes, we use the bash script called `Sample_selection.sh`
* Required arguments are a list of SNP positions and a VCF, preferably indexed by bcftools.
* Note that we switch between reference and alternate genotypes by setting the genotype to "0/0" or "0/1", "1/1".
* This is an option on the command line when running `Sample_selection.sh`
* Searching for outliers might involve a list of SNPs where an alternate is desired and another where a reference is needed. 
* The script requires `bcftools`.

```bash

./Sample_selection.sh [SNP_positions.txt] [example_VCF.vcg.gz] > [sample_SNPs.txt]

```
  
## Running `sample_rank.py`
* This should create an output file that looks like "sample_alt_SNP2.txt".
* This is input for `sample_rank.py`. It is used along with a list of bioclim variables.
* We focus on three temperature and three precipitation variables, because they are easy to rank and interpret.
* 01, 05, and 08 are the temperature variables, and 12, 13, and 16 are used for precipitation


## Statistical testing
* The number of samples carrying our tested variant (reference or alternate) can be small. Still, we'd like to know if either temperature or precipitation is more strongly associated (lower ranked) for any given SNP. We divide the bioclim variables passed to the script into temperature and precipitation using the file `bioclim_classes.txt`. 
* We apply a [Friedman test](https://en.wikipedia.org/wiki/Friedman_test) (non-parametric repeated measures ANOVA) to determine if any of the variables show a higher rank.
