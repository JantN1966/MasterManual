## 1. Observations & systematic effects

**The data observations part of the instruction file is used to specify observed traits and any factors or covariates that cause systematic variation between observations for these traits. This chapter describes the various ways to present observations and systematic effects.**

### 1.1. Data file

#### 1.1.1. General

Observations and systematic effects are normally presented in the data file. All traits and effects in the statistical model must have a column in the data file, except for covariates in a covariate table file and covariates in an external covariate file.
The name of the data file is specified in the instruction file. The data file is located by default in the work directory, but it can be in any other folder if this is specified as part of the name of the file (e.g. d:\PerformanceTest\BreedP.txt). The order of the fields in the DATAFILE section must be the same as the order of the fields in the data file.

#### 1.1.1. Input file

The data fields (individuals, systematic effects and trait observations) each have their own column in the data file. The data file must be provided in space-separated format, which means that any two columns are separated by at least one space. Data fields can be integer values or alphanumeric labels for class effects or real values for covariates and trait observations. Real values are read with a decimal point.

Details of the layout of the data file:

* The maximum column width in the data file is 25 characters.
* The maximum record length of the data file is 5,000 characters.
* When data is alphanumeric, any of the symbols on the keyboard can be used, including a slash (‘/’).
* An alphanumeric string must not contain spaces or it will be interpreted as two strings.!#IF(HPB)!#ELSE
* For the MiX99 solver, a class effect must not be zero or negative if it is a number, regardless of whether it is declared as integer or alphanumerical. Data records with a class effect in the model that is zero are omitted from the analysis by the kernel as invalid data points. Therefore, MiXBLUP replaces any classes of zero or a negative number with a 1 for an integer class effect or “NA” for an alphanumerical class effect. This will not affect the results of the evaluation if the invalid classes are not associated with a valid trait observation. It is left to the user to verify that this is indeed the case.!#ENDIF!#IF(HPB)
* For the hpblup solver, a class effect may be zero if the effect should not be included in the model for the record containing the zero, for example when combining pseudo-records, such as de-regressed proofs, and real observations. A class effect must not be negative.!#ENDIF
* The default missing-value indicator for traits and covariates is zero. Data records with a covariate in the model that is equal to the missing-value indicator are omitted from the analysis by the kernel. If zero is a valid level for one of the covariates in the model, another missing-value indicator should be used. The missing value indicator has to be numerical.

_Example_. Columns in data file: animal ID, mean, herd, sex, dam ID, haplotype 1, haplotype 2, common environment, pen mate 1, pen mate 2, age 1, age 2, genotype, body weight at age 1, bodyweight at age 2.


#### 1.1.1. Syntax

> DATAFILE \<filename\> [!SKIP \<n lines\>] [!MISSING \<value\>] [!SLASH] [!STATS [N][D][H][L]] !MINMAX \<filename\> \
>\<field 1\> \<field type: I/R/T/A\> \
>... \
!#IF(HPB)!#ELSE>[\<field i\> I !BLOCK] \!#ENDIF
>[\<field j\> I !RESVARCLASS] \
>... \
>[\<field n\>] [I/R/T/A]  

Section:
**DATAFILE** \
The DATAFILE section contains all the details of the file with trait observations and systematic effects.

Qualifiers:
**!MISSING \<value\>** \
If the value specified for !MISSING is encountered when reading traits or covariates in the data file, it is interpreted as a missing observation for that trait or covariate. A missing covariate invalidates the trait for which the covariate is included in the model.
!#IF(HPB)!#ELSE
**!BLOCK** \
This field is used as the block variable. If used, the data file and pedigree file both need to contain this column. It is required for the calculation of reliabilities, but might be beneficial in some computationally heavy genetic evaluations. The field must be integer. The !block qualifier must not be specified in the PEDFILE section, but the fourth column in the pedigree file must have the same field name as the block variable in the data file.!#ENDIF

