# Temperature-related hits

 Looking carefully at all of the Bioclim variables, we noted that for temperature, Bioclim 01, 05, and 08 most naturally define environmental conditions with high temperatures during the likely growing season. Other variables like BIO3 (Isothermality, which is the  rescaled quotient of two complex variables) or BIO06 (Min Temperature of Coldest Month) don't really help to determine if a sample ranks highly in terms of occurring in a high-temperature growing environment. So, the two files below include SNP hits for temperature, with BIO1, BIO5, and BIO8 ranks for each accession (out of 580 total), and then in the final column, an indication if the variant we need to track is the reference "0" or alternate "1" in the IT97K reference assembly.
BIO1 = Annual Mean Temperature
BIO5 = Max Temperature of Warmest Month
BIO8 = Mean Temperature of Wettest Quarter
All temperature hits: https://www.dropbox.com/scl/fi/ye8wz20qm6wvarrdt6hsd/sample_rank_temp.txt?rlkey=l990ttfvnq6l8nyd51bctxmd8&dl=0
Rare temperature hits: https://www.dropbox.com/scl/fi/ay4s148hj0is4uja3t9bf/sample_rank_temp_IITA_rare.txt?rlkey=fmpzetjwfamu3s58tnpgro9n0&dl=0

In a similar manner, BIO12, BIO13, and BIO16 are the most helpful for understanding which samples occur in relatively dry conditions during the likely growing period in dry environments.
BIO12 = Annual Precipitation
BIO13 = Precipitation of Wettest Month
BIO16 = Precipitation of Wettest Quarter
All precipitation hits: https://www.dropbox.com/scl/fi/jv0s9jvqveydpqhieuxkt/sample_rank_prec.txt?rlkey=59lgwnujjfuco3juojc5miq7n&dl=0
Rare precipitation hits: https://www.dropbox.com/scl/fi/bkpnk4k8pp59i9qh8n7um/sample_rank_prec_IITA_rare.txt?rlkey=3177u7b0c2i2j2s6bcn4psu6j&dl=0

For the HEAT hits relative to the TMAX, we only have one sorted list to compare against. There are also **no** heat hits that are rare in the IITA sample.
All heat hits: https://www.dropbox.com/scl/fi/o8ambh52e6bd5vryjvoal/sample_rank_heat.txt?rlkey=3tstsce6zy4r5x1ii4kpevq40&dl=0


##  Create cowpea heat SNP rank lists with ref "0" or alt "1" allele in last column

```bash
cd /panfs/jay/groups/9/morrellp/rakakpo/Cowpea_Environment_Association/envGWAS/Sample_Selection/
[//]: Add reference or alternate state to the sample by SNP lists
paste sample_rank_heat_Alt.txt <( yes "1" | head -n 397) >Alt.temp.txt
paste sample_rank_heat_Ref.txt <( yes "0" | head -n 144) >Ref.temp.txt
[//]:  
cat Ref.temp.txt Alt.temp.txt | sort -k1,1 -k2,2n >sample_rank_heat.txt 


paste sample_rank_temp_Alt.txt <( yes "1" | head -n 4120) >Alt.temp.txt  
paste sample_rank_temp_Ref.txt <( yes "0" | head -n 1467) >Ref.temp.txt 

[//]: SNPs at >= 5% in IITA lines
IITA=/scratch.global/pmorrell/Cowpea/IITA_05.txt 

cd /panfs/jay/groups/9/morrellp/rakakpo/Cowpea_Environment_Association/envGWAS/Sample_Selection/Ranking_HEAT
grep -F -f $IITA sample_rank_heat.txt
[//]: No results (none of the "heat" hits are rare in the IITA breeding lines).

cd /panfs/jay/groups/9/morrellp/rakakpo/Cowpea_Environment_Association/envGWAS/Sample_Selection/Ranking_PREC 
grep -F -f $IITA sample_rank_prec.txt >sample_rank_prec_IITA_rare.txt
[//]: Below are the number of lines that carry each of the SNPs that are relatively rare in the IITA breedling lines._
cut -f 3 sample_rank_prec_IITA_rare.txt | uniq -c   | sort -k1,1nr                                                                                                                                
> 147		2_38352
> 86		2_14879
> 64		2_25699
> 52		2_13041
> 45		2_32219
> 44		2_19054
> 44		2_46033
> 44		2_48742
> 39		2_53933
> 37		2_33808
> 20		2_18705
> 19		2_00869
> 16		2_36129
> 16		2_37055
> 11		2_34846
> 5		2_21678
> 5		2_21837
> 5		2_31426
> 3		2_46157
> 1		2_33347
	                                                                                                                                                                                                              
cd /panfs/jay/groups/9/morrellp/rakakpo/Cowpea_Environment_Association/envGWAS/Sample_Selection/Ranking_TEMP 
cut -f 3 sample_rank_temp_
IITA_rare.txt | uniq -c | sort -k1,1nr
> 72		2_03849                                                                                                                                         
> 59		2_08720
> 47		2_03926                                                                                                                                         
> 37		2_37909
> 33		2_16559                                                                                                                                         
> 32		2_26730
> 18		2_28218                                                                                                                                         
> 15		2_34849
> 11		2_35005                                                                                                                                         
> 9		2_34967
> 2		2_22529 
```
