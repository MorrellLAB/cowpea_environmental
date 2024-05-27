# _F_<sub>ST</sub> outliers analysis for identification of candidate accessions


* Only the _F_<sub>ST</sub> comparison between Western African accessions north and south of 12˚N latitude appears appropriate for outlier analysis. The _F_<sub>ST</sub> values in our other comparisons are inflated, suggesting demographic effects (probably during introduction of the domesticate) have skewed the comparisons.
* To identify the top 0.001 portion (or 0.%) of the values, we discarded NA values and ended up with the 44 highest values in the sample.

```bash
sed '1d' /Users/pmorrell/Library/CloudStorage/Dropbox/Documents/Work/Projects/COWPEA/NEW_ANALYSIS_580/Fst_Results/Fst_All_Acc2/Fst_1vs2.OK.txt | sed '/NA/d' | sort -k4,4r | sed '/e-0/d' | head -n 44 | sort -k1,1n -k3,3n

[//]: Write the outliers to a list and to a file.
sed '1d' /Users/pmorrell/Library/CloudStorage/Dropbox/Documents/Work/Projects/COWPEA/NEW_ANALYSIS_580/Fst_Results/Fst_All_Acc2/Fst_1vs2.OK.txt | sed '/NA/d' | sort -k4,4r | sed '/e-0/d' | head -n 44 | sort -k1,1n -k3,3n | cut -f 2 >Fst_1_2_0.01.txt

[//]: Produce a BED file of Fst outliers
[//]: The last sed trick here is replacing chromosome names as numbers with the naming in the VCF
sed '1d' /Users/pmorrell/Library/CloudStorage/Dropbox/Documents/Work/Projects/COWPEA/NEW_ANALYSIS_580/Fst_Results/Fst_All_Acc2/Fst_1vs2.OK.txt | sed '/NA/d' | sort -k4,4r | sed '/e-0/d' | head -n 44 | sort -k1,1n -k3,3n | awk -v OFS='\t' '{print $1, $3-1, $3, $2, $4}' | sed '1,39s/^/Vu0/' >~/Desktop/temp.txt
[//]: Add the last set of chromosome renames. The sed command appends text to the start of the 
sed '40,45s/^/Vu/' ~/Desktop/temp.txt >~/Desktop/Fst_1_2_outliers.bed
```

* Several of the "hits" below occur in relatively small genomic regions (10s of kb). This includes:
Vu02 - 2 SNPs - 17,193 bp
Vu03 - 2 SNPs - 16,698 bp
Vu04 - 2 SNPs - 25,876 bp
Vu05 - 2 SNPs - 6,052 bp
Vu07 - 6 SNPs - 64,686 bp
Vu08 - 7 SNPs - 26,803 bp
etc.
* The clusters for high _F_<sub>ST</sub> values suggest that we perform pairwise LD calculations and then consider admitting more values to the outliers list if any SNPs are in complete LD. 

> 1	2_41147	35265694	0.367421642358759
> 2	2_40702	2161789	0.447939419124922
> 2	2_23980	18984962	0.373396978900565
> 2	2_25308	20227677	0.371434409403405
> 2	2_07556	20244870	0.365564798316494
> 3	2_00372	38214324	0.375015543691666
> 3	2_22916	38231022	0.368525334492991
> 3	2_25127	55523972	0.367070040094734
> 4	2_47878	12434298	0.383600433040954
> 4	2_40290	12460174	0.389740721443185
> 4	2_30891	14635703	0.366013666006195
> 4	2_40224	24273744	0.40412322809911
> 5	2_18508	3708611	0.368754760734881
> 5	2_53903	3739351	0.404886057400438
> 5	2_19601	3802677	0.407273132016061
> 5	2_25041	3835894	0.430975934140196
> 5	2_27980	5936454	0.365169438523407
> 5	2_08871	5942506	0.392285478317333
> 7	2_28186	26109238	0.388022532966218
> 7	2_21861	26137988	0.388022532966218
> 7	2_48714	26149694	0.388906749740679
> 7	2_49476	26156897	0.388022532966218
> 7	2_25770	26168611	0.440645803231621
> 7	2_03060	26173924	0.442324938145776
> 8	2_00857	7392202	0.366142054470416
> 8	2_09973	7405223	0.366142054470416
> 8	2_29223	7406627	0.372196772361942
> 8	2_51987	7408089	0.372196772361942
> 8	2_53354	7412329	0.372872683872133
> 8	2_52823	7417594	0.378947461554334
> 8	2_51407	7419005	0.366446258972751
> 8	2_07072	30038329	0.369921954473476
> 8	2_06639	30099911	0.365935157745276
> 8	2_00885	34707621	0.404014544422258
> 9	2_14668	31846740	0.373958710372657
> 9	2_51380	38945148	0.451429090929663
> 9	2_25481	41181696	0.384554079271652
> 9	2_05643	41247766	0.384307281750177
> 9	2_14464	41270428	0.386258619117204
> 11	2_25564	35441960	0.458509444693706
> 11	2_02052	35816995	0.392229210392671
> 11	2_02051	35817750	0.392229210392671
> 11	2_17698	39316305	0.398862745375085
> 11	2_19641	39324907	0.428637587685224