**!RESVARCLASS** \
This field is used to specify the residual variance class of the data record, in case the residual variance differs for groups of records. The field must be integer. The qualifier !RESVARCLASS must be used if the section RESFILE is specified.

**!SKIP \<value\>** \
With this qualifier, one (!SKIP 1) or more (e.g. !SKIP 2) header lines in a data file can be ignored when reading the data file.

**!SLASH** \
The qualifier !SLASH is optional and is used when any of the input files contains a forward slash (‘/’) as a character. A forward slash is also a control character in certain file formats. If !SLASH is not specified, but MiXBLUP encounters a record with a forward slash, it will re-start reading the file as if !SLASH had been specified. Reading of data with !SLASH specified is slower than normal reading of data.

**!STATS NDHL** \
The qualifier !STATS can be used to obtain a summary of descriptive statistics of files in the evaluation, written to Statistics.log. There are four types of statistics that can be produced: N for numbers of records in data, pedigree and genotype file; D for means and standard deviations of traits and covariates in the data; H for grouping class effect levels for each trait by the number of records per class and L for a table by trait with number of records for each class effect level. For large evaluations, it is recommended to use !STATS NDH, as the option L might produce a very large output file. Types may be specified in any order. If D, H or L are specified, N is automatically included.

**!MINMAX \<filename\>** \
The qualifier !MINMAX can be used to specify a file with the valid ranges of traits and covariates. The file contains three fields for each record: the name of the field in the data file (case-sensitive!), the minimum and the maximum valid value. Field records may be in any order and may contain field records of other data files, 
like the parameter file.

More details of the syntax of the DATAFILE section:

* The field specification must start on the line following the line containing the DATAFILE keyword
* The field type indicates whether a field in the data file should be read as an integer value (I), a real value for covariates (R), a real value for a trait (T) or a text string (A).
* Maximum length of field names is 8 characters. A field name may be up to 19 characters long, but only the first 8 characters are used to distinguish fields, so a warning is given to remind the user. 
* Field names longer than 19 characters result in an error.
* Field names are case-sensitive.!#IF(HPB)!#ELSE
* The qualifier !BLOCK only affects the MiX99 solver. If it is specified for multiple data fields, only the first specification is used.!#ENDIF
* Alphanumerical labels of a class effect (fields coded with A) are converted into integer values for the analysis. Solutions are decoded back to the original alphanumerical labels of the effect.
* Each alphanumerical label in a field in the data file gets a unique numerical value. There is no apparent relation between the alphanumerical label and numerical value, so the numerical value of a string may vary across runs without using old solutions as starting values. The numerical value of a string does not change if old solutions are used as starting values by specifying !RESTART in the SOLVING section.!#IF(M99)!#ELSE
* When using the hpblup solver, there is effectively no difference between field types A and I, as both types will be treated as alphanumeric.!#ENDIF
* The ID of animal in the data file, and the IDs of animal, its sire and its dam in the pedigree file must all be of the same type, so either alphanumeric (A) or numeric (I).
* The largest integer number that can be used as level of a class effect is approximately 2,100,000,000 (2^31^). For class effects with levels that exceed this number, the field type has to be set to alphanumerical (A).!#IF(MiX)
* The version of the data file with alphanumerical labels converted to integer values is ‘data.txt’ for the MiX99 solver and hpData.txt for the hpblup solver.!#ENDIF!#IF(M99)
* The version of the data file with alphanumerical labels converted to integer values is ‘data.txt’.!#ENDIF!#IF(HPB)
* The version of the data file with alphanumerical labels converted to integer values is hpData.txt.!#ENDIF
* The use of names reserved as section keywords, qualifiers or functions as field names is not supported.

#### 1.1.1.	Associated output files

| Output file | Description |
| --- | --- |
| data.txt | temporary file; data file prepared for analysis by kernel|

### 1.1. Covariate table file

#### 1.1.1.	General	

