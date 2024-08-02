# Ancestral state inference for cowpea iSelect 50k SNPs

* Borrowing heavily from ancestral state inference from Chaochih Liu, as presented in this [repository][1]
* Using estSFS from [Keightley & Jackson 2018][2] and two conversion scripts written by Jacob Pacheco
    * [VCF_to_ESTSFS.py][3] 
    * [ESTSFS_to_ancestral.py][4]

## Outgroup taxa, using data from a bioRxiv manuscript with 12 Vigna genome assemblies

* [Naito et al. 2022][5] - taxa chosen are ((_Vigna unguiculata_, _Vigna vexillata_), _Vigna marina,_ _Vigna triolobata_) in the phylogentic order depicted.
* The phylogenetic relationship is inferred relative to relationships reported by [CITE][6]

## Approaches for inference
* Map assemblies to IT97K genome assembly (Vunguiculata_540_v1.0.fa) using minimap2 using the script [here][7]
    * The options for [minimap2][8] include presets for divergence, including ASM5, ASM10, ASM20
* SAM alignment files are sorted and indexed and converted to a BAM file with the script [here][9]
* Testing two options for analysis
1. ANGSD `dofasta` [command][10], which creates a FASTA sequence for the new sample relative to alignment to reference. Missing data is reported as 'N' in FASTA format, but positions are the same as the reference. This approach also uses bedtools [`getFasta`][11] with a [VCF][12] of positions to convert FASTA positions of SNPs into a BED file of positions and state in the outgroup.

2. bcftools [`mpileup`][13] using the BAM file above.

## Results of alignments
 
* Of the two approaches above, ANGSD `doFasta` yields many more SNP states from outgroup samples.


|  Alignment approach |      Vmarina    |   Vtriolobata   |   Vexillata   |
| :-------------------|  :------------: | :-------------: |  -----------: |
|     ANGSD ASM5      |    6750 SNPS    |  8444 SNPS      |   16400 SNPS  |
|     ANGSD ASM10     |    17306 SNPS   |  19198 SNPS     |   25054 SNPS  |          
|     ANGSD ASM20     |    22251 SNPS   |  23358 SNPS     |   27954 SNPS  |              
|      MPileUP        |    10281 SNPS   |  10955 SNPS     |   12869 SNPS  |   


## estSFS processing

* BED files created from ANGSD `dofasta` approach along with Vunguiculata VCF are processed through [VCF_to_ESTSFS.py] to create a estSFS compatible file. This file is then used to predict the ancestral state probabilities with the estSFS tool. The output of this tool is then parsed to create a human readable file using the [ESTSFS_to_ancestral.py] tool. 

## estSFS Models confidence 
* Three parameter models were used Jukes-Cantor, Kumura, Rate6 when estimating the ancestrial state. Of the models Rate6 provided the highest confidence of the ancestrial state of the three. 

| Parameter        | Confidence > 80% |
|------------------|-------------------|
| Jukes & Cantor   | 11,582 SNPs       |
| Kimura           | 11,661 SNPs       |
| Rate6            | 16,242 SNPs       |


[1]: https://github.com/ChaochihL/Barley_Outgroups/tree/master/morex_v3
[2]: Keightley PD, Jackson BC (2018) Inferring the probability of the derived vs. the ancestral allelic state at a polymorphic site. Genetics 209: 897-906. doi:10.1534/genetics.118.301120
[3]: https://github.com/MorrellLAB/File_Conversions/blob/master/VCF_to_ESTSFS.py
[4]: https://github.com/MorrellLAB/File_Conversions/blob/master/ESTSFS_to_ancestral.py
[5]: Naito K, Wakatake T, Shibata TF, Iseki K, Shigenobu S, Takahashi Y, Ogiso-Tanaka E, Muto C, Teruya K, Shiroma A, Shimoji M, Satou K, Hirano T, Nagano AJ, Tomooka N, Hasebe M, Fukushima K, Sakai H (2022) Genome sequence of 12 Vigna species as a knowledge base of stress tolerance and resistance. bioRxiv 8. doi:10.1101/2022.03.28.486085
[6]: Takahashi Y, Somta P, Muto C, Iseki K, Naito K, Pandiyan M, Natesan S, Tomooka N (2016) Novel Genetic Resources in the Genus Vigna Unveiled from Gene Bank Accessions. PLoS One 11: e0147568. doi:10.1371/journal.pone.0147568