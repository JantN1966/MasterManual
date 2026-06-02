## 1. Genetic similarity among individuals

**Two individuals that have an ancestor in common are more similar than two unrelated individuals. This genetic similarity can be specified in various ways. This chapter describes the recommended methods in MiXBLUP to specify genetic similarity.**

Chapter 5.1 describes the format of pedigree information that is used to build A-1. If only a pedigree is available, !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF will calculate the expected genetic relationships between individuals as they appear in the inverse pedigree relationship matrix (A-1), without the need to specify this matrix explicitly (chapter 5.3). 
Chapter 5.2 describes the recommended format of genomic data. If all or part of the individuals were genotyped for many genetic markers, such as SNPs, !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF can be used to estimate true genetic similarity from genomic data (chapter 5.4). One method is to calculate the estimated true genetic relationships in a genomic relationship matrix. This inverse genomic relationship matrix can be used on its own if no pedigree information is available (chapter 5.4.1.1). It can also be combined with pedigree information to analyse genotyped and non-genotyped individuals simultaneously (chapter 5.4.2.1). Pedigree information can also be used if all individuals are genotyped.
An equivalent method to use estimated true genetic relationships implicitly, without the need to construct and invert a genomic relationship matrix, is random regression of all SNPs simultaneously on the data (chapter 5.4.1.2 and 5.4.2.2).
Genetic similarity in case of multiple breeds and crosses can be addressed with breed-specific allele frequencies, breed-specific genetic groups or a fixed effect of breed composition in the model (chapter 5.5)
It can be necessary to provide an existing inverse relationship matrix if, for example, the Henderson rules to calculate the inverse pedigree relationship matrix directly do not apply. !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF will use this matrix to model genetic similarity between individuals (chapter 5.6).
The G(…) function and the !#IF(HPB)hpSNP(…) function!#ELIF(M99)SNP(…) function!#ELSESNP(…) or hpSNP(…) functions!#ENDIF in the MODEL section are used to link genetic similarity to data records (Chapter 7). 

### 1.1 Preparing pedigree data

#### 1.1.1 General

Expected genetic similarity between individuals can be based on observed pedigree relationships. Any individual occurring in the data file, regardless of whether it occurs with a record or as a maternal, paternal or group mate genetic effect (in case of a social interaction model), must be present in the pedigree file. Any individual that does not appear in the data file, but exists as an ancestor in the pedigree file, must also have its own record in the pedigree file.

#### 1.1.1 Recommended file formats

##### 1.1.1.1. Pedigree file

The pedigree file consists of the individual identification code (ID) and the IDs of its sire and dam in the first three columns. The columns must be separated by at least one space. The IDs in the pedigree file must be of same type as the IDs in the data file (either numeric or text). The pedigree file may contain other information in any number of additional columns, as long as the number of columns is the same for all records.
!#IF(HPB)!#ELSECalculating reliabilities requires a block variable to be present in the pedigree file (see Chapter 9). In that case the pedigree file, as well as the data file, will be sorted on the block variable. If a block group variable is added to the pedigree, it must be marked with the qualifier !BLOCK. It does not have to be in the fourth column, as in older versions of MiXBLUP. The pedigree file does not need to be sorted. MiXBLUP takes care of any required sorting.!#ENDIF