If the relationship between an independent variable and a dependent trait is modelled as an n^th^ order polynomial, a covariate table file with all levels of the independent variable between its minimum and maximum value in the data and (n+1) columns of covariates may be used for easy presentation of covariates and syntax of the instruction file.
The name of a pre-defined covariate table file is specified in the instruction file. The name may include the path to the covariate table file.
A covariate table file can also be created in MiXBLUP. Currently only a Legendre polynomial is supported. A covariate table is created using the minimum and maximum value of the 
independent variable and the required order of the polynomial. The minimum and maximum value of the independent variable can either be specified by the user or determined from the data.
!#IF(MiX)For the MiX99 solver, only one covariate table can be used, but its columns may be fitted within multiple class effects. Additional polynomials using other independent variables should be added as columns in the data file prior to calling MiXBLUP. For the hpblup solver, it is possible to use multiple covariate table files and indices to link covariate records to data records may be different between covariate tables.!#ENDIF
!#IF(M99)Only one covariate table can be used, but its columns may be fitted within multiple class effects. Additional polynomials using other independent variables should be added as columns in the data file prior to calling MiXBLUP.!#ENDIF!
#IF(HPB)It is possible to use multiple covariate table files and indices to link covariate records to data records may be different between covariate tables.!#ENDIF

#### 1.1.1 Input file 

A covariate table file may be created outside of !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF, it may have been created in a previous analysis or it may be created at run-time. It consists of the original independent variable and the n+1 covariates derived from it, with n being the order of the polynomial.
If the order is n, the covariate columns in the table are numbered from 0 to n, giving n+1 covariate columns in addition to the original independent variable.
The independent variable has to have an integer field type. The covariate table should contain all levels between the minimum and maximum value with steps of one. It means that an independent variable with decimals must be converted to integer values before a covariate table can be used for it. The independent variable links the record in the data file with the covariate record in the covariate table.
The column in the data file with the independent variable must contain a valid entry for every record. 
!#IF(MiX)For the hpblup solver, e!#ELIF(HPB)E!#ENDIFach covariate table must have a unique label that starts with TABLE followed by a number between 01 and 99.!#ENDIF

_Example_. A covariate table file for an independent variable with values in the data between 86 and 115. The order of the Legendre polynomial is 2. The table was created with the line  !CVRMAKE LEG !CVRNUM 2 !CVRMIN 86 !CVRMAX 115 in the CVRTABLE section of the instruction file.

!#IF(HPB)!#ELSE
##### 1.1.1.1. Syntax using an existing covariate table for the MiX99 solver

>DATAFILE \<filename\> \
>...\
>\<field k\> I !CVRIND\
>...\
>CVRTABLE \<filename\>\
>MODEL \
>\<trait\> ~ \<fixed effects\> \<Class1\>\*CVR(n1) !RANDOM \<Class2\>\*CVR(n2) G(Animal\*CVR(n3)) \
>...

Sections:

**CVRTABLE**/
The CVRTABLE section contains the details of the existing or new covariate table.

Qualifiers:

**!CVRIND** /
The field marked with !CVRIND is the independent variable used in polynomial regression. Any level of the field specified with !CVRIND must exist in the covariate table file. The field must not contain a missing value indicator for a valid trait observation. The qualifier !CVRIND must be used when the section CVRTABLE is specified. The field must be integer. The qualifier !CVRIND, specified in DATAFILE section, should not be 
confused with !CVRindex that is used with hpblup solver and specified in the CVRTABLE section.

**CVR(...)** /
The CVR function is used in the MODEL section and is a shorthand for all polynomial terms to be fitted and may be used in the same way as any individual random regression term. The alternative way to specify polynomial random regression is to use the individual columns of the covariate table file. The names of the columns are cvr00, cvr01, cvr02, ..., cvrnn.!#ENDIF
!#IF(M99)!#ELSE
##### 1.1.1.1 Syntax using an existing covariate table for the hpblup solver

