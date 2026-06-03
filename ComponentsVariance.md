## 1. Components of variance and covariance among traits {#Comp01}
Components of variance and covariance among traits are normally specified in the general parameter file. Additional covariance components for covariates in a covariate file need to be specified in separately labelled parameter files. Heterogeneous residual variances also need to be specified in a separate file. This chapter describes how to specify components of variance and covariance among traits.
### 1.1 General parameter file {#Comp02}
#### 1.1.1 General {#Comp03}
The trait (co)variance components file contains the between-trait variance-covariance matrices of any random effects in the statistical model.
There are two options for the format of the general parameter file: (1) in lower-triangular-matrix form and (2) in sparse-matrix form. It is strongly recommended to use the lower-triangular-matrix format.
The instruction file specifies the name of the trait (co)variance components file. The trait (co) variance components file is located by default in the work directory, but can be in another folder if specified in the name of the file.

#### 1.1.1  Input file in lower-triangular-matrix format {#Comp04}
The lower-triangular-matrix form is the default option and strongly recommended. In this form, the trait covariance components file can be specified as a lower-triangular matrix using trait names to identify the components. This is the most user-friendly way. The name of the random effect is given at the top of the matrix and the names of the traits are given at the start of each line of the matrix.

* The lower triangular matrices and the traits within a matrix can be specified in any order. It means that the order given in the MODEL section of the instruction file is not leading.
* The number of traits in the matrices can be larger than the number of traits specified in the model section. Only the lines for which the name has been specified in the model section will be used.
* The order of the column names must be the same as the order of row names, so variance components are on the diagonal.
* Restriction: in case of a marker-assisted BLUP model with the use of haplotype variance-covariance matrices, each matrix needs to be named and numbered, e.g. GIV1, GIV2, etc. The name GIV refers to the use of the General Inverse Variance (GIV) function in the model. The order of matrices must be the same as the order of haplotypes given in the model lines of the instruction file. See Example 5.4 in the Appendix.
* For all direct and indirect genetic effects (e.g. animal, dam, mate), it should be specified immediately after the trait name and within brackets whether it is the genetic variance of animal, dam or mate.
* In case of non-genetic random regression, the name of the class effect is specified at the top of the matrix and a line for each combination of trait and the full random regression term in the model of the trait should be specified. The syntax in previous versions of MiXBLUP with a separate matrix for each random regression term is still supported, but not recommended, as it ignores covariance components between different random regression terms of the same trait.
* If the model contains genetic random regression, then all fitted regression terms should be specified in the variance covariance table (e.g. animal\*covar1 and animal\*covar2).!#IF(MiX)
* For the default solver!#ENDIF!#IF(HPB)!#ELSE
 * If a covariate table file is used for random regression, then the columns should be referred to as cvr00 for the first covariate column, cvr01 for the second column and so on. The name should be lowercase: the use of CVR00 will give an error.
 * In case of a social interaction model, with multiple mate effects in the model, the first group mate effect in the model should be specified (e.g. mate1\*mate1_x, where mate1_x is a covariate that indicates whether mate2 is a real (1) or a dummy (0) group mate).!#ENDIF
!#IF(MiX)* For the hpblup solver!#ENDIF!#IF(M99)!#ELSE
 * If a covariate table file is used for random regression, then the columns should be referred to as TABLE01_00 for the first covariate column of the file labelled TABLE01, TABLE01_01 for the second column and so on.
 * In case of a social interaction model, with multiple mate effects in the model, the group mate in the G(<...>, LINK(<...>)) function in the model should be specified (e.g. mate1 for G(animal, LINK(mate1))).
 * In case of group phenotypes, the effect in the LINK function in the model should be specified in the corresponding trait variance-covariance matrix. This applies to all random effects in the model.!#ENDIF

![](https://raw.githubusercontent.com/JantN1966/MasterManual/main/Images/CompVar01.jpg)\

_Example_. The lower triangular trait (co)variance components file with two traits (body weight 1 and body weight 2) for non-genetic random regression, animal genetic and residual effects.

!#IF(HPB)!#ELSE
#### 1.1.1 Input file in sparse-matrix format for the MiX99 solver {#Comp05}
In the sparse matrix form, the order of the matrices must be the same as the order of random effects in the model, with the restriction that the genetic effect should be the last random effect in the model and the elements of its (co)variance matrix should appear in the sparse matrix file just before the elements of the residual (co)variance matrix. The residual (co) variance matrix should be specified at the end of the sparse matrix file.
In summary, the order of matrices is:
* Non-genetic random effects in the same order as specified in the model
* Genetic effects as specified in the model
* Residual effect
The matrix elements must be specified as the random effect number, row number, column number and the value of the (co)variance. To avoid mistakes, it is recommended to provide the elements of the lower triangle of the matrix, in other words, any column number is smaller than or equal to the row number. Off-diagonals only need to be specified if they are non-zero.
When haplotypes are used in the model for marker-assisted BLUP with the use of an inverse IBD matrix, both haplotypes are counted as effects, but the same variance components are used for the first and the second haplotype, when haplotypes are combined with the AND function, so the variance components should not be repeated for the second haplotype. Effectively, the effect number corresponding to the second haplotype is skipped from the list of inverse matrix elements. See Example 5.4 in the Appendix.

![](https://raw.githubusercontent.com/JantN1966/MasterManual/main/Images/CompVar02.jpg)\

_Example_. The trait (co) variance components file in sparse-matrix format with two traits for the animal genetic and residual effects Columns: random effect number, trait row number, trait column number and variance or covariance component.


#### 1.1.1 Syntax {#Comp06}

>PARFILE \<filename\> [!SPARSE]

Qualifier:

**!Sparse**\
If !SPARSE is specified, the variance and covariance components are read in sparse matrix form. If omitted, the matrix is read in lower triangular form.!#ENDIF

### 1.1 Parameter files for general covariates {#Comp07}

#### 1.1.1 General {#Comp08}

The regression parameter file is specified for each general covariate file that is fitted as random regression. The file may contain a single set of variances and covariances between traits that apply to all covariates or a set for each covariate separately.
The MiXBLUP shell checks whether scaling is necessary to avoid an error that the matrix is not positive-definite and applies any required scaling automatically.

#### 1.1.1 Input file {#Comp09}
The format of the files with parameters of general covariates is the lower-triangular-matrix format of the general parameter file. For the default solver, every line of the variance covariance matrix starts with the trait name, as it is used in MiXBLUP instruction file. Note that trait names are case-sensitive. If !RegType R is specified for the covariate file, a single trait variance-covariance matrix can be used for all covariates in the file. If !RegType H is used, a trait variance-covariance matrix has to be specified for each covariate.

![](https://raw.githubusercontent.com/JantN1966/MasterManual/main/Images/CompVar03.jpg)\

_Example_. Regression parameter file with a single set of variances and covariances between traits for all covariates. A regression parameter with covariate-specific variances and covariances contain such a set for each covariate. The number in the label of the matrix is linked with the position of the covariate in the record.

For the hpblup solver, a general covariate file may be fitted for multiple indices, so it is necessary to specify the trait name followed by the index name between brackets at the start of each line in the variance covariance matrix.

![](https://raw.githubusercontent.com/JantN1966/MasterManual/main/Images/CompVar04.jpg)\

_Example_. Regression parameter file with a single set of variances and covariances between traits for all covariates, for the hpblup solver.

#### 1.1.1 Syntax {#Comp10}

>REGPARFILE
>REG01 \<file name REG01\> \
>REG02 \<file name REG02\> \
>\<...\> \
>REG99 \<file name REG99\>

**REGPARFILE**\
The REGPARFILE section must contain the name of a parameter file for each covariate file for which the covariates are fitted as a random regression (so !REGTYPE is either ‘r’ or ‘h’). If the regression type is fixed, the corresponding file in REGPARFILE is ignored. The REGPARFILE section does not have any associated qualifiers.
The lines of the REGPARFILE section each contain two columns. The first column is the label that links the parameter file to the covariate file. The second column is the name of the file.

### 1.1. Parameters for SNP covariate files {#Comp11}

#### 1.1.1. General {#Comp12}

The SNP parameter file is specified for SNP covariate files that are to be fitted for random regression. The file may contain a single set of variances and covariances between traits for all SNP covariates or a set for each SNP covariate separately.
For a SNPBLUP model without a direct genetic effect and SNP genotypes presented as 0, 1 and 2, the SNP variance can be calculated from the direct genetic variance with\

![](https://raw.githubusercontent.com/JantN1966/MasterManual/main/Images/CompVar05.jpg)\

where N is the number of informative SNPs and pi is the allele frequency of the SNP allele counted on locus i. Non-informative SNPs must not be included in this calculation.
If variances smaller than 1.0E-06 are specified, then the MiXBLUP kernel may give an error that the variance-covariance matrix is not positive-definite. This can be resolved by scaling the phenotypes with 10 or 100 and the variances with 100 or 10,000 accordingly. The MiXBLUP shell checks whether scaling is necessary and applies any required scaling automatically.

#### 1.1.1. Input file {#Comp13}
The format of the files with parameters of general covariates is the lower-triangular-matrix format of the general parameter file.
If a single set of variances and covariances between traits is to be used for all SNP covariates (so !REGTYPE is ‘r’), then only one matrix needs to be specified. The matrix label needs to start with ‘SNP’, but the number is ignored.
If SNP-specific variances and covariances are to be used (so !REGTYPE is ‘h’), then a matrix has to be specified for every SNP covariate separately. Depending on the number of SNP covariates in a file, this could be many thousands. The label has to start with ‘SNP’. The number in the label of the matrix is linked with the position of the SNP covariate in the record of the corresponding file. The number must be sequential and may be an integer between 1 and 2.1 billion.
The label of a matrix in a SNP parameter file refers to a SNP covariate in the corresponding covariate file and should not be confused with the label linking the SNP covariate and parameter files.
For the default solver, every line of the variance covariance matrix starts with the trait name, as it is used in MiXBLUP instruction file.

![](https://raw.githubusercontent.com/JantN1966/MasterManual/main/Images/CompVar06.jpg)\

_Example_. SNP parameter file with a single set of variances and covariances between traits for all SNP covariates, for the MiX99 solver.

For the hpblup solver, a SNP covariate file may be fitted for multiple indices, so it is necessary to specify the trait name followed by the index name between brackets at the start of each line in the variance covariance matrix.

![](https://raw.githubusercontent.com/JantN1966/MasterManual/main/Images/CompVar07.jpg)\

_Example_. SNP parameter file with a single set of variances and covariances between traits for all SNP covariates, for the hpblup solver.

#### 1.1.1. Syntax {#Comp14}
>SNPPARFILE \
>SNP01 \<file name SNP01\> \
>SNP02 \<file name SNP02\> \
>\<...\> \
>SNP99 \<file name SNP99\>

**SNPPARFILE**\
The SNPPARFILE section specifies the name of a parameter file for each SNP covariate file for which the SNP covariates are fitted as a random regression (so !REGTYPE is either ‘r’ or ‘h’). If the regression type is random and !CalcSNPvar has been specified, the corresponding file in SNPPARFILE is ignored. The SNPPARFILE section does not have any associated qualifiers.
The lines of the SNPPARFILE section each contain two columns. The first column is the label that links the parameter file to the SNP covariate file. The second column is the name of the file.

### 1.1. Parameters in case of heterogeneous residual variances {#Comp15}

#### 1.1.1. General {#Comp16}

The residual variance may not be the same for all observations. If this is the case, observations can be grouped by their residual variance prior to the analysis. A column in the data file links the observation to the correct residual variance matrix. Modelling data with a random regression approach often requires the use of multiple residual variance classes.

#### 1.1.1. Input file {#Comp17}
The file contains a matrix for every class number in the linking column in the data file. The name of the matrix is Res followed by the class number between brackets. The class number has to be an integer.
The example below gives the series of residual matrices for a situation with observations being linked to one of three residual variances classes.

![](https://raw.githubusercontent.com/JantN1966/MasterManual/main/Images/CompVar08.jpg)\

_Example_. The residual covariance file with three residual variance-covariance matrices.

#### 1.1.1. Syntax {#Comp18}
>DATAFILE \<filename\> \
>\<...>\
[\<field j\> I !RESVARCLASS] \
>\<..\>\
>RESFILE \<filename\>


Section:

**RESFILE**\
The RESFILE section specifies the name of the file with residual between-trait variance-covariance matrices. The RESFILE section does not have specific qualifiers.

Qualifier:

**!RESVARCLASS**\
The qualifier !ResVarClass in the DATAFILE section links a data record to the appropriate residual variance class, in case the residual variance differs for groups of records. The field is integer. The qualifier !RESVARCLASS must be used if the section RESFILE is specified.