* This _F_<sub>ST</sub>  analysis compared samples in Western Africa from above and below 12˚N latitude. The nature of the environmental factors that could be associated with large allele frequency differences in unknown, but they differ by temperature and precipitation values.
* Path to Bioclim temperature and precipitation values. Run the sample rank tool for Fst outliers.
B01=/scratch.global/pmorrell/Cowpea/cowpea_environmental/03_Analyses/Cowpea_Bioclim01.txt
B05=/scratch.global/pmorrell/Cowpea/cowpea_environmental/03_Analyses/Cowpea_Bioclim05.txt
B08=/scratch.global/pmorrell/Cowpea/cowpea_environmental/03_Analyses/Cowpea_Bioclim08.txt
B12=/panfs/jay/groups/9/morrellp/rakakpo/Cowpea_Environment_Association/envGWAS/Sample_Selection/Ranking_PREC/Cowpea_Bioclim12.txt
B13=/panfs/jay/groups/9/morrellp/rakakpo/Cowpea_Environment_Association/envGWAS/Sample_Selection/Ranking_PREC/Cowpea_Bioclim13.txt
B16=/panfs/jay/groups/9/morrellp/rakakpo/Cowpea_Environment_Association/envGWAS/Sample_Selection/Ranking_PREC/Cowpea_Bioclim16.txt
VCF=/panfs/jay/groups/9/morrellp/pmorrell/Workshop/Cowpea/cowpea_490_stats_AA_rename.vcf.gz
POS=/panfs/jay/groups/9/morrellp/pmorrell/Fst_1_2_positions.txt