>...\
>CVRTABLE !nCVRTABLES 2 \
>TABLE01 \<filename\> !CVRNUM \<n^th^ order\> !CVRMIN \<minimum value\> !CVRMAX \<maximum value\>  !CVRSingleCov !CVRIndex \<index field name\> \
>TABLE04 \<filename\> !CVRNUM \<n^th^ order\> !CVRMIN \<minimum value\> !CVRMAX \<maximum value\>  !CVRSingleCov !CVRIndex \<index field name\> \
>\
>MODEL \
>\<trait\> ~ \<fixed effects\> \<Class1\>\*TABLE01 !RANDOM \<Class2\>\*TABLE04 G(Animal\*TABLE04) \
>...

Additional qualifiers:

**!nCVRTABLES** \
This qualifier specifies the number of covariate tables included in this section

**!CVRIndex** \
This qualifier specifies the field name of the index in the DATAFILE. !#ENDIF!#IF(MiX)Please note that this option is different from !CVRIND, which is used with the MiX99 solver and specified in the DATAFILE section.!#ENDIF!#IF(M99)!#ELSE 

**!CVRSingleCov** \
This qualifier is used to create a separate file for each covariate in table specified. Each covariate in the table is then be fitted as a separate effect for the hpblup solver.

**TABLE*tt* in the MODEL section** \
A covariate table file specified in the CVRTABLE section can be fitted in the model by fitting its label. It may be used in the same way as any individual random regression term. The names of its columns in variance covariance matrix files are cvr*tt*\_00 to cvr*tt*\_*nn*, where *tt* is the number in the label of the covariate table and *nn* the order of the polynomial specified for the covariate table *tt*.!#ENDIF
!#IF(HPB)!#ELSE
##### 1.1.1.1 Syntax using a newly created covariate table for the MiX99 solver
>DATAFILE \<filename\> \
>...\
>\<field k\> I !CVRIND \
>...\
>CVRTABLE !CVRMAKE LEG !CVRNUM \<n^th^ order\> !CVRMIN \<minimum value\> !CVRMAX \<maximum value\> \
>MODEL \<trait\> ~ \<fixed effects\> \<Class1\>\*CVR(n1) !RANDOM \<Class2\>\*CVR(n2) G(Animal\*CVR(n3)) \
>...

Additional qualifiers:

**!CVRMAKE** \
If !CVRMAKE is specified, MiXBLUP generates a covariate table file using the settings specified with the !CVRNUM, !CVRMIN and !CVRMAX qualifiers. Currently, only a covariate table containing Legendre polynomials can be created, by specifying LEG as the argument of !CVRMAKE. The name of the new covariate table file is ‘cvrtable.txt’.

**!CVRNUM** \
The qualifier !CVRNUM must be specified and is used to specify the order of the polynomial in the covariate table. The expected number of columns to read is the order + 2, one for the level of the independent variable and one for the order being 0. It is up to the user to make sure that the order specified in the MODEL section is equal to or lower than the order specified with !CVRNUM.

**!CVRMIN and !CVRMAX** \

The qualifiers !CVRMIN and !CVRMAX can be used to specify the lowest and highest value of the independent variable that were used to estimate the genetic parameters. Legendre polynomials are dependent on the lowest and highest value of the independent variable and so are the genetic parameters of Legendre polynomials. If !CVRMIN or !CVRMAX is nevertheless omitted, the lowest or highest value of the independent variable in the data is used, instead.!#ENDIF
!#IF(M99)!#ELSE
##### 1.1.1.1 Syntax using newly created covariate tables for the hpblup solver 

>...\
>CVRTABLE !nCVRTables \<value\> \
>TABLE01 !CVRMAKE LEG !CVRSingleCov !CVRNUM \<n^th^ order\> !CVRMIN \<minimum value\> !CVRMAX \<maximum value\> !CVRIndex \<field name of the index\> \
>TABLE02 !CVRMAKE LEG !CVRNUM \<n^th^ order\> !CVRMIN \<minimum value\> !CVRMAX \<maximum value\> !CVRIndex \<field name of the index\> \
>...\
>MODEL \<trait\> ~ \<fixed effects\> TABLE01 !RANDOM \<Class\>\*TABLE02 G(TABLE02\*animal)

