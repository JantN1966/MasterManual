## 1. Reliabilities {#Reli01}

**Besides estimating genetic effects (or breeding values), MiXBLUP supports a second type of analysis to quantify the amount of information available to estimate the genetic effect of each individual. This is expressed as the reliability of the estimated (genomic) breeding value. This chapter describes how reliabilities can be calculated with MiXBLUP.**

### 1.1. General {#Reli02}

A reliability is a measure of the information that is available for the estimate of a breeding value. The reliability is dependent on the heritability and the presence of observations for the individual itself. The biggest impact on the reliability comes from the number of progeny with observations. Calculation of reliability is not supported for weighted residuals or marker haplotype models.
Exact reliabilities can be calculated only for a relatively small number of individuals in the pedigree, say less than 100,000 individuals. Of these individuals, no more than say 40,000 individuals can have a genotype record.
If there are more individuals in the evaluation, it is possible to calculate approximate reliabilities. Approximate reliabilities are built up from approximate pedigree reliabilities and the additional information provided by genomic relationships as a deviation from pedigree relationships.
!#IF(HPB)
HPBLUP supports the calculation of the exact reliability  of the EBVs of individuals for most statistical models.

|Type of evaluation | Reliabilities| Remarks|
| --- | --- | --- |
|Basic statistical model | direct| exact only|
|Maternal genetic model | direct & maternal| exact only|
|Social interaction model | direct & indirect| exact only|
|Pedigree relationships | direct & indirect| exact only|
|Genomic relationships | pedigree + genomic | exact only|
|SNP covariates | pedigree + genomic| exact only|

!#ELIF(M99)
MiXBLUP supports the calculation of an approximate pedigree reliability of the EBVs of individuals for most statistical models.

|Type of evaluation | Reliabilities| Remarks|
| --- | --- | --- |
|Basic statistical model | direct| approximate only|
|Maternal genetic model | direct & maternal| approximate only|
|Social interaction model | direct & indirect| approximate only|
|Random regression model | direct | approximate; only for calculated totals|
|Pedigree relationships | direct & indirect| approximate only|

!#ELSE
MiXBLUP supports the calculation of an approximate or exact pedigree or genomic reliability of the EBVs of individuals for most statistical models.

|Type of evaluation | Reliabilities| Remarks|
| --- | --- | --- |
|Basic statistical model | direct| exact or approximate|
|Maternal genetic model | direct & maternal| exact or approximate|
|Social interaction model | direct & indirect| exact or approximate|
|Random regression model | direct | approximate; only for calculated totals|
|Pedigree relationships | direct & indirect| exact or approximate|
|Genomic relationships | pedigree + genomic | exact or approximate; requires hpblup|
|SNP covariates | pedigree + genomic| exact or approximate; requires hpblup|

!#ENDIF
!#IF(M99)!#ELSE
### 1.1. Exact reliabilities {#Reli03}

#### 1.1.1.	General {#Reli04}

Exact reliabilities are calculated from the prediction error variance of an estimate. Prediction error variance is obtained from the diagonal of the inverse of the coefficient matrix. The need of a full inverse limits the size of a dataset for which exact reliabilities can be calculated. A prediction error variance is available for each genetic and non-genetic solution of the evaluation. Reliabilities are available only for the solutions of genetic effects of individuals. Exact reliabilities are pedigree reliabilities if no genomic information is used and genomic reliabilities if it is used. Exact reliabilities and prediction error variances are only available for the hpblup solver.

#### 1.1.1. Syntax {#Reli05}
>SOLVING\
>!hpblup\
>!reliab_exact

Qualifier:

**!reliab_exact**
The !reliab_exact is used to specify the calculation of exact reliabilities for genetic effects and the prediction error variance for each solution in the analysis. It has to be used in tandem with !hpblup.

#### 1.1.1.	Associated output files {#Reli06}
|Output file | Description|
| --- | --- |
|aggregate_pev.dat | Prediction error variance of each solution|
|Relani.out | Reliabilities of genetic effects of individuals|
!#ENDIF
!#IF(HPB)!#ELSE
### 1.1. Approximate reliabilities {#Reli07}

#### 1.1.1 General {#Reli08}

Approximate pedigree reliabilities are calculated for families within blocks. It is a completely different process than estimating breeding values. Approximate reliabilities are calculated in a separate analysis.

#### 1.1.1.	The concept of blocks in the reliability calculation in MiXBLUP {#Reli09}

##### 1.1.1.1. Block variable {#Reli10}

The calculation of reliabilities in MiXBLUP requires the use of a family block variable. The objective of using a block variable is to minimise the use of memory during the calculation by ordering of equations in equation family blocks (Lidauer and Strandén, 1999). Using a block variable has no benefit for breeding value estimation with MiXBLUP. To take advantage of this concept, it is important that each equation family block contains as many closely connected equations as possible, and that the number of equations connecting equation family blocks is as low as possible. A family consists of an individual, its parents and its progeny.

##### 1.1.1.1. Common-block variable {#Reli11}

Equations that connect all (or many) equations, such as individuals with progeny in many different blocks, can be grouped into one or several common blocks. Common blocks refer to blocks of equations, which will be kept in memory for all families. Equations of common blocks must be ordered to appear at the bottom of the MME, i.e. animals of common blocks must have largest block sorting variables. This ordering of mixed model equations yields for many animal breeding problems a structured coefficient matrix that has nearly doubly-bordered block diagonal form. The number of common blocks can be specified by the user. The default is that no common blocks are used. MiXBLUP will solve the mixed model equations even if such a structure cannot be achieved. However, pre-processing time may be longer than usual. As a consequence, it is important to keep this concept in mind when editing the data for the approximation of reliabilities.

##### 1.1.1.1. Sorting data and pedigree file on block variable {#Reli12}

The concept of equation family blocks requires that data and pedigree records be sorted on the block variable. MiXBLUP automatically checks whether files are sorted and sorts them if necessary.

##### 1.1.1.1. Strategies for block definition {#Reli13}

For example in dairy cattle, equations for animals in the same herd represent an equation family. Many models across species contain such effects and are therefore suitable block variables to be used to group equations into equation families. A good block variable orders the records such that all (or almost all) records of the same animal and its close relatives (parents and progeny) are in the same block. If the data does not contain such a variable, it might be possible to generate a suitable blocking variable. Again in dairy cattle, if a model contains a herd-year-season effect (such like a herd-test-day) but not a herd effect, it is advisable to include the herd code into the data and use it as the blocking variable.
MiXBLUP reads the data by blocks with one or several blocks at a time. If there is only one block in a large data file, all iteration files are read into the random access memory at the same time, which might exhaust computer resources. If the data can be read into the memory then this may be sensible.
When benefits of using equation family structure are desired, the block code of the animal has to be given in the pedigree file. Each animals block code needs to be the same as the one specified in the data file. Animals with records in different data blocks (e.g. in different herds) have to be coded with the code of one of the different data blocks where it has observations, e.g., the block with most of its observations. If an animal does not have an observation, but it is a parent to an animal with observations in the data file (e.g. pedigree animal of a particular herd), then it should receive the same block code as its offspring. This is most suitable for a cow without observations. It should be assigned to a block having most of its daughters.
When an animal does not belong to any equation family (no observations to give block code), or it is in many different families through relationship information (e.g. dairy sires have progeny in many herds), a new block code should be given. It is recommended to use a separate block code for animals with links to many different equation family blocks. For instance, sires in a dairy cattle population can be assigned to one block. These blocks should be defined as common blocks and largest block code variables have to be given to these blocks. Thus, sorting by the block code variable will ensure that animals of common blocks will appear at the bottom of the MME.
Animals that cannot be included into any equation family can be grouped into one or several own groups, depending on the number of such animals. An equation family should always have a reasonable size. For example, if the pedigree has equation families with 50 to 2000 animals per block and a block with 300,000 animals, it is advisable to split the largest block into several smaller blocks. The MiXBLUP kernel reads as many animal blocks at a time as possible, and the largest animal block dictates the memory requirements.

#### 1.1.1. Differences between the syntax of the instruction file for approximate reliability calculation and breeding value estimation {#Reli14}

##### 1.1.1.1. Data file {#Reli15}

For a reliability calculation, every animal in the evaluation has to be uniquely assigned to a level of the block variable. This block variable must be present in the data file.

##### 1.1.1.1. Genetic similarity between individuals {#Reli16}

The level of the block variable of an animal is also required in its record in the pedigree file. Genetic groups are ignored in the reliability calculation and replaced with unknown parents.

##### 1.1.1.1. Statistical model {#Reli17}

The statistical model for reliability calculation contains a single fixed effect that is treated as nested within blocks, even if it is an across-block effect. It should be the fixed effect with the largest impact on the reliability, so the lowest average number of observations within a class. The use of !WEIGHT is not supported.