```bash
cd /panfs/jay/groups/9/morrellp/pmorrell/Workshop/Cowpea/Fst
bash Sample_selection.sh Fst_1_2_positions.txt cowpea_490_stats_AA_rename.vcf.gz >sample_Fst_hits.txt
[//]: Add the actual command to produce the environmental ranks here!
python3 

* For sampling purposes, we are only interested in _F_<sub>ST</sub> outliers that fall within our desirable sampling range, roughly 8˚N to 17˚N at the edge of the range limit. The list produced includes only those variants accessions in that geography 
grep -F -f lat_8-17.txt sample_rank.txt >sample_rank_lat_8-17N.txt 
* 

* Fst outliers that are rare in the IITA samples
```bash
cd ~/Workshop/Cowpea/Fst
[//]: Fst outliers that fall within our desirable sample range
grep -F -f lat_8-17.txt sample_rank.txt >sample_rank_lat_8-17N.txt
[//]: Samples and the number of rare variants they carry relative to the 6 Bioclime variables. Are 12 SNPs are rare in the IITA samples.
grep -F -f IITA_Fst_rare.txt sample_rank_lat_8-17N.txt | cut -f 4-10 | sort -k1,1 | uniq -c | sort -k1,1nr >IITA_Fst_rare_sample_sort.txt  

grep -F -f lat_8-17.txt sample_rank.txt | grep '2_23980' | sort -k5,5n | less
```
Vu02    18984962        2_23980 TVu-11954       6       3       2       194     8       261
Vu02    18984962        2_23980 TVu-14402       2       1       4       151     172     240                                                                      
Vu02    18984962        2_23980 TVu-14401       4       2       5       135     160     221                                                                      
Vu02    18984962        2_23980 TVu-15307       5       6       19      143     151     232  

```bash
grep -F -f lat_8-17.txt sample_rank.txt | grep '2_25308' | sort -k5,5n | less 
```
Vu02    20227677        2_25308 TVu-14402       2       1       4       151     172     240                                                                      
Vu02    20227677        2_25308 TVu-14401       4       2       5       135     160     221                                                                      
Vu02    20227677        2_25308 TVu-14396       20      28      3       173     4       256                                                                      
Vu02    20227677        2_25308 TVu-14850       25      6       33      112     147     206
* 2_07556 as above

grep -F -f lat_8-17.txt sample_rank.txt | grep '2_40224' | sort -k5,5n | less  

Vu04    24273744        2_40224 TVu-14402       2       1       4       151     172     240                                                                      
Vu04    24273744        2_40224 TVu-14401       4       2       5       135     160     221                                                                      
Vu04    24273744        2_40224 TVu-14850       25      6       33      112     147     206                                                                      
Vu04    24273744        2_40224 TVu-14539       31      4       22      143     164     236                                                                      
Vu04    24273744        2_40224 TVu-14405       32      29      12      138     168     225                                                                      
Vu04    24273744        2_40224 TVu-14406       32      29      12      138     168     225                                                                      
Vu04    24273744        2_40224 TVu-3897        33      9       20      145     160     233                                                                      
Vu04    24273744        2_40224 TVu-8123        41      33      87      17      83      77    

grep -F -f lat_8-17.txt sample_rank.txt | grep '2_28186' | sort -k5,5n | less

Vu07    26109238        2_28186 TVu-14402       2       1       4       151     172     240                                                                      
Vu07    26109238        2_28186 TVu-14401       4       2       5       135     160     221                                                                      
Vu07    26109238        2_28186 TVu-15307       5       6       19      143     151     232                                                                      
Vu07    26109238        2_28186 TVu-15299       11      7       31      141     156     231                                                                      
Vu07    26109238        2_28186 TVu-15295       13      7       31      148     163     241                                                                      
Vu07    26109238        2_28186 TVu-14396       20      28      3       173     4       256 

grep -F -f lat_8-17.txt sample_rank.txt | grep '2_21861' | sort -k5,5n | less

Vu07    26137988        2_21861 TVu-14402       2       1       4       151     172     240                                                                      
Vu07    26137988        2_21861 TVu-14401       4       2       5       135     160     221                                                                      
Vu07    26137988        2_21861 TVu-15307       5       6       19      143     151     232                                                                      
Vu07    26137988        2_21861 TVu-15299       11      7       31      141     156     231                                                                      
Vu07    26137988        2_21861 TVu-15295       13      7       31      148     163     241                                                                      
Vu07    26137988        2_21861 TVu-14396       20      28      3       173     4       256                                                                      

grep -F -f lat_8-17.txt sample_rank.txt | grep '2_19641' | sort -k5,5n | less

Vu11    39324907        2_19641 TVu-14402       2       1       4       151     172     240
Vu11    39324907        2_19641 TVu-14401       4       2       5       135     160     221                                                                     
Vu11    39324907        2_19641 TVu-15307       5       6       19      143     151     232
Vu11    39324907        2_19641 TVu-15299       11      7       31      141     156     231                                                                     
Vu11    39324907        2_19641 TVu-15295       13      7       31      148     163     241  


sed '1d' /Users/pmorrell/Library/CloudStorage/Dropbox/Documents/Work/Projects/COWPEA/NEW_ANALYSIS_580/Fst_Results/Fst_All_Acc2/Fst_1vs2.OK.txt | sed '/NA/d' | sort -k4,4r | sed '/e-0/d' | head -n 44 | sort -k1,1n -k3,3n | cut -f 2 >Fst_1_2_0.01.txt


bcftools view --include ID==@Fst_1_2_0.01.txt Partner_Favorites/IITA_Partner_Favorites_stats.vcf.gz | bcftools query 

* Grab the MAF from the panel of all Fst outliers!
bcftools view --include ID==@Fst_1_2_0.01.txt cowpea_490_stats_AA_rename.vcf.gz | bcftools query -f '%CHROM\t%END\t%ID\t%INFO/MAF\n' | cut -f 4 