##### Additional qualifiers:

**!CVRMAKE** \

If !CVRMAKE is specified, MiXBLUP generates a covariate table file using the settings specified with the !CVRNUM, !CVRMIN and !CVRMAX qualifiers. Currently, only a covariate table containing Legendre polynomials can be created, by specifying LEG as the argument of !CVRMAKE. The name of the new covariate table file is ‘hpTable*tt*.txt’, for example hpTable01.txt. If !CVRSingleCov is specified, a separate file is created for each covariate. In that case, the names of the new covariate table files are ‘hpTable*tt*_*nn*.txt’, for example hpTable01_00.txt, where *tt* is the number in the label of the covariate table and *nn* the number of the covariate of the polynomial specified for the covariate table *tt*, ranging from 0 to the order specified.!#ENDIF

#### 1.1.1 	Associated output files
|Output file | Description |
| --- | --- |
|cvrtable.txt | covariate table, if created by !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF |

### 1.1	General covariate files
#### 1.1.1 	General
Some covariates are individual-specific: they never change for an individual, but vary across individuals. They are more associated with the individual than with its data records. Examples are breed composition, genetic groups, heterosis and recombination. Such covariates can be stored in a covariate file, in which all individuals in the analysis have a record. !#IF(HPB)!#ELSEMiXBLUP converts the covariate file with all individuals to a data covariate file that exactly matches the data file, including repeated records.!#ENDIF

#### 1.1.1 Input file
General covariate files contain at least the ID of the animal and any number of covariates, but all records should have the same number of covariates. General covariate files must be provided in space-separated format. Covariates are read as real numbers, regardless of whether a decimal point is present in the corresponding field.
General covariate files contain at least all individuals with a phenotype for any of the traits in the statistical model. Individuals without any phenotypes will be ignored, except in the case of genetic group covariates.

_Example_. Covariate file with breed fractions in a mixed breed population


#### 1.1.1 	Syntax
##### 1.1.1.1 Syntax of a general covariate file and associated variance-covariance file
>REGFILE \
>\<field animal\> \<field type I or A\> \
>REG01 \<file name REG01\> !REGTYPE F/R/H [!IDCOL 1] [!STARTCOV 2] [!LASTCOV 7] \
>REG02 \<file name REG02\> !REGTYPE F/R/H [!IDCOL 1] [!STARTCOV 2] [!LASTCOV 7] \
>...\
>REG99 \<file name REG99\> !REGTYPE F/R/H [!IDCOL 1] [!STARTCOV 2] [!LASTCOV 7] \
> \
REGPARFILE \
>REG01 \<file name REG01\> \
>REG02 \<file name REG02\> \
>... \
>REG99 \<file name REG99\>

##### Sections:

**REGFILE** \
The REGFILE section specifies the name of one or more general covariate files and its attributes, such as column numbers and whether one variance for all covariates is used or an individual variance for each covariate.

**REGPARFILE** \
The REGPARFILE section is used to specify a file with components of variance and covariance among traits associated with general covariates. A general covariate file labelled in REGFILE needs a corresponding entry in a REGPARFILE section if the regression type is R for random or H for heterogeneous variances.
There are no file-independent qualifiers. 

##### Qualifiers:

The file-dependent qualifiers of REGFILE can be specified for each covariate file. These qualifiers are explained below.

**!REGTYPE** \ 
The file-specification line must contain the !REGTYPE qualifier. It specifies how the covariates in the file are fitted in the model. 
If ‘f’ is specified, the covariates in the file are fitted as a fixed regression. Covariates fitted as a fixed effect do not have a variance associated with it, so it is not necessary to specify a parameter file in the REGPARFILE section. If it is present, it is ignored.
If ‘r’ is specified, the covariates in the file are fitted as a random regression with a single variance for all covariates in the file. The variance is specified in the corresponding parameter file in the REGPARFILE section. If ‘h’ is specified, the covariates in the file are fitted as a random regression, each with their own variance. The covariate-specific variances are specified in the corresponding parameter file in the REGPARFILE section.