##### 1.1.1.1. Control of analysis {#Reli18}

A reliability calculation is triggered with !RELIABILITY in the SOLVING section.

#### 1.1.1.	Syntax {#Reli19}
>DATAFILE \<file name\>\
>\<ID\> I/A\
>\<...\>\
>\<name block code\> I !BLOCK\
>PEDFILE \<file name\>\
>\<ID\> I/A\
>\<...\>\
>\<block code\> I !BLOCK\
>MODEL\
>\<trait1\> ~ BL(\<largest fixed class effect trait1\>) !RANDOM \<random effects\> G(\<ID\>)\
>\<trait2\> ~ BL(\<largest fixed class effect trait2\>) !RANDOM \<random effects\> G(\<ID\>)\
>SOLVING\
>!RELIABILITY\
>[!NCOMBLK \<number\>]\
>[!KEEPTMP]

Qualifier:

**!NCOMBLK \<number\>**
If common blocks are used, the qualifier !NCOMBLK should be used to specify how many common blocks there are. Common blocks should have a block identification that positions the block at the end of the list of blocks. The specified number of blocks at the end of the list of blocks are considered common blocks.

**!KEEPTMP**
The optional qualifier !KEEPTMP can be used to stop the removal of temporary files at the end of an analysis, for example to check for possible errors. The default is that all large temporary files are deleted as soon as they are no longer required.

Qualifiers other than !NCOMBLK and !KEEPTMP have no meaning when !RELIABILITY is specified, and will be ignored.

#### 1.1.1.	Associated output files {#Reli20}
|Output file | Description|
| --- | --- |
|Relani.txt | The reliability of direct genetic effects of traits in the model. The exact layout of Relani.txt is printed at the end of reliabilities.log.|
|Relani.out | As Relani.txt, but for alphanumerical ID labels|
|Relani_indirect.txt | The reliability of indirect genetic effects of traits in the model. The exact layout of Relani_indirect.txt is printed at the end of reliabilities.log.|
|Relani_indirect.out | As Relani_indirect.txt, but for alphanumerical class labels|
!#IF(MiX)
### 1.1. Approximate genomic reliabilities {#Reli21}

#### 1.1.1.	General {#Reli22}

MiXBLUP 3.0 contained two approximations of genomic reliabilities proposed by Misztal et al.  (2013; J. Dairy Sci. 96 :647–654). They have been removed from MiXBLUP 3.2, as they were not useful in practice.
Instead, the algorithm of Gao et al. (2023;  Genetics Selection Evolution 55:1) is now used. This algorithm first calculates approximate pedigree reliabilities as in Chapter 9.3 and then calculates the approximate genomic contribution to the reliability of a genomic estimated breeding value.

#### 1.1.1.	Instruction file {#Reli23}

The instruction file for approximate genomic reliabilities differs from a breeding value estimation in the same way as described above, but with an ERMFILE section with a genotype file added.

#### 1.1.1.	Syntax {#Reli24}
>SOLVING
>!greliability

Qualifiers:

**!greliability**
The qualifier !greliability is used to calculate approximate genomic reliabilities.

#### 1.1.1.	Associated output files {#Reli25}
|Output file | Description|
| --- | --- |
|Relani_ssg.out | Approximate genomic reliabilities|
|Relani.out | Approximate pedigree reliabilities|
!#ENDIF

### 1.1. Command-line interface for calculating reliabilities {#Reli26}

#### 1.1.1.	Syntax {#Reli27}
The recommended syntax for calling MiXBLUP to calculate reliabilities is:
>MiXBLUP.exe rel --type \<reliability type\> \<instruction file\>

The old syntax is also still supported:
>MiXBLUP.exe \<instruction file\>


**\<reliability type\>**!#IF(MiX)
|Type | Equivalent Flag | Description|
| --- | --- |
|exact | !reliab_exact | Exact reliabilities|
|pedigree | !reliability | Approximate pedigree reliabilities|
|genomic | !greliability | Approximate genomic reliabilities|
!#ELIF(HPB)
|Type | Equivalent Flag | Description|
| --- | --- |
|exact | !reliab_exact | Exact reliabilities|
!#ELSE
|Type | Equivalent Flag | Description|
| --- | --- |
|pedigree | !reliability | Approximate pedigree reliabilities|
!#ENDIF

