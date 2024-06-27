#    Computational task "checkout"

##    Individual biocomputing task specifics

###    Person(s) to contact
*    Roland Akakpo, Peter Morrell

###    Student most closely related to task
*    Jacob Pacheco

###    Task Title
*   VEP analysis in cowpea

###    Project Name
*    [GitHub](https://github.com/MorrellLAB/cowpea_environmental) 

###     Primary Goal
*    To determine the coverage of non core and core genes in the 37 cowpea lines
*    Identify the effect variation in "noncore" genes compared to core genes and their impact for adaptive phenotypes in cowpea

###    Notes on analysis
*    `bctools view` will allow you to subset the VCF. You can list samples after the `-s` options. Be sure to use the `-U` or `--exclude-uncalled` option. Each of the "treatment groups" is listed in this [file](https://github.com/MorrellLAB/usda_brag/blob/master/01_analysis/Soybean_120_sample_list.md) on GitHub.

###    Data Sources
*    The 37 cowpea line BAM file and index are here:
*    `/panfs/jay/groups/9/morrellp/shared/Projects/Cowpea_Diversity/SAM_Processing`
*    Cowpea core and non core genes bed file are here:
*    https://drive.google.com/drive/folders/1aa7Kv27wxVfIOD_EhNvjbVXE7GoFKjxH

###    Reference Genome
*     `/panfs/jay/groups/9/morrellp/shared/References/Reference_Sequences/Cowpea/Vunguiculata_540_v1.0.fa`

###    Reference Annotation
*     Not applicable

###    Scripts for analysis
*    A template script is available at the path below or at this [link](https://github.com/pmorrell/Utilities/blob/master/mosdepth.sh)
*    '/panfs/roc/groups/9/morrellp/pmorrell/Apps/PMorrell/Utilities/mosdepth.sh'

###    Output directory
*    `/panfs/jay/groups/9/morrellp/shared/Projects/Cowpea_Diversity/`

###    Results files needed
*     BED file of coverage