**!IDCOL** \
The !IDCOL qualifier is optional and specifies which field in the covariate file contains the ID of the individual. If it is omitted, it is assumed that the ID is in the first field of the record (so the default is !IDCOL 1).

**!STARTCOV** \

The !STARTCOV qualifier is optional and specifies which field contains the first covariate. If it is omitted, it is assumed that the covariates start in the second field of the record (so !STARTCOV 2).

**!LASTCOV** \

The !LASTCOV qualifier is optional and specifies which field contains the last covariate of the file to include in the model. If it is omitted, it is assumed that all fields after the first covariate contain covariates to include in the model.
!#IF(HPB)!#ELSE
##### 1.1.1.1 Syntax of fitting a general covariate file in the model for the MiX99 solver
>MODEL trait ~ fixed !RANDOM REG(1,2..5)

##### Qualifiers:

**REG(...)** \
The REG function is used in the MODEL section and can be used to specify which general covariate files should be fitted in the model of a trait. If a covariate file is specified, then all specified covariates in the file will be fitted simultaneously.
The numbers in the REG(...) function link to the number in the label of the general covariate file in the REGFILE section (and the REGPARFILE section). The numbers may be specified individually as (1, 2, 3, 4) or as a range, indicated by two subsequent full stops, for example (1..4), or a combination of both.
If a covariate file is fitted for any trait through REG(...), the covariates will be fitted for all traits, even the ones for which REG(...) is not specified.!#ENDIF
!#IF(M99)!#ELSE
##### 1.1.1.1 Syntax of fitting a general covariate file in the model for the hpblup solver
>MODEL trait ~ \<fixed\> !RANDOM hpREG(1,\<field index\>)

##### Qualifiers:

**hpREG(\<number in label of covariate file\>, \<field index\>)** \
The hpReg function is used to fit a general covariate file in the model of a trait, for which it is specified. For a random effect, REGTYPE needs to be set to R or H and hpREG needs to be specified after the !Random qualifier. For a fixed effect, REGTYPE needs to be set to F and hpREG needs to be specified before the !Random qualifier.!#ENDIF

#### 1.1.1 Associated output files
|Output file | Description |
| --- | --- |
|RegCov%%.txt | temporary file; data covariate file |
|RegCov%%NoDat.txt | temporary file; covariates of individuals without any phenotypes|
|Solreg_mat.txt | solutions of all covariates in any general or SNP covariate file|

### 1.1	Random effects with correlated level effects

#### 1.1.1 General
For non-genetic random effects, it is often assumed that level effects are uncorrelated. In practice, this may not be a valid assumption, for example for subsequent year-seasons within a herd. For these cases, the user may provide a correlation matrix to model that some level effects are more similar than others.

#### 1.1.1 Input file
The inverse of the correlation matrix has to be provided as a sparse matrix in I-J-Value format. The file contains a line for each non-zero element in the matrix. The line contains effect label of row, effect label of column, non-zero element. It has to be provided in upper-triangular format, so I is equal to or lower than J in the I-J-Value format. The user has to verify that the inverse correlation matrix is positive definite and not close to singularity.

### 1.1.1 Syntax
>CORRFILE \
>RCE01 \<file name RCE01\> \
>RCE05 \<file name RCE05\> \
>\
>MODEL\
>\<trait\> ~ \<fixed\> !RANDOM RCE(\<random effect name for RCE01\>,1) RCE(\<random effect name for RCE05\>,5) G(…)

Sections:
**CORRFILE** \
The CORRFILE section specifies the name of one or more inverse correlation matrix files for non-genetic random correlated effects. The CORRFILE section does not have qualifiers for non-genetic random effects. For use of CORRFILE for specifying additional genetic relationship matrices.

#### 1.1.1	Associated output files
Output files are the same as for non-genetic random uncorrelated effects.
