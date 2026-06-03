## 1. Instruction file {#Inst01}

The instruction file contains all information that !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF needs for the analysis. This chapter gives an overview of the instruction file. The various parts of the instruction file are discussed in detail in the chapters 4 to 8.


### 1.1.  Parts of the instruction file {#Inst02}

The information in the !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF instruction file is presented in six parts. These parts are:
1. Description of the analysis
2. Observations & systematic effects
3. Genetic similarity among individuals
4. Components of variance and covariance among traits
5. Statistical models
6. Control of analysis and output


These parts may be presented in the instruction file in any order. Sections within a part may also appear in any order. Below the example instruction file is given for a bivariate animal model for two traits (phen1 and phen2).

>TITLE breeding value estimation for phen1 and phen2 using pedigree\
>**\# Observations & systematic effects**\
>DATAFILE ExampleDat.txt !MISSING -99\
>animal A\
>fix1 A\
>fix2 I\
>cov R\
>ran A\
>phen1 T\
>phen2 T\
>blk I\
>**\# Genetic similarity among individuals**\
>PEDFILE ExamplePed.txt\
>animal A\
>sire A\
>dam A\
>blkped I\
>**\# Components of variance and covariance among traits**\
>PARFILE ExamplePar.dat\
>**\# Statistical models**\
>MODEL\
>phen1 ~ fix1 cov !RANDOM ran G(animal)\
>phen2 ~ fix2 cov !RANDOM ran G(animal)\
>**\# Control of analysis and output**\
>SOLVING\
>!MAXIT 1000\

_Example_. Parts of the instruction file.

#### 1.1.1. Title of the analysis {#Inst03}

The instruction file must start with a specification of the title of the analysis. The TITLE keyword is optional. If omitted, the first line must start with a hash (#). This comment line is then used as the title of the analysis. This line can be used to describe the analysis and distinguish it from other analyses.


#### 1.1.1. Observations & systematic effects {#Inst04}

The data observations part of the instruction file contains the name of the files with data or covariates, their location and their record layout. The sections that can be used in this part are DATAFILE, CVRTABLE and REGFILE. The syntax of these sections, more advanced options and examples are presented in Chapter 4 of this manual.

#### 1.1.1. Genetic similarity among individuals {#Inst05}

Genetic similarity among individuals can be specified in many different ways. It may be based on pedigree information only, genomic information only or both sources of information simultaneously. Pedigree information may contain genetic groups for unknown parents or a single code to denote an unknown parent. Inbreeding can be taken into account or ignored. Genomic information may be incorporated through covariances between individuals or through regression on SNP covariates. Sections that can be used in this part are PEDFILE, ERMFILE, INBRFILE, SNPFILE, REGFILE, CORRFILE and CVMATRIX. The syntax of these sections and examples for the various options are presented in Chapter 5 of this manual.

#### 1.1.1. Components of variance and covariance among traits {#Inst06}

Genetic and non-genetic random effects have components of variance and covariance among traits in the model. Residual (co)variance components may also vary between groups of data records. Section that can be used in this part are PARFILE, RESFILE, SNPPARFILE and REGPARFILE. The syntax of these sections is presented in Chapter 6.

#### 1.1.1. Statistical models {#Inst07}

Statistical models are specified by trait. Each trait starts on a new line. The only sections in this part of the instruction file are MODEL, LINKEDEFFECTS and COMBINE. The syntax of the various statistical models supported by !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF are presented in Chapter 7.

#### 1.1.1. Control of analysis and output {#Inst08}

The control part of the instruction file can be used to specify (1) whether to solve the system (i.e. estimate breeding values) or calculate approximate reliabilities, (2) whether or not to use starting values, (3) which resources to use for parts of the process, (4) when to stop the iterative process and write out the solutions, (5) how to present the solutions, (6) which additional output files to create after the solving process has been completed and (7) how to manage temporary files. The sections that can be used in this part are SOLVING, TRAITEBV, PRECON and TMPDIR. Syntax is presented in Chapter 8.

### 1.1. General syntax of the instruction file {#Inst09}

* The maximum record length of the instruction file is 5,000 characters
* The instruction file may contain empty lines for the convenience of the user
* Comments may be inserted on a new line or after instructions on the same line, provided that any comment starts with a hash (#). Any text on a line following a hash is ignored by !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF
* The keyword of any section must be the first word of the line