![](https://raw.githubusercontent.com/JantN1966/MasterManual/main/Images/GenSim01.jpg)\

_Example_. Pedigree file with a single code for unknown parents/
 
##### 1.1.1.1. Pedigree inbreeding coefficient file

A file with previously calculated pedigree inbreeding coefficients can be any free-format text file with any number of columns, as long as it contains the ID of each individual in the analysis and its inbreeding coefficient. This may be the pedigree file with an additional column of inbreeding coefficients.

![](https://raw.githubusercontent.com/JantN1966/MasterManual/main/Images/GenSim02.jpg)\

_Example_. File with inbreeding coefficients
 
#### 1.1.1. Pedigree inbreeding coefficients

##### 1.1.1.1. General

Inbreeding coefficients are often ignored in breeding value estimation using pedigree relationships only. The internally calculated numerator relationship matrix (A-1) is by default set up without taking into account inbreeding. Inbreeding can be included by providing the kernel with a file with the inbreeding coefficient of each individual in the pedigree file. This file may be provided as an existing input file or calculated within !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF as a preparation step. 
Note that inbreeding coefficients do not affect the reliability calculation and will be ignored.

##### 1.1.1.1. Syntax of calculating inbreeding coefficients
>PEDFILE \<pedigree file\> [!CALCINBR \<method\>]\
>\<field animal\> \<field type\>\
>\<field sire\> \<field type\>\
>\<field dam\> \<field type\>

Qualifier:
**!CALCINBR \<method\>**\
The qualifier CALCINBR is optional and is used to indicate that inbreeding coefficients should be calculated and included in the calculation of the inverse pedigree relationship matrix (A-1). If !CALCINBR has been specified, the section INBRFILE is ignored. 
If neither !CALCINBR, nor INBRFILE is specified for a genetic evaluation for which only pedigree information is available, then inbreeding coefficients are not included in the inverse pedigree relationship matrix. For genomic evaluations, however, the default setting is different for the two solvers. For the MiX99 solver, the default is that inbreeding coefficients are not taken into account if it is not specified to include them. For the hpblup solver, the default is to always calculate inbreeding coefficients if pedigree information is available for the evaluation.
There are two methods available to calculate inbreeding coefficients. The default method is published by Sargolzaei et al. (2005) and can be specified as !CalcInbr or !CalcInbr S[argolzaei]. The alternative method is published by Meuwissen and Luo (1992) and can be specified as !CalcInbr M[euwissen]. Which algorithm is fastest, depends on the structure of the pedigree.

##### 1.1.1.1. Syntax of using file with inbreeding coefficients
>INBRFILE \<inbreeding coefficient file \> [!IDCOL \<field number\>] [!INBRCOL \<field number\>]

Qualifier:
**!IDCOL <value>**\
The optional qualifier !IDCOL can be used to specify the field number in the inbreeding coefficient file that contains the animal ID. The default field number is 1.
**!INBRCOL <value>**\
The optional qualifier !INBRCOL can be used to specify the field number in the inbreeding coefficient file that contains the inbreeding coefficient. The default field number is 4.

#### 1.1.1. Pedigree base populations

##### 1.1.1.1. Unknown parents are from a single large base population

It is inevitable that for at least some individuals in the pedigree, the parents are unknown. If it is reasonable to assume that these unknown parents come from the same large population, they should be coded with a zero (0). 

##### 1.1.1.1. Unknown parents are from multiple large base populations

For pedigrees with unknown parents from various known origins, or many individuals without known parents across generations, it may be desirable to specify that some individuals with unknown parents are more similar than average. For example, in case of genetic selection, two individuals born in the same year are more similar than two individuals born in different years. In case of a large difference in selection differential between males and females, it may be useful to distinguish males and females born in the same year. In case of mixed-breed or mixed-line evaluations, it may be useful to group individuals by breed, line or type of cross. This can be done by assigning individuals with one or two unknown parents to an appropriate genetic (or phantom parent) group.\
Genetic groups can be included in the analysis in two ways: (1) Westell grouping and (2) genetic group covariates. Westell grouping augments the pedigree relationship matrix with the number of genetic groups. For genetic group covariates, a covariate matrix Q is set up that contains the proportion of each genetic group for each animal. For both methods, the genetic solutions include the genetic group effect.\
In the pedigree file, the genetic group of the individual is entered on the position of the unknown parent. Genetic groups must be coded as negative integers, but do not have to be sequentially numbered.\
Genetic groups can be modelled either as fixed, pseudo-random (Westell grouping) or random effects. For Westell grouping, the specified value will be added to the diagonal elements of the genetic group effects in the inverse coefficient matrix. If a value of zero is added, genetic group effects are modelled as fixed effects. For values larger than zero, genetic groups are modelled as pseudo-random effects. The larger the value, the more estimates are regressed towards the mean. For genetic group covariates, a variance component can be specified for each genetic group covariate separately or one for all genetic group covariates. It is also possible to fit the covariates as fixed effects.

![](https://raw.githubusercontent.com/JantN1966/MasterManual/main/Images/GenSim03.jpg)\

_Example_. Pedigree file with genetic groups for unknown parents
 
###### 1.1.1.1.1. Syntax of multiple large base populations using Westell grouping
>PEDFILE \<pedigree file\> [!GROUPS \<value\>]\
>\<field animal\> \<field type\>\
>\<field sire\> \<field type\>\
>\<field dam\> \<field type\>

Qualifier:

**!Groups \<value\>**
The qualifier GROUPS means that genetic groups are included in the pedigree. Genetic groups need to be coded with negative integer values. With <value>, it is possible to specify whether these Genetic group effects should be modelled as fixed (value = 0.0) or as random (value > 0.0). In practice, !GROUPS does not need to be set at a much higher value than about 3.

###### 1.1.1.1.1. Associated output files for Westell grouping

| Output file | Description |
| --- | --- |
|Solani.txt | Solutions of the direct genetic effect including the genetic group effects |
|  | when the field type of the ID is integer|
|Solani.out | Solutions of the direct genetic effect including the genetic group effects |
|  | when the field type of the ID is alphanumerical|
|Relani.txt | Approximate reliabilities when the field type of the ID is integer|
|Relani.out | Approximate reliabilities when the field type of the ID is alphanumerical|

###### 1.1.1.1.1. Syntax of multiple large base populations using genetic group covariates
>PEDFILE \<pedigree file\> !MAKEGGCOV\
>\<field animal\> \<field type\>\
>\<field sire\> \<field type\>\
>\<field dam\> \<field type\>\
REGFILE\
\<field animal\> \<field type I or A\>\
REG01 !GGCOV !REGTYPE F/R/H\
[REGPARFILE]\
[REG01 \<file name REG01\>]\
MODEL\
\<trait\> ~ \<fixed effects\> !RANDOM REG(1) \<other random effects\>

Qualifier:
**!MakeGGcov**\
The qualifier !MakeGGcov triggers !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF to set up a covariate matrix Q of the number of genetic groups by the number of individuals in the analysis. The covariates are stored in a standard covariate file.

**!GGcov**\
The qualifier !GGcov specifies which external covariate file contains genetic group covariates. If !MakeGGcov is specified, there is no need to specify a file name for the covariate file with !GGcov

!#IF(HPB)**hpReg(...)**\
The hpReg function can be used to fit a genetic group covariate file in the model of a trait. Note that a genetic group covariate file fitted through hpReg(...) is only fitted for the traits for which it is in the model. The hpReg function has two parameters. The first one is the label number of the covariate file in the REGFILE section. The second parameter is the field name in the data file of the index of the covariate file.

!#ELIF(M99)**REG(...)**\
The REG function can be used to fit a genetic group covariate file in the model of a trait. If the genetic group covariate file is fitted for any trait through REG(...), the covariates will be fitted for all traits, even the ones for which REG(...) is not specified.
The numbers in the REG(...) function link to the number in the label of the general covariate file in the REGFILE section (and the REGPARFILE section). The numbers may be specified individually as (1, 2, 3, 4) or as a range, indicated by two subsequent full stops, for example (1..4), or a combination of both. The index is the individual’s ID in the data file.

!#ELSE**REG(...) or hpReg(...)**\
When using the MiX99 solver, the REG function can be used to fit a genetic group covariate file in the model of a trait. If the genetic group covariate file is fitted for any trait through REG(...), the covariates will be fitted for all traits, even the ones for which REG(...) is not specified.
The numbers in the REG(...) function link to the number in the label of the general covariate file in the REGFILE section (and the REGPARFILE section). The numbers may be specified individually as (1, 2, 3, 4) or as a range, indicated by two subsequent full stops, for example (1..4), or a combination of both. The index is the individual’s ID in the data file.
When using the hpblup solver, the hpReg function can be used to fit a genetic group covariate file in the model of a trait. Note that a genetic group covariate file fitted through hpReg(...) is only fitted for the traits for which it is in the model.
The hpReg function has two parameters. The first one is the label number of the covariate file in the REGFILE section. The second parameter is the field name in the data file of the index of the covariate file.

!#ENDIF
###### 1.1.1.1.1. Associated output files for genetic group covariates

| Output file | Description |
| --- | --- |
|Solani.txt |  Solutions of the direct genetic effect when the field type of the ID is integer|
|SolaniGG.txt | Solutions of the accumulated genetic group effects for each individual|
|Solanitot.txt | Solutions of the direct genetic effect including the genetic group effects |
|  | when the field type of the ID is integer|
|GeneticGroupsInQ.txt | Original genetic group label by column in the covariate file|
|Solani.out | Solutions of the direct genetic effect when the field type of the ID is alphanumerical|
|Solreg_mat.txt | Solutions of genetic group covariates, along with solutions |
|  | of any other external covariates|
|SolaniGG.out | Solutions of the accumulated genetic group effects for each individual|
|Solanitot.out | Solutions of the direct genetic effect including the genetic group effects |
|  | when the field type of the ID is alphanumerical|
|Relani.txt | Approximate reliabilities when the field type of the ID is integer|
|Relani.out | Approximate reliabilities when the field type of the ID is alphanumerical|

##### 1.1.1.1. Unknown parents are from multiple related base populations (metafounders)

If individuals without known parents originate from multiple base populations, it may be reasonable to assume that these base populations are not unrelated. Information on average relationships within and between base populations may come from genotyped descendants of the unknown parents or from discarded pedigree information. Related base populations are generally referred to as metafounders.
Average genetic relationships within and between metafounders are presented to the solver in an inverse gamma matrix. In case of relationships because of discarded pedigree and/or genotype information, the user needs to calculate the gamma matrix prior to the evaluation and specify the name of the matrix. If the relationships are entirely based on genotypes included in the evaluation, then !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF can also calculate the gamma matrix.
Metafounders are presented in the pedigree file in the same way as genetic groups, i.e. as negative integers.
The file with the gamma matrix should be a text file in I-J-Value format, i.e. metafounder ID of row, metafounder ID of column, average genetic relationship. Only non-zero genetic relationships of the lower triangular part of the matrix need to be specified.

###### 1.1.1.1.1. Syntax of multiple related base populations using metafounders
>PEDFILE \<pedigree file\> !Metafounders\
>\<field animal\> \<field type\>\
>\<field sire\> \<field type\>\
>\<field dam\> \<field type\>

Qualifier:\
**!Metafounders** \
or\
**!Metafounders \<file with gamma matrix\>**\
This qualifier indicates that base populations in the pedigree are related. If a file with the gamma matrix is specified, the gamma matrix is coded for either the default or the hpblup solver. If a file with the gamma matrix is not specified, the gamma matrix with genomic relationships within and between metafounders is estimated from available genomic information. Metafounders are fitted using this gamma matrix with coded IDs, and QP transformation.

###### 1.1.1.1.1. Associated output files for metafounders

| Output file | Description |
| --- | --- |
|Solani.txt | Solutions of the direct genetic effect when the field type of the ID is integer|
|Solani.out | Solutions of the direct genetic effect when the field type of the ID is alphanumerical|
|Relani.txt | (Weighted) inverse genomic relationship matrix|
|Relani.out | Approximate reliabilities when the field type of the ID is integer|
|ExtRelMat_tri.txt | Weighted inverse genomic relationship matrix|
|gamma.dat | gamma matrix with relationships within and across metafounders|

### 1.1 Preparing genomic data

#### 1.1.1 General

Genomic data can be used to estimate true genetic similarity between individuals. Genomic data consists of a large number of bi-allelic SNP markers.

#### 1.1.1 Recommended file formats

##### 1.1.1.1 Genomic data

It is recommended to provide genomic data as genotypes, which is the count of one of the two alleles. This may be provided as a space-separated or dense text file or in binary format.

![](https://raw.githubusercontent.com/JantN1966/MasterManual/main/Images/GenSim04.jpg)\

_Example_. Genotype file with marker genotype data per animal in dense format. It contains the number of copies per locus of the allele with the highest number (11=0, 12=1 and 22=2).
 
The recommended way to provide genomic data is binary plink format. It consists of three files. The **.bim** file contains the SNP marker details in text format, the **.fam** file contains details of genotyped individuals in text format and the **.bed** file contains the genotype of each individual for each SNP marker in compressed binary format.
For GBLUP and single-step GBLUP, genomic data may be also provided as alleles, either using pairs of alleles on a single record per individual or splitting pairs of alleles onto two records per individual. This may be useful for using multi-allele loci. See appendix \<Genomic data files\> for details.

##### 1.1.1.1 Allele frequencies

If the user does not want to use allele frequencies calculated from the data, then pre-calculated allele frequencies can be supplied as an additional input file, The file specified should contain for each locus the allele frequency of the allele with the highest integer code, if the genetic marker file contains alleles. The file specified should contain for each locus the frequency of the allele of which the homozygote genotypes are coded as 2. The structure of the file is \<locus number in order of the genetic marker file\> \<allele frequency\>.
Pre-calculated allele frequencies are supported for GBLUP, single-step GBLUP, SNPBLUP and single-step SNPBLUP. 

![](https://raw.githubusercontent.com/JantN1966/MasterManual/main/Images/GenSim08.jpg)\

_Example_. Pre-calculated allele frequency per locus of allele coded with the highest integer code for 6 loci
 
### 1.1. Genetic similarity from pedigree only

#### 1.1.1. General

!#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF supports analyses using a pedigree that consists of individuals and their parents (animal model). A sire model with sires and maternal grandsires in the pedigree file is currently not supported in !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF.

#### 1.1.1. Syntax of using pedigree BLUP
>PEDFILE \<pedigree file\> [!SKIP \<n lines\>]\
>\<field animal\> \<field type\>\
>\<field sire\> \<field type\>\
>\<field dam\> \<field type\>!#IF(HPB)!#ELSE\
>[\<field block variable\> \<field type\> !BLOCK]!#ENDIF

Qualifiers:\
**!SKIP <n lines>**\
The SKIP qualifier may be used to skip the first n lines of the pedigree file. This is useful for ignoring a header.

IF(HPB)!#ELSE**!BLOCK**\
The BLOCK qualifier specifies the field that contains the equation family block variable (Chapter 9) in case of a reliability calculation. The block variable does not have to be in the fourth column.!#ENDIF

### 1.1. Genetic similarity from genomic data

#### 1.1.1. Genetic similarity from genomic data with unknown pedigree

##### 1.1.1.1 General

In an evaluation with genomic data only, all individuals are genotyped. Genomic data can be used to calculate a genomic relationship matrix. The inverse of this matrix is used to include genetic similarity between individuals. A range of inverse genomic relationship matrix files can be created by !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF to be incorporated in the evaluation (chapter 5.4.1.1). The marker effect solutions can be estimated afterwards (chapter 5.4.3).

An alternative method to estimate genomic breeding values is to model the direct genetic effect with a random regression on number of copies of a SNP allele for a large number of loci (chapter 5.4.1.2). Direct genomic values for genotyped individuals without data can be estimated afterwards from the marker effect solutions.

##### 1.1.1.1 Syntax of using GBLUP
>ERMFILE \<Name file with genetic markers\> !CONSTRUCT Ginv\
>\<animal ID\> \<field type\>\
>!METHOD \<Yang, VanRaden or VanRaden2\> (optional; default VanRaden2)\
>!ALFREQ \<file name\> (optional; default calculated from data)\
>!CROSSBRED \<number of breeds\> \<file name\> (optional; default single breed)\
>!INFORMATIVE (optional; default is to use all SNPs)\
>!DENSE \<field number\> (optional; default string of markers in free format, field number is column with dense genotypes)\
>!MAF \<minimum allele frequency\> (optional; default is 0.005)\
>!NUMPROC \<number of processors to be used by calc_grm\> (optional; default is 1)\
>!SKIP \<n lines\> (optional; default is reading all lines)\
>!GFROMDISK (optional; default is to store relationship matrix in memory during solving)

Qualifiers:\
**!CONSTRUCT Ginv**\
The !CONSTRUCT qualifier is optional and indicates that the external relationship matrix has not been calculated yet and needs to be calculated in the MiXBLUP parser. For a GBLUP analysis, the argument of !CONSTRUCT is Ginv, for an inverse genomic relationship matrix.

**!METHOD \<Yang, VanRaden or VanRaden2\>**\
The !METHOD qualifier is optional and specifies whether the method of Yang (Nat Genet 42:565-569) or the method of VanRaden (J Dairy Sci 91: 4414-4423) is used. The VanRaden2 method is the default.

**!ALFREQ \<file name\>**\
The !ALFREQ qualifier is optional and allows the use of pre-defined allele frequencies per locus from the file specified. By default, the base population allele frequencies are calculated from the data.

**!CROSSBRED \<number of breeds\> \<name file with breed composition per animal\>**\
The !CROSSBRED qualifier is optional and can be used for multi-breed analyses that may or may not include crossbred animals. There are two arguments. The one argument is the number of pure breeds in the analysis. The other argument is the name of the file with the breed composition of the animals in the genetic marker file. The !CROSSBRED option will consider relationships between all animals, regardless of their breed composition, using for each animal allele frequencies that are specific for their breed composition.

**!INFORMATIVE**\
The !INFORMATIVE qualifier is used to include only genetic markers with all three genotypes present in the population of genotyped individuals. The default is to include all genetic markers with more than just one allele in the data.

**!DENSE [\<field number of dense column\>]**\
The !DENSE qualifier must be specified if the genetic marker data is presented as a sequence of genetic markers without spaces. If the dense column is not the second field in the record, the field number of the dense column needs to be specified after the qualifier, for example !DENSE 4. If !DENSE is not specified for a file with dense genetic marker data, !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF will give a column-width error, as it attempts to read the dense genetic markers as a single column. By default, !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF expects space-separated genetic markers.

**!MAF <minimum allele frequency>**\
The qualifier !MAF is optional and is used to set the minimum allele frequency of genetic markers to be included in the analysis. The default value is 0.005. Use !MAF 0.0 to include all SNP with more than one allele in the data.

**!NUMPROC**\
The !NUMPROC qualifier can be used to specify the number of threads to be used by calc_grm.

!#IF(HPB)!#ELSE**!GFROMDISK**\
The !GFROMDISK qualifier instructs the solver to read the inverse genomic relationship matrix from disk during solving. This was the only option in previous versions of MiXBLUP. The default is to keep this matrix in memory, which is more demanding for memory requirement, but it saves the time to read this matrix every iteration. It is specified in the SOLVING section of the MiXBLUP instruction file.!#ENDIF

##### 1.1.1.1. Syntax of using SNPBLUP

!#IF(MiX)###### 1.1.1.1.1. Syntax for the MiX99 solver
>SNPFILE [!CENTER] [!NOIMPUTE] [!MISSCOMB 0.01] [!MISSPERLOC 0.01] [!NOPRUNE] [!CALCSNPVAR] [!MINGENFREQ] [!GBSORTSNP <memory allocation in Gb>] [!SAMEORDER]\
>\<field animal\> \<field type I or A\>\
>SNP01 \<file name SNP01\> !REGTYPE R [!IDCOL \<n\>] [!STARTCOV \<n\>] [!LASTCOV \<n\>]\
>SNP02 \<file name SNP02\> !REGTYPE R [!IDCOL \<n\>] [!STARTCOV \<n\>] [!LASTCOV \<n\>]\
>\<...\>\
>SNP99 \<file name SNP99\> !REGTYPE R [!IDCOL \<n\>] [!STARTCOV \<n\>] [!LASTCOV \<n\>]\
>[SNPPARFILE  (required only for !REGTYPE H or for !REGTYPE R if !CALCSNPVAR is not specified)\
>SNP01 \<file name SNP01\>\
>SNP02 \<file name SNP02\>\
>\<...\>\
>SNP99 \<file name SNP99\>]\
>MODEL\
>\<trait\> ~ \<fixed\> !RANDOM SNP(1,2,8..15,23) # so no need for G(...) in the model

Sections:\
**SNPFILE**\
The SNPFILE section specifies the name of one or more SNP covariate files and its attributes, such as column numbers, dense or space-separated SNPs and whether one variance for all SNPs is used or an individual variance for each SNP. The section also has a number of qualifiers that apply to all SNP covariate files.

**SNPPARFILE**\
The SNPPARFILE section specifies the name of a parameter file for each SNP covariate file for which the SNP covariates are fitted as a random regression (so !REGTYPE is either ‘r’ or ‘h’). The SNPPARFILE section does not have any associated qualifiers. The lines of the SNPPARFILE section each contain two columns. The first column is the label that links the parameter file to the SNP covariate file. The second column is the name of the file.

Qualifiers:\
The file-independent qualifiers of SNPFILE are typically specified on the first line of the SNPFILE section. These are:\
**!CENTER**\
The !CENTER qualifier is optional and scales all SNP’s to a mean of 0 and standard deviation of 1. For details, see Stranden and Christensen (2011). Centring the SNPs affects the fixed effect solutions, but not the SNP effect solutions. Centering may enhance convergence of the PCG iteration.

**!MISSCOMB \<maximum fraction of SNPs missing\>**\
The MISSCOMB qualifier is optional and can be used to specify the tolerance level of missing combinations of animal and SNP. Above the tolerance level, a warning is printed that the analysis may not yield meaningful results, but the analysis continues. If !MISSCOMB is not specified, the tolerance level is 0.001 of all combinations of animal and SNP marker.

**!MISSPERLOC \<maximum fraction of SNPs missing per locus\>**\
The MISSPERLOC qualifier is optional. It specifies the tolerance level of missing SNPs per locus. Loci with too many missing SNPs are written to CheckDataSNP.log and a warning is printed. If !MISSPERLOC is not specified, the tolerance level is 0.05 of all genotypes for the locus (call rate of 95%).

**!NOIMPUTE**\
The !NOIMPUTE qualifier can be used to avoid automatic imputation of missing SNPs with the average SNP value of the locus. If !NOIMPUTE is specified, then animals with one or more missing SNPs get a genomic breeding value of -99999 in the solanigen.txt file. If !NOIMPUTE is not specified, then the average SNP value of the locus is used in the calculation of the genomic breeding value.

**!NOCHECK**\
The !NOCHECK qualifier can be used omit any imputing, pruning, centring or checks of SNP covariates, which must be on the scale 0 to 2.

**!NOPRUNE**\
The !NOPRUNE qualifier can be used omit the verification that all SNPs are informative and the exclusion of non- or less-informative SNPs.

**!MINGENFREQ**\
The !MINGENFREQ qualifier is optional and can be used to vary the definition of a less-informative SNP. If the frequency of the minor SNP genotype is below the threshold, it is considered to be less-informative and it will be excluded from the analysis, unless !NOPRUNE has been specified. The default threshold is 0, which does not remove any SNP markers.

**!CALCSNPVAR**\
The optional !CALCSNPVAR qualifier can be used to calculate the SNP variance from the direct genetic variance in the parameter file specified in the PARFILE section. The CALCSNPVAR qualifier must not be specified if one or more SNP files have SNP-specific variances (!REGTYPE H). If one or more SNP files are fixed (!REGTYPE F), the SNP variance is calculated using the remaining SNP files with !REGTYPE R. When !CALCSNPVAR is specified, the SNPPARFILE section is ignored.

**!GBSORTSNP \<amount of memory in Gb\>**\
The qualifier !GbSortSNP only applies to the MiX99 solver. It is optional and can be used to control the use of memory for sorting SNP covariate records in the order of the data file. SNP covariate records are sorted in blocks of records. !GBSORTSNP determines the size of such a block of records to be sorted simultaneously. The default allocation is 16 Gb. The number of blocks of records is the number of times a SNP covariate file has to be read, so a small memory allocation increase the time needed to sort the SNP covariates.

**!SAMEORDER**\
The qualifier !SameOrder only applies to the MiX99 solver. If there are multiple SNP covariate files and records in each file are in the same order of individual ID, then !SAMEORDER can be used. MiXBLUP will sort all SNP covariate files simultaneously. Note that memory allocated with !GBSORTSNP is now used for multiple SNP covariate files instead of a single file. 

The second line of the SNPFILE section specifies the animal ID code that can be used to link the data and the SNP covariate files.\
The following lines each specify a SNP covariate file. Each line starts with a label. The label links the SNP covariate file to the corresponding SNP parameter file. The label must have the form ‘SNPxx’ where xx is a number between 01 and 99. The second field contains the name of the SNP covariate file. The additional fields contain one or more file-specific qualifiers. These are:

**!REGTYPE**\
The file-specification line must contain the !REGTYPE qualifier. It specifies how the covariates in the file are fitted in the model. If ‘f’ is specified, the covariates in the file are fitted as a fixed regression. Covariates fitted as a fixed effect do not have a variance associated with it, so it is not necessary to specify a parameter file in the SNPPARFILE section. If it is present, it is ignored. If ‘r’ is specified, the covariates in the file are fitted as a random regression with a single variance for all covariates in the file. The variance is specified in the corresponding parameter file in the SNPPARFILE section. If ‘h’ is specified, the covariates in the file are fitted as a random regression, each with their own variance. The covariate-specific variances are specified in the corresponding parameter file in the SNPPARFILE section.

**!IDCOL**\
The !IDCOL qualifier is optional and specifies which field in the SNP covariate file contains the ID of the genotyped animal. If it is omitted, it is assumed that the ID is in the first field of the record (so the default is !IDCOL 1).

**!STARTCOV**\
The !STARTCOV qualifier is optional and specifies which field contains the first SNP covariate. If it is omitted, it is assumed that the SNP covariates start in the second field of the record (so !STARTCOV 2).

**!LASTCOV**\
The !LASTCOV qualifier only applies to the MiX99 solver. It is optional and specifies which field contains the last SNP covariate of the file to include in the model. If it is omitted, it is assumed that all fields after the first SNP covariate contain SNP covariates to include in the model.

**SNP(...)**\
The SNP function only applies to the MiX99 solver. It can be used in the MODEL section to specify which SNP covariate files should be fitted in the model of a trait. If a SNP covariate file is specified, then all specified SNP covariates in the file will be fitted. The number in the SNP(...) function links to the number in the label of the SNP covariate file. The numbers may be specified individually as (1, 2, 3, 4) or as a range, indicated by two subsequent full stops, for example (1..4), or a combination of both. When SNP(...) is specified, it is not necessary to specify the G(...) function to specify a genetic effect, but it is possible, for example to specify a maternal genetic effect. Despite what the use of SNP(...) in the MODEL section may suggest, all SNP covariate files used in any trait are fitted for all traits.

###### 1.1.1.1.1. Syntax for hpblup solver
>SNPFILE [!CENTER] [!NOIMPUTE] [!MISSCOMB 0.01] [!MISSPERLOC 0.01 [!NOPRUNE] [!CALCSNPVAR] [!MINGENFREQ]\
>\<field animal\> \<field type I or A\>\
>SNP02 \<file name SNP02\> !REGTYPE R [!IDCOL 1] [!STARTCOV 2] [!PLINK]\
>[SNPPARFILE (required only for !REGTYPE H or for !REGTYPE R if !CALCSNPVAR is not specified)\
>SNP02 <file name SNP02>]\
>MODEL\
>\<trait\> ~ \<fixed\> !RANDOM hpSNP(2,\<field animal\>) [hpSNP(2,\<field dam\>)]

Qualifiers:\
Please note: the qualifiers !GbSortSNP, !SameOrder and !LastCov have no effect when using the hpblup solver.

**hpSNP(\<label number\>,\<index field\>)**\
The hpSNP function is used to specify which SNP covariate files should be fitted in the model of a trait. Unlike for the MiX99 solver, the SNP covariate file is not fitted automatically for all traits. The first parameter of the hpSNP function is the number in the label of the SNP covariate file. The second parameter is the index field in the data file. Every combination of label and index field requires a separate hpSNP function in the model of a trait.

!#ELIF(M99)###### 1.1.1.1.1. Syntax for the MiX99 solver
>SNPFILE [!CENTER] [!NOIMPUTE] [!MISSCOMB 0.01] [!MISSPERLOC 0.01] [!NOCHECK] [!NOPRUNE] [!CALCSNPVAR] [!MINGENFREQ] [!GBSORTSNP <memory allocation in Gb>] [!SAMEORDER]\
>\<field animal\> \<field type I or A\>\
>SNP01 \<file name SNP01\> !REGTYPE R [!IDCOL \<n\>] [!STARTCOV \<n\>] [!LASTCOV \<n\>]\
>SNP02 \<file name SNP02\> !REGTYPE R [!IDCOL \<n\>] [!STARTCOV \<n\>] [!LASTCOV \<n\>]\
>\<...\>\
>SNP99 \<file name SNP99\> !REGTYPE R [!IDCOL \<n\>] [!STARTCOV \<n\>] [!LASTCOV \<n\>]\
>[SNPPARFILE  (required only for !REGTYPE H or for !REGTYPE R if !CALCSNPVAR is not specified)\
>SNP01 \<file name SNP01\>\
>SNP02 \<file name SNP02\>\
>\<...\>\
>SNP99 \<file name SNP99\>]\
>MODEL\
>\<trait\> ~ \<fixed\> !RANDOM SNP(1,2,8..15,23) # so no need for G(...) in the model

Sections:\
**SNPFILE**\
The SNPFILE section specifies the name of one or more SNP covariate files and its attributes, such as column numbers, dense or space-separated SNPs and whether one variance for all SNPs is used or an individual variance for each SNP. The section also has a number of qualifiers that apply to all SNP covariate files.

**SNPPARFILE**\
The SNPPARFILE section specifies the name of a parameter file for each SNP covariate file for which the SNP covariates are fitted as a random regression (so !REGTYPE is either ‘r’ or ‘h’). The SNPPARFILE section does not have any associated qualifiers. The lines of the SNPPARFILE section each contain two columns. The first column is the label that links the parameter file to the SNP covariate file. The second column is the name of the file.

Qualifiers:\
The file-independent qualifiers of SNPFILE are typically specified on the first line of the SNPFILE section. These are:\
**!CENTER**\
The !CENTER qualifier is optional and scales all SNP’s to a mean of 0 and standard deviation of 1. For details, see Stranden and Christensen (2011). Centring the SNPs affects the fixed effect solutions, but not the SNP effect solutions. Centering may enhance convergence of the PCG iteration.

**!MISSCOMB \<maximum fraction of SNPs missing\>**\
The MISSCOMB qualifier is optional and can be used to specify the tolerance level of missing combinations of animal and SNP. Above the tolerance level, a warning is printed that the analysis may not yield meaningful results, but the analysis continues. If !MISSCOMB is not specified, the tolerance level is 0.001 of all combinations of animal and SNP marker.

**!MISSPERLOC \<maximum fraction of SNPs missing per locus\>**\
The MISSPERLOC qualifier is optional. It specifies the tolerance level of missing SNPs per locus. Loci with too many missing SNPs are written to CheckDataSNP.log and a warning is printed. If !MISSPERLOC is not specified, the tolerance level is 0.05 of all genotypes for the locus (call rate of 95%).

**!NOIMPUTE**\
The !NOIMPUTE qualifier can be used to avoid automatic imputation of missing SNPs with the average SNP value of the locus. If !NOIMPUTE is specified, then animals with one or more missing SNPs get a genomic breeding value of -99999 in the solanigen.txt file. If !NOIMPUTE is not specified, then the average SNP value of the locus is used in the calculation of the genomic breeding value.

**!NOCHECK**\
The !NOCHECK qualifier can be used omit any imputing, pruning, centring or checks of SNP covariates, which must be on the scale 0 to 2.

**!NOPRUNE**\
The !NOPRUNE qualifier can be used omit the verification that all SNPs are informative and the exclusion of non- or less-informative SNPs.

**!MINGENFREQ**\
The !MINGENFREQ qualifier is optional and can be used to vary the definition of a less-informative SNP. If the frequency of the minor SNP genotype is below the threshold, it is considered to be less-informative and it will be excluded from the analysis, unless !NOPRUNE has been specified. The default threshold is 0, which does not remove any SNP markers.

**!CALCSNPVAR**\
The optional !CALCSNPVAR qualifier can be used to calculate the SNP variance from the direct genetic variance in the parameter file specified in the PARFILE section. The CALCSNPVAR qualifier must not be specified if one or more SNP files have SNP-specific variances (!REGTYPE H). If one or more SNP files are fixed (!REGTYPE F), the SNP variance is calculated using the remaining SNP files with !REGTYPE R. When !CALCSNPVAR is specified, the SNPPARFILE section is ignored.

**!GBSORTSNP \<amount of memory in Gb\>**\
The qualifier !GbSortSNP only applies to the MiX99 solver. It is optional and can be used to control the use of memory for sorting SNP covariate records in the order of the data file. SNP covariate records are sorted in blocks of records. !GBSORTSNP determines the size of such a block of records to be sorted simultaneously. The default allocation is 16 Gb. The number of blocks of records is the number of times a SNP covariate file has to be read, so a small memory allocation increase the time needed to sort the SNP covariates.

**!SAMEORDER**\
The qualifier !SameOrder only applies to the MiX99 solver. If there are multiple SNP covariate files and records in each file are in the same order of individual ID, then !SAMEORDER can be used. MiXBLUP will sort all SNP covariate files simultaneously. Note that memory allocated with !GBSORTSNP is now used for multiple SNP covariate files instead of a single file. 

The second line of the SNPFILE section specifies the animal ID code that can be used to link the data and the SNP covariate files.\
The following lines each specify a SNP covariate file. Each line starts with a label. The label links the SNP covariate file to the corresponding SNP parameter file. The label must have the form ‘SNPxx’ where xx is a number between 01 and 99. The second field contains the name of the SNP covariate file. The additional fields contain one or more file-specific qualifiers. These are:

**!REGTYPE**\
The file-specification line must contain the !REGTYPE qualifier. It specifies how the covariates in the file are fitted in the model. If ‘f’ is specified, the covariates in the file are fitted as a fixed regression. Covariates fitted as a fixed effect do not have a variance associated with it, so it is not necessary to specify a parameter file in the SNPPARFILE section. If it is present, it is ignored. If ‘r’ is specified, the covariates in the file are fitted as a random regression with a single variance for all covariates in the file. The variance is specified in the corresponding parameter file in the SNPPARFILE section. If ‘h’ is specified, the covariates in the file are fitted as a random regression, each with their own variance. The covariate-specific variances are specified in the corresponding parameter file in the SNPPARFILE section.

**!IDCOL**\
The !IDCOL qualifier is optional and specifies which field in the SNP covariate file contains the ID of the genotyped animal. If it is omitted, it is assumed that the ID is in the first field of the record (so the default is !IDCOL 1).

**!STARTCOV**\
The !STARTCOV qualifier is optional and specifies which field contains the first SNP covariate. If it is omitted, it is assumed that the SNP covariates start in the second field of the record (so !STARTCOV 2).

**!LASTCOV**\
The !LASTCOV qualifier only applies to the MiX99 solver. It is optional and specifies which field contains the last SNP covariate of the file to include in the model. If it is omitted, it is assumed that all fields after the first SNP covariate contain SNP covariates to include in the model.

**SNP(...)**\
The SNP function only applies to the MiX99 solver. It can be used in the MODEL section to specify which SNP covariate files should be fitted in the model of a trait. If a SNP covariate file is specified, then all specified SNP covariates in the file will be fitted. The number in the SNP(...) function links to the number in the label of the SNP covariate file. The numbers may be specified individually as (1, 2, 3, 4) or as a range, indicated by two subsequent full stops, for example (1..4), or a combination of both. When SNP(...) is specified, it is not necessary to specify the G(...) function to specify a genetic effect, but it is possible, for example to specify a maternal genetic effect. Despite what the use of SNP(...) in the MODEL section may suggest, all SNP covariate files used in any trait are fitted for all traits.

!#ELSE###### 1.1.1.1.1. Syntax for hpblup solver
>SNPFILE [!CENTER] [!NOIMPUTE] [!MISSCOMB 0.01] [!MISSPERLOC 0.01] [!NOCHECK] [!NOPRUNE] [!CALCSNPVAR] [!MINGENFREQ]\
>\<field animal\> \<field type I or A\>\
>SNP02 \<file name SNP02\> !REGTYPE R [!IDCOL 1] [!STARTCOV 2] [!PLINK]\
>[SNPPARFILE (required only for !REGTYPE H or for !REGTYPE R if !CALCSNPVAR is not specified)\
>SNP02 <file name SNP02>]\
>MODEL\
>\<trait\> ~ \<fixed\> !RANDOM hpSNP(2,\<field animal\>) [hpSNP(2,\<field dam\>)]

Qualifiers:\
Please note: the qualifiers !GbSortSNP, !SameOrder and !LastCov have no effect when using the hpblup solver.

**!CENTER**\
The !CENTER qualifier is optional and scales all SNP’s to a mean of 0 and standard deviation of 1. For details, see Stranden and Christensen (2011). Centring the SNPs affects the fixed effect solutions, but not the SNP effect solutions. Centering may enhance convergence of the PCG iteration.

**!NOIMPUTE**\
The !NOIMPUTE qualifier can be used to avoid automatic imputation of missing SNPs with the average SNP value of the locus. If !NOIMPUTE is specified, then animals with one or more missing SNPs get a genomic breeding value of -99999 in the solanigen.txt file. If !NOIMPUTE is not specified, then the average SNP value of the locus is used in the calculation of the genomic breeding value.

**!MISSCOMB \<maximum fraction of SNPs missing\>**\
The MISSCOMB qualifier is optional and can be used to specify the tolerance level of missing combinations of animal and SNP. Above the tolerance level, a warning is printed that the analysis may not yield meaningful results, but the analysis continues. If !MISSCOMB is not specified, the tolerance level is 0.001 of all combinations of animal and SNP marker.

**!MISSPERLOC \<maximum fraction of SNPs missing per locus\>**\
The MISSPERLOC qualifier is optional. It specifies the tolerance level of missing SNPs per locus. Loci with too many missing SNPs are written to CheckDataSNP.log and a warning is printed. If !MISSPERLOC is not specified, the tolerance level is 0.05 of all genotypes for the locus (call rate of 95%).

**!NOCHECK**\
The !NOCHECK qualifier can be used omit any imputing, pruning, centring or checks of SNP covariates, which must be on the scale 0 to 2.

**!NOPRUNE**\
The !NOPRUNE qualifier can be used omit the verification that all SNPs are informative and the exclusion of non- or less-informative SNPs.

**!CALCSNPVAR**\
The optional !CALCSNPVAR qualifier can be used to calculate the SNP variance from the direct genetic variance in the parameter file specified in the PARFILE section. The CALCSNPVAR qualifier must not be specified if one or more SNP files have SNP-specific variances (!REGTYPE H). If one or more SNP files are fixed (!REGTYPE F), the SNP variance is calculated using the remaining SNP files with !REGTYPE R. When !CALCSNPVAR is specified, the SNPPARFILE section is ignored.

**!MINGENFREQ**\
The !MINGENFREQ qualifier is optional and can be used to vary the definition of a less-informative SNP. If the frequency of the minor SNP genotype is below the threshold, it is considered to be less-informative and it will be excluded from the analysis, unless !NOPRUNE has been specified. The default threshold is 0, which does not remove any SNP markers.

**hpSNP(\<label number\>,\<index field\>)**\
The hpSNP function is used to specify which SNP covariate files should be fitted in the model of a trait. Unlike for the MiX99 solver, the SNP covariate file is not fitted automatically for all traits. The first parameter of the hpSNP function is the number in the label of the SNP covariate file. The second parameter is the index field in the data file. Every combination of label and index field requires a separate hpSNP function in the model of a trait.!#ENDIF

### 1.1. Genetic similarity from pedigree and genomic data

#### 1.1.1. General

If pedigree data is available or if some individuals are not genotyped, a single-step genomic BLUP model can be used. !#IF(M99)In this approach!#ELSEThere are three approaches. In the first approach!#ENDIF, an inverse genomic relationship matrix is used (ssGBLUP), either explicitly or implicitly in decomposed form. The inverse genomic and pedigree relation matrices are blended. There are various ways to do this (Appendix 3). If the number of genotyped individuals is below 40,000, it is recommended to use the full inverse of weighted G (chapter 5.4.2.2). If the number of genotyped individuals is higher, it is recommended to use the !#IF(M99)component-wise Ta decomposition of G (ssGTacBLUP; chapter 5.4.2.3)!#ELSEAPY-inverse of G!#ENDIF. 
!#IF(M99)!#ELSEThe second approach is mathematically equivalent to ssGBLUP and fits every SNP marker as a covariate. The method implemented in MiXBLUP was developed by Liu et al. (2014) and contains SNP covariates and a residual polygenic effect. A genomic estimated breeding value (GEBV) is calculated for all individuals, which is the sum of the direct genomic value, calculated from the SNP effects, and the residual polygenic breeding value. This method is called single-step SNP BLUP (ssSNPBLUP; chapter 5.4.2.4).
If the number of animals with both a phenotype and a genotype is sufficiently large for all traits, then SNP effect estimates are quite stable for a number of subsequent evaluations. The third approach uses previously estimated SNP effects to calculate direct genomic values (DGV) for genotyped animals. These DGV are fitted as prior information in a pedigree BLUP evaluation (DGV-PBLUP; chapter 5.4.2.5 and 5.4.2.6). DGV-PBLUP can be used with ssGTacBLUP and ssSNPBLUP. A full genomic evaluation is needed periodically to re-estimate SNP effects. DGV-PBLUP provides a substantial reduction in runtime and computing resources. The number of subsequent evaluations for which DGV-PBLUP can be used, depends on multiple factors, such as the size of the phenotype and genotype datasets. !#ENDIF!#IF(MiX)DGV-PBLUP is only available for the hpblup solver.!#ENDIF

#### 1.1.1. Syntax of SSGBLUP: single-step genomic BLUP with full inverse of a weighted G
>ERMFILE \<Name file with genetic markers\> !CONSTRUCT SSmat\
>\<animal ID\> \<field type\>
>!LAMBDA \<weighting factor G matrix, 0.0-1.0\> (optional; default 1.0)\
>!ALPHA \<weighting factor, 0.0-1.0\> (optional; default is 0.95)\
>!BETA \<weighting factor, 0.0-1.0\> (optional; default is 1.0-ALPHA)\
>!OMEGA \<weighting factor, 0.0-1.0\> (optional; default is LAMBDA)\
>!SINGLESTEP\
>[INBRFILE \<inbreeding coefficient file\> !IDCOL \<number\> !INBRCOL\ <number\>]\
>PEDFILE \<pedigree file\> [!CALCINBR]\
>\<individual ID\> \<field type\>\
>\<sire ID\> \<field type\>\
>\<dam ID\> \<field type\>

Any qualifier of ERMFILE described in chapter 5.4.1.1 can also be used for a weighted inverse genomic relationship matrix. Specific qualifiers:

**!CONSTRUCT SSmat**\
The !CONSTRUCT qualifier indicates that the external relationship matrix has not been calculated yet and needs to be calculated in the MiXBLUP parser. For a ssGBLUP analysis with a weighted inverse genomic relationship matrix, the argument of !CONSTRUCT is SSmat.

**!LAMBDA <weighting factor of inverse of weighted G-matrix>**\
**!ALPHA <weighting factor of G-matrix>**\
**!BETA <weighting factor of A22-matrix>**\
**!OMEGA <weighting factor of inverse of A22-matrix>**\
The !LAMBDA, !ALPHA, !BETA and !OMEGA qualifiers are the fudge parameters suggested by Misztal and coworkers. They are optional and can be used to give more weight to numerator relationship matrix (A-1) in the construction of the blended matrix (H-1):

![](https://raw.githubusercontent.com/JantN1966/MasterManual/main/Images/GenSim04.jpg)\

By default, lambda is set to 1, omega to lambda, alpha to 0.95 and beta to 0.05.

**!SINGLESTEP**\
The qualifier !SINGLESTEP is used to indicate that the MiXBLUP kernel should calculate elements of the H-inverse from a G-inverse, the pedigree file and a file with inbreeding coefficients (see 4.9.3). This option requires a matrix that is set up using !CONSTRUCT with argument SSmat.

!#IF(M99)
#### 1.1.1 Using APY to invert genomic relationship matrix 

##### 1.1.1.1 General 

The use of an inverse genomic relationship matrix requires inverting a matrix with dimensions equal to the number of genotyped individuals. For numbers of genotyped animals exceeding 50,000 to 100,000, this becomes quite a computational burden. The so-called algorithm for proven and young animals (APY) uses genomic recursions to calculate an approximate inverse of the genomic relationship matrix (Fragomeni et al., 2015).
For APY, the genotyped animals are divided into core and non-core animals. A target number of core animals can be the number of eigenvalues that explain at least 98% of the variation. This number of core animals can be chosen at random or supplied in a pre-defined list of core animals. Only the genomic relationship matrix of core animals needs to be inverted. The parts of the inverse genomic relationship matrix that relates to non-core animals are set up using genomic recursions.
The blended inverse genomic and pedigree relationship matrix also requires the inverse of the part of the A matrix that relates to the genotyped animals (A~22~). This matrix has the same dimensions as G and is also demanding to invert. To overcome this issue, the kernel can be instructed to circumvent the need to invert A~22~.
APY is available both for the default and the hpblup solver. APY can be used with a pedigree containing genetic groups.

##### 1.1.1.1 Input files
In addition to a genetic marker file and a pedigree file, the user may opt to supply a pre-defined list of core animals. This file contains at least the original ID of the core animal in the first column. Any other columns are ignored.

##### 1.1.1.1. Syntax using a new APY inverse of genomic relationship matrix using a predefined number of random core animals
>ERMFILE \<Name file with genetic markers\> !CONSTRUCT SSmat !SINGLESTEP !APY !APYCoreRan \<number\>\
>\<animal ID\> \<field type\> \

Qualifiers:

**!APY**\
The qualifier !APY creates an approximate inverse of the genomic relationship matrix using genomic recursions. The approximation of the inverse matrix passed on to the kernel is lambda\*(alpha\*G - beta\*A~22~)~APY~^-1^. The need to invert A22 is circumvented during solving. The weighting factor omega still applies.

**!APYCORERAN <number>**\
The !APYCoreRan qualifier is used to randomly choose the specified number of individuals from the population of genotyped individuals to be included in the group of core individuals. 

##### 1.1.1.1. Syntax using a new APY inverse of genomic relationship matrix using a predefined list of core animals
>ERMFILE \<Name file with genetic markers\> !CONSTRUCT SSmat !SINGLESTEP !APY !APYCoreLis \<file name\>\
>\<animal ID\> \<field type\> 

Qualifier:

**!APYCORELIS \<file name\>**\
The !APYCoreLis qualifier is used to use a predefined list of genotyped individuals as core individuals. 

##### 1.1.1.1. Syntax using a new APY inverse of genomic relationship matrix using a number of random core animals determined by PCA
>ERMFILE \<Name file with genetic markers\> !CONSTRUCT SSmat !SINGLESTEP !APY !APYPCA \<target percentage of variation explained\>\
>\<animal ID\> \<field type\> 

Qualifier:

**!APYPCA <target percentage of variation explained>**\
The !APYPCA qualifier is used to determine the number of random core animals from the number of eigenvalues that explains the target proportion of variation among SNPs. MiXBLUP continues by randomly choosing this number of core animals to calculate the APY-inverse of G.

##### 1.1.1.1. Syntax using an existing APY inverse of genomic relationship matrix
>ERMFILE \<Name file with existing matrix\> !SINGLESTEP !APY \
>\<animal ID\> \<field type\>

Only the !SINGLESTEP and !APY qualifiers are meaningful in this context. The name of the file is typically *ExtRelMatOrig.txt* (or *ExtRelMat.txt* in case of integer IDs). The original name of this file as created by calc_grm is *gapy.dat*.

##### 1.1.1.1. Associated output files

|Output file | Description |
| :--- | :--- | 
|Solani.txt | Solutions of the direct genetic effect when the field type of the ID is integer |
|Solani.out | Solutions of the direct genetic effect when the field type of the ID is alphanumerical|
|ExtRelMat.txt | (Weighted) inverse genomic relationship matrix|
|corelist.dat | List of randomly chosen genotyped individuals for the core group|

!#ENDIF

!#IF(M99)!#ELSE
#### 1.1.1. Syntax of ssGTacBLUP: single-step GBLUP with component-wise Ta decomposition of a weighted G
>ERMFILE \<Name file with genetic markers\> !CONSTRUCT ssMat !Tac !SingleStep\
>\<animal ID\> \<field type\>

Any qualifier of ERMFILE described in chapter 5.4.1.1 and chapter 5.4.2.1 can also be used for a decomposition of a weighted inverse genomic relationship matrix. Specific qualifiers:

**!CONSTRUCT SSmat**\
The !CONSTRUCT qualifier indicates that the external relationship matrix has not been calculated yet and needs to be calculated in the MiXBLUP parser.

**!Tac**\
For a ssGBLUP analysis with a decomposition of a weighted inverse genomic relationship matrix, add the qualifier !Tac. Component-wise Ta decomposition of a weighted G is only more efficient if the number of genotyped individuals is substantially larger than the  number of SNP markers. If the number of genotyped individuals is between 40,000 and say 1.5 times the number of SNP markers, then ordinary Ta decomposition using the qualifier !Ta instead of !Tac may be more efficient.

#### 1.1.1. Syntax of ssSNPBLUP: single-step BLUP using SNP genotypes as covariates
>PEDFILE \<file name pedigree file\> !CalcInbr !Beta \<value\>\
>\<field individual ID\> \<field type I or A\>\
>\<field sire ID\> \<field type I or A\>\
>\<field dam ID\> \<field type I or A\>\
>\<...\>\
>SNPFILE [!CalcSNPvar] !NoCheck !NoPrune\
>\<field individual ID\> \<field type I or A\>\
>SNP01 \<file name SNP01\> !REGTYPE R [!IDCOL \<value\>] [!STARTCOV \<value\>]\
>\<...\>\
>MODEL\
>\<trait\> ~ \<...\> !RANDOM hpSNP(1,\<individual ID field\>) [hpSNP(1,\<dam ID field\>)] G(\<field individual ID\>[,\<dam ID field\>])

Qualifiers:

**!Beta <value>**\
The qualifier !Beta is optional and can be used to specify the fraction of residual polygenic variation. It must not be zero and should be at least 0.05, which is the default value if !Beta is not specified. The qualifier !Beta can be specified in the PEDFILE or the SOLVING section for ssSNPBLUP. The qualifier !Alpha cannot be specified for ssSNPBLUP but is calculated as 1 – Beta.

**!CalcSNPvar**\
The optional !CALCSNPVAR qualifier can be used to calculate the SNP variance from the direct genetic variance in the parameter file specified in the PARFILE section. The CALCSNPVAR qualifier must not be specified if one or more SNP files have SNP-specific variances (!REGTYPE H). If one or more SNP files are fixed (!REGTYPE F), the SNP variance is calculated using the remaining SNP files with !REGTYPE R. When !CALCSNPVAR is specified, the SNPPARFILE section is ignored.

**!NoCheck, !NoPrune**\
It is advised to use !NoCheck and !NoPrune if GEBV of young individuals with genotype, but not phenotype or progeny, are calculated in a separate analysis. Not using these options may lead to non-compatible SNP covariate files of the main evaluation and the evaluation of young genotyped individuals, which will result in an error.

#### 1.1.1. Syntax of DGV-Pedigree BLUP from Tac: using previously estimated SNP effects as prior information in pedigree BLUP
>PEDFILE \<file name pedigree file\> !CalcInbr\
>\<field individual ID\> \<field type I or A\>\
>\<field sire ID\> \<field type I or A\>\
>\<field dam ID\> \<field type I or A\>\
>\<...\>\
>ERMFILE \<genotype file in plink format\> !Plink !CONSTRUCT ssMat !SingleStep [!Tac or !Ta]
>\<field individual ID\>  \<field type I or A\>\
>!METHOD VanRaden\
>!MAF 0.000\
>!ALPHA 0.95\
>!DGVPBLUP \<name file with SNP effect solutions from Tac/Ta evaluation\>\
>!AlFreq \<name file with estimated allele frequencies from Tac/Ta evaluation\>\
>MODEL\
>\<trait\> ~ \<...\> !RANDOM G(\<field individual ID\>[,\<dam ID field\>])\
>SOLVING\
>!hpblup

Qualifiers:

**!DGVPBLUP <name of file with estimated SNP effects>**\
The qualifier !DGVPBLUP can be used to specify that old solutions for SNP effects should be used as prior information. For a component-wise Ta decomposition, SNP effect estimates are written to a file called snpeffects_ta.dat. The specified file should be a copy of this file.

**!AlFreq <name of file with estimated allele frequencies>**\
The qualifier !AlFreq is mandatory if !DGVPBLUP is used. The file specified should come from the same evaluation as the SNP effect estimates. Allele frequencies are written to  calculated_all_freq.dat. The specified file should be a copy of this file.

**!MAF 0.000**\
It is advised to use a minor allele frequency of 0.0%. Not using this option may lead to non-compatible SNP and allele frequency files, which will result in an error.

#### 1.1.1. Syntax of  DGV-Pedigree BLUP from ssSNPBLUP: using previously estimated SNP effects as prior information in pedigree BLUP
>PEDFILE \<file name pedigree file\> !CalcInbr !Beta \<value\>\
>\<field individual ID\> \<field type I or A\>\
>\<field sire ID\> \<field type I or A\>\
>\<field dam ID\> \<field type I or A\>\
>\<...\>\
>SNPFILE [!CalcSNPvar] !NoCheck !NoPrune !DGVPBLUP \<name file with SNP effects solutions\> !AlFreq \<name file with estimated allele frequencies\>\
>\<field individual ID\> \<field type I or A\>\
>SNP01 \<file name SNP01\> !REGTYPE R [!IDCOL \<value\>] [!STARTCOV \<value\>]\
>\<...\>\
>MODEL\
>\<trait\> ~ \<...\> !RANDOM hpSNP(1,\<individual ID field\>) [hpSNP(1,\<dam ID field\>)] G(\<field individual ID\>[,\<dam ID field\>])

Qualifiers:

**!DGVPBLUP \<name of file with estimated SNP effects\>**\
The qualifier !DGVPBLUP can be used to specify that old solutions for SNP effects should be used as prior information. For a single-step SNPBLUP evaluation, SNP effect estimates are written to solutions_mixblup.dat. The file Solreg_mat.txt can also be used and is considerably smaller. The specified file should be a copy of one of these file.

**!AlFreq <name of file with estimated allele frequencies>**\
The qualifier !AlFreq is mandatory if !DGVPBLUP is used. The file specified should come from the same evaluation as the SNP effect estimates. Allele frequencies are written to calculated_all_freq.dat. The specified file should be a copy of this file.

**!MAF 0.000 !NoCheck !NoPrune**\
It is advised to use a minor allele frequency of 0.0%, and the !NoCheck and !NoPrune options. Not using these options may lead to non-compatible SNP and allele frequency files, which will result in an error.!#ENDIF

!#IF(M99)!#ELSE
#### 1.1.1. Modelling a genetic difference between genotyped and non-genotyped individuals!#ENDIF!#IF(MiX) with the hpblup solver!#ENDIF

!#IF(M99)!#ELSE
##### 1.1.1.1. General

The group of genotyped individuals without genotyped ancestors may not be representative for the base population in the evaluation, which is the group of individuals without known parents. As a result, genomic estimated breeding values are biased in the presence of selection and/or selective genotyping (Vitezica et al., 2011). When genomic relationships were shifted by a constant in their study, the single-step method was unbiased and the most accurate of the methods compared.
For ssGBLUP using either a full or APY inverse of G, this constant is automatically applied by calc_grm, unless the !NoScale and !NoReg options are used. For ssGTacBLUP and ssSNPBLUP, this constant can be modelled with a so-called J factor that quantifies for any individual the pedigree relationship with genotyped individuals. For genotyped individuals, the J factor is set to -1. For base animals, the J factor is initialised at 0. For ancestors of genotyped individuals, the J factor (Jn) is estimated using Ann Jn = -Ang Jg, where Ang and Ann are partitions of A-inverse of non-genotyped ancestors by genotyped individuals and non-genotyped ancestors by non-genotyped ancestors, respectively, and Jg, as J factor for genotyped individuals, is a vector containing -1 for all. For all remaining individuals, the J factor is the average of the J factor of the parents. It is possible to do this calculation in MiXBLUP.
The regression coefficient of each trait on the J factor is estimated on all available records. The impact of a priori assuming that estimates originate from a normal distribution with a given variance (i.e. fitting it as a random effect) is very limited. It is therefore recommended to fit J-factor covariate as a fixed effect. 
The individual correction for bias, calculated for each trait as regression coefficient times J-factor covariate, is added to the GEBV of the trait for each animal. 
Note that the J factor will change for non-genotyped individuals if new genotyped individuals are added to an evaluation.
The calculation of J-factor covariates in MiXBLUP requires the genotype file and the pedigree file. An existing J-factor covariate file needs to contain all animals in the pedigree.

##### 1.1.1.1. Syntax of fitting J factor covariate
>PEDFILE \<file name pedigree file\> !CalcInbr !Beta \<value\> !MakeJcov\
>\<field individual ID\> \<field type I or A\>\
>\<field sire ID\> \<field type I or A\>\
>\<field dam ID\> \<field type I or A\>\
>\<...\>
>REGFILE\
>\<field individual ID\> \<field type I or A\>\
>REG01 !REGTYPE F !Jcov\
>\<...\>\
>MODEL\
>\<trait\> ~ \<...\> hpReg(1, \<field individual ID\>) !RANDOM \<...\>

Qualifiers:

**!MakeJcov**\
The qualifier !MakeJcov is optional and is used to specify the calculation of J-factor covariates.

**!Jcov**\
The qualifier !Jcov marks the covariate file that contains the J-factor covariates. If !MakeJcov is specified, it is not necessary to specify a file name.

**hpReg(\<number in label of covariate file\>, \<field individual ID\>)**\
The hpReg function is used to fit the J-factor covariate file in the model of each trait. It is recommended that it be fitted as a fixed effect, by specifying the RegType F qualifier in the REGFILE section and by specifying the hpReg function before the !Random qualifier on each line in the MODEL section.!#ENDIF

!#IF(M99)!#ELSE
#### 1.1.1. Obtaining solutions for genetic marker effects!#ENDIF!#IF(MiX) with the hpblup solver!#ENDIF
Genetic marker effect solutions are provided with the two recommended methods of a genomic evaluation, ssGTacBLUP and ssSNPBLUP. 
For ssGTaBLUP  and ssGTacBLUP, solutions of centred genetic markers (SNP) are present in a file called snpeffects_ta.dat. For ssSNPBLUP, these solutions are present in the file solutions_mixblup.dat, which contains all solutions and the file Solreg_mat.txt, which contains just the centred genetic marker effect solutions. Note that the order of the first four columns in these two files is different. The order of fields in Solreg_mat.txt is Trait - Matrix - Covariate - EffectID - Solution - Matrix name. The order of fields in solutions_mixblup.dat is Trait - EffectID - Class effect level - Covariate - Solution. 
If genetic marker effects are required, then either of these three files can be specified. MiXBLUP will recognise the type of file from the presence or absence of the matrix name in the last column.
Other supported methods of a genomic evaluation (Appendix XX) require back-solving to obtain genetic marker effect solutions. Back-solving needs to be specified at the start of a genomic evaluation. It cannot be done retrospectively. The option !BackSolve in the SOLVING section can be used for this purpose. Back-solving only yields approximate genetic marker effect solutions, so ssGTacBLUP and ssSNPBLUP are the two recommended methods to obtain genetic marker effect solutions.!#ENDIF

### 1.1. External genetic relationship matrix
#### 1.1.1. General
A range of inverse genetic relationship matrix files can be created by MiXBLUP explicitly or are 
implicitly incorporated in the analysis. It is also possible to use a previously created inverse 
genetic relationship matrix or one that as yet cannot be created by MiXBLUP itself.
It is not possible to calculate reliabilities with MiXBLUP when using a full external relationship 
matrix.

#### 1.1.1. Recommended file format
An external relationship matrix must contain the original ID of each individual. This can be a decoded matrix from a previous evaluation or one from an external source.
The recommended file format for a dense inverse relationship matrix (most matrix elements are non-zero) is the dense matrix format (chapter 5.2.2.2).
The recommended file format for a sparse inverse relationship matrix is the sparse matrix format. Each line consists at least of three fields: original individual ID of row, original individual ID of column, matrix element. Any other fields on the line are ignored.\
\<gebruik Example uit 5.5.2\>

#### 1.1.1. Syntax of using an external relationship matrix
>ERMFILE \<external relationship matrix file\> [!SKIP \<n lines\>] [!ASIS] [!NOORIG] \<field individual ID\> \<field type\>

Qualifier:

**!SKIP \<n lines\>**\
The optional !SKIP qualifier may be used to skip the first n lines of the external relationship matrix file. This is 
useful for ignoring a header line.

**!ASIS**\
The !AsIs qualifier is optional. It is used to write the external inverse relationship matrix to the kernel without any checks or sorting. This can be specified if the external relationship matrix file is known to be correct, for example because it was created or checked by MiXBLUP in a previous run. The !AsIs qualifier can only be used if the field type of the individual ID is integer. It is ignored when individual ID has alphanumerical field type. The !AsIs qualifier has no effect when using the hpblup solver.

**!NOORIG**\
If the MiX99 solver is used, MiXBLUP converts the coded external inverse relationship matrix file back to the original individual IDs. If this file is not needed for additional analyses, the !NoOrig qualifier can be specified. Especially for very large analyses, the size of this file can be substantial. For the hpblup solver, !NoOrig has no effect.

_Table_. Decoded weighted genomic relationship matrices from MiXBLUP evaluations

|Solver | Dense matrix format | Sparse matrix format | 
| :--- | :--- | :--- | 
|MiX99 solver - integer ID | ExtRelMat_tri.txt | ExtRelMat.txt | 
|MiX99 solver - alphanumerical ID | ExtRelMatAlphaTri.stream | ExtRelMatAlpha.stream | 
|hpblup solver | Not decoded | Not decoded | 

### 1.1. Genetic similarity in case of multiple breeds or lines and crosses

#### 1.1.1. General

There are several ways to correctly model that a genetic evaluation consists of multiple breeds, lines or crosses (referred to as genetic lines in this chapter). The effect of multiple genetic lines can be fitted as a fixed effect in the model, it can be fitted as a separate base population for each genetic line in the pedigree or allele frequencies specific for the genetic lines may be provided.

#### 1.1.1. Fixed effect in the model

In case of the evaluation only containing purebred individuals, the genetic line of the individual may be fitted as a fixed class effect. In case of unstructured crossbreeding, it is recommended to fit a covariate for each genetic line with the percentage of genes for that line, except for one genetic line: a covariate of the most prevalent genetic line should not be fitted in order to avoid singularity of the coefficient matrix. Its effect is then included in the overall mean. In case of purebred breeding and structured crossbreeding, either fixed class effects can be used, or fixed genetic line covariates. See Chapter 7 for the syntax of fitting fixed class effects or fixed covariates. Note that fixed effect estimates of genetic line are not automatically included in genetic effect solutions.

#### 1.1.1. Base population for each genetic line

An alternative way of fitting effects of genetic line is to assign individuals in the base generation to a base population (i.e. genetic group) that is specific for a genetic line. See Chapter 5.1.4 for the syntax of fitting multiple base populations. Solutions of base populations are automatically added to genetic effect solutions.

#### 1.1.1. Allele frequencies specific for a genetic line

A breed composition file can be used to indicate that allele frequencies should be estimated for each line in the breed composition file separately. The breed composition file contains the original animal ID in the first column and contains a number of additional columns that is equal to the number of genetic lines specified. The breed composition may be presented as a number, for example 4 (out of 8 or any other number), as a percentage, for example 50, or as a fraction, for example 0.50. MiXBLUP converts the breed composition of an animal to the value of one breed over the sum of values across breeds. For example in an analysis with four breeds, animal X having 4 0 2 2 as the breed composition will be converted to X 0.500 0.000 0.250 0.250. It is therefore essential that the breed information is complete, so add a column for ‘unknown or other’, if necessary. All columns must be separated by at least one space.

![](https://raw.githubusercontent.com/JantN1966/MasterManual/main/Images/GenSim06.jpg)\

_Example_. Breed composition file with the percentage of four breeds per animal
 
![](https://raw.githubusercontent.com/JantN1966/MasterManual/main/Images/GenSim07.jpg)\

_Example_. Breed composition file in parts of one eighth of four breeds per animal
 
### 1.1. Non-additive genetic similarity

Multiple genetic or genomic relationship matrices will be supported shortly. This includes a genomic dominance or epistasis relationship matrix. This section is pending the release of this feature.

#### 1.1.1. General

Systematic change of populations through genetic selection focuses on additive genetic effects. In reality, there may be interactions between alleles within a locus (dominance), interactions between loci (epistasis), and expression that depends on environmental conditions. Loss of heterozygosity because of inbreeding causes loss of dominance effects and leads to inbreeding depression. Recovering from inbreeding depression after crossbreeding is referred to as heterosis. Breaking up of favorable epistatic effects after repeated crossbreeding is referred to as recombination.

#### 1.1.1. Expected heterosis and recombination in crossbreds

In case of unstructured crossbreeding, it is meaningful to correct for expected heterosis and recombination if genotype information is not available for a large part of the population. Both are a function of the breed fractions of the parents. 

Expected heterosis (Het) for genetic line A and B of a crossbred individual is calculated as:\
>Het~A,B~ = p~sire,A~\*p~dam,B~ + p~dam,A~\*p~sire,B~

Expected recombination (Rec) for genetic line A and B of a crossbred individual is calculated as:\
>Rec~A,B~ = p~sire,A~\*p~sire,B~ + p~dam,A~\*p~dam,B~

Here, p~sire,A~ and p~dam,A~ are the breed fractions of genetic line A for the sire and the dam of the individual. An expected heterosis and an expected recombination term should be fitted for each combination of genetic lines present in the evaluation. Expected heterosis and recombination can be fitted as fixed covariates for each individual in the genetic evaluation. See Chapter 7 for the syntax of fitting a fixed covariate.

#### 1.1.1. Genomic dominance effects (to complete)

##### 1.1.1.1. General

Dominance effects can be estimated from heterozygous loci if all individuals in the evaluation are genotyped. Heterozygosity can be used to calculate an inverse dominance relationship matrix or create a  covariate. Genomic dominance can be fitted as an additional random genetic correlated effect.

##### 1.1.1.1. Syntax
>ERMFILE \<genotype file\> \
>\<ID field\> I/A\
>!ConstructDom\
>CORRFILE\
>RCE01 !GenRCE !Dominance # no file needed\
>\<…\>\
>SOLVING\
>!BackSolveDom

Qualifiers:

**!Dominance**
The !Dominance qualifier is used to specify that a random effect with correlated levels

**!ConstructDom**
\<...\>

**!BackSolveDom**
\<...\>

##### 1.1.1.1. Output files

| Output file | Description |
| --- | --- |
|  |  |

#### 1.1.1. Genomic epistasis effects (to complete)

##### 1.1.1.1. General
Modelling epistasis aims to estimate how pairs or groups of markers interact to affect a phenotype, such as in additive by additive or dominance by dominance interactions. The epistasis relationship matrix is usually constructed using the element-wise product of the (non-inverted) additive or dominance relationship matrices. The inverse of the epistasis relationship matrix is used in the genetic evaluation. Genomic epistasis is fitted as an additional random correlated genetic effect.

##### 1.1.1.1. Syntax
>ERMFILE \<genotype file\> \
>\<ID field\> I/A\
>!ConstructEpist\
>CORRFILE\
>RCE01 !GenRCE !Epistasis # no file needed
>\<...\>
>SOLVING

Qualifiers:
**!Epistasis**\
<...>

**!ConstructEpist**\
<...>

##### 1.1.1.1. Output files
| Output file | Description |
| --- | --- |
|  |  |

### 1.1. Genetic similarity in case of polyploidy or mixed ploidy

#### 1.1.1. General
The MiXBLUP software was designed originally to support breeding value estimation for diploid species. Although rare in mammals, a mix of diploid and polyploid individuals can be found in species like salamander, frog, trout, salmon, and various insect species. Support for mixed ploidy is currently only available for expected genetic similarity from pedigree. The underlying assumption is that founder animals in the pedigree are from a single large population. Unknown parent groups are currently not supported for polyploidy or mixed ploidy.

#### 1.1.1. Required format of pedigree file
A pedigree file in which some or all individuals are non-diploid, contains at least seven fields. The first seven fields are defined as described in the table below.

_Table_. Description of fields in a pedigree record for a mixed ploidy pedigree

|Field in pedigree record | Description |
| :--- | :--- |
|1 | Individual ID |
|2 | Sire ID |
|3 | Dam ID |
|4 | Ploidy level of the gamete transmitted by the sire |
|5 | Ploidy level of the gamete transmitted by the dam |
|6 | Probability that two gametic genes, drawn at random from a randomly selected locus, are inherited from a single parental chromosome (sire) |
|7 | Probability that two gametic genes, drawn at random from a randomly selected locus, are inherited from a single parental chromosome (dam) |

Ploidy level of the gamete of a parent of a diploid individual is 1. In that case, the probability that two gametic genes, drawn at random from a randomly selected locus, are inherited from a single parental chromosome is 0. For polyploid individuals, the latter probability is 0 if there is no identity by descent within a gamete, it is 1 if the polyploid gamete was transmitted by a double-haploid individual, and it is between 0 and 1 if there is recombination.

#### 1.1.1. Syntax
>PEDFILE pedigree_ploidy.txt  !polyploid !CalcInbr\
>\<field individual ID\> \<field type I or A\>\
>\<field sire ID\> \<field type I or A\>\
>\<field dam ID\> \<field type I or A\>\
>ploidy_sire I\
>ploidy_dam I\
>prob_sire I\
>prob_dam I

Qualifier:

**!Polyploid**\
The !Polyploid qualifier is used to specify that the pedigree contains non-diploid individuals. In that case, MiXBLUP expects each pedigree record to consist of at least seven fields instead of three fields. Without !Polyploid, the four additional fields in the pedigree are ignored. 
The use of !Polyploid results in an (implicit) inverse _pedigree_ relationship matrix that takes ploidy level of individuals into account. An inverse _genomic_ relationship matrix that takes differences in ploidy into account is currently not supported.

