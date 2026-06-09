## 1. Statistical models {#Stat01}

**Observed traits on two individuals may be similar due to genetic effects and systematic non-genetic effects. The statistical model contains all such effects known to explain variation in observed traits. This chapter describes various statistical models to estimate genetic effects on traits with as little bias as possible.**

### 1.1. Basic models {#Stat02}

#### 1.1.1. General {#Stat03}

The MODEL section specifies the start of the statistical models for the traits in the analysis. Traits and statistical models start immediately below the line with the MODEL keyword. For each trait, the statistical model is specified on a separate line. !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF supports up to 63 traits to be analysed simultaneously, if computer resources permit this.
The basic statistical model for a breeding value evaluation contains fixed effects, uncorrelated, non-genetic random effects and a direct genetic random effect. Uncorrelated, non-genetic random class effects are assumed to have an identity relationship matrix between levels of the effect.
Each model line contains trait name, fixed effects, non-genetic random effects and genetic random effects. Fixed effects may be class effects, covariates or covariates nested within a class effect.
Similarly, random effects may be class effects or covariates nested within a class effect. The residual random effect does not need to be specified. The minimum statistical model contains one fixed effect and one genetic random effect.

#### 1.1.1. Syntax {#Stat04}
>MODEL \
>\<trait1\>  ~ \<class effects\> [covariates] [class effect \* covariates] &!RANDOM G(\<direct genetic effect\>) [\<non-genetic random effects\>]\
>[\<trait2\> ...] \
><...>\
>[<traitN> ...]

Section:

**MODEL**\
The MODEL section specifies the statistical model for the traits in the analysis.

Qualifiers:

**\~ (tilde)**\
The tilde separates the trait from the statistical model.

**\* (star)**\
The star is used for nesting a covariate within a class effect, to yield a regression coefficient for each level of the class effect. This can be used for both fixed and random nested covariates. The star must not be used to
model an interaction of class effects.

**!RANDOM**\
The !RANDOM qualifier separates the fixed effects from the random effects in the model.

**G(...)**\
The G(...) function links a random effect to the inverse genetic or genomic relationship matrix.

#### 1.1.1. Associated output files {#Stat05}
|Output file | Description |
| --- | --- |
|Solfix.txt | Solutions of fixed effects by trait (class effects, covariates and nested covariates)|
|Solfix.out | As Solfix.txt, but for alphanumerical class labels|
|Solr00.txt | Solutions of non-genetic, uncorrelated random effect 00 by trait, where 00 ranges |
| | from 1 to the number of non-genetic, uncorrelated random effects across traits |
| | (class effects, covariates and nested covariates) |
|Solr00.out | As Solr00.txt, but for alphanumerical class labels|


### 1.1. Repeatability models {#Stat06}

#### 1.1.1. General {#Stat07}

Certain traits are measured just once in the lifetime of an individual. Other traits may be measured repeatedly. Two observations on a single individual are more similar than expected from having the same genotype. A permanent environmental effect is usually added to the model to account for non-genetic similarity of records of the same individual.
Such a permanent environmental effect has the same label as the direct genetic effect, but with an identity relationship matrix between levels. This permanent environmental effect should have its own column in the data file and must not be the column with the direct genetic effect (although identical).

#### 1.1.1. Syntax {#Stat08}
>MODEL \
>\<trait\1>  ~ \<fixed effects\> !RANDOM G(\<direct genetic effect\>) \<permanent environmental effect\> \
>\<...\>\
>[\<traitN\> ...]

#### 1.1.1. Associated output files {#Stat09}
|Output file | Description |
| --- | --- |
|Solr00.txt | Solutions of non-genetic, uncorrelated random effect 00 by trait, where 00 ranges |
| | from 1 to the number of non-genetic, uncorrelated random effects across traits |
| | (among which the permanent environmental effect)|
|Solr00.out | As Solr00.txt, but for alphanumerical class labels |

### 1.1.   Maternal genetic models {#Stat10}

#### 1.1.1   General {#Stat11}
Some traits are affected by the genotype of the animal itself and the genotype of its dam at the same time. An example is weaning weight in beef cattle. For such traits, a maternal genetic model should be used. The inverse numerator relationship matrix is applied both to the direct genetic effect (animal) and the maternal genetic effect (dam).
The maternal genetic effect must be a separate field in the data file and each individual in this field must exist as an individual in pedigree, genotype file or other resource of genetic similarity.
For biological dams, this is self-evident, but for foster dams, this requires special attention.

#### 1.1.1. Syntax {#Stat12}
>MODEL \
>\<trait\1>  ~ \<fixed effects\> !RANDOM \<...\> G\<direct genetic effect\>, \<maternal genetic effect\>) \
>\<...\>\
>[\<traitN\> ...]

The maternal genetic effect is placed within the brackets of function G to link it with the relationship matrix between individuals.

#### 1.1.1. Associated output files {#Stat13}
|Output file | Description |
| --- | --- |
|Solani.txt | The solutions of the maternal genetic effect are included as additional columns in |
| | Solani.txt. The exact layout of Solani.txt is printed at the end of solver.log.|
|Solani.out | As Solani.txt, but for alphanumerical ID labels|

### 1.1. Social interaction models {#Stat14}

#### 1.1.1. General {#Stat15}

The social interaction model (or group selection) is used to estimate the effects of an individual’s genotype on its own performance and on the performance of its pen mates simultaneously. It should be used for groups of a single group size, but a slightly varying group size is also supported.
For a single group size, a genetic effect for social interaction is fitted for each pen mate. This effect can be interpreted as the genetic value for supporting or inhibiting the expression of the direct genetic merit of pen mates. The genetic variance of this social effect is dependent on the size of the group, so performance in small and large groups by design should not be combined as one trait.
!#IF(HPB)!#ELSEIf the size of groups is the same by design, but it varies slightly due to death or removal from the pen, it is still possible to fit a social interaction model by adding a covariate of either 0 (not present) or 1 (present) and apply a nested regression of this covariate within pen mate. The ID label used for not-present pen mates must appear in the pedigree or genotype file, too, but no information is added to its social genetic value when the covariate is zero (not present).

#### 1.1.1. Syntax of the social interaction model with one group size for all groups for the MiX99 solver {#Stat16}
>DATAFILE\
>\<ID individual\> \<field type I or A\>\
>\<...\>\
>mate1 I \
>mate2 I \
>\<...\>\
>mateN I\
>MODEL \
>\<trait1\> ~ \<...\> !RANDOM \<...\> G(<ID individual\>,mate1 AND mate2 \<...\> AND mateN)\
[\<trait2\> ...] \
>\<...\>\
>[\<traitN\> ...]

The pen mates need to be defined in the data file. The number of additional columns is equal to the number of pen mates (mate1, mate2, ..., mateN).

Qualifier:

**AND**\
The function AND combines the effects of different mates to one design matrix. There are a few constraints when combining effects; all of them are rare:

* When ‘AND’ is used for group selection, it cannot be used for IBD-haplotypes. In other words, haplotype effects cannot be included in a social interaction model.
* Combining of effects needs to be the same for any traits for which effects are combined. In other words, traits measured when the animal was in a different group need to be analyzed in a separate analysis.
* The parser supports an evaluation in which some traits have social genetic effects and other traits do not.
* There can be only one group of combined genetic effects, so no commas must be placed between the effects of mates. It means that the genetic effects can only be combined to one other effect and not more.
* The order of genetic effects should be kept the same across traits with a social interaction model.

#### 1.1.1. Syntax of the social interaction model with slightly varying group sizes for the MiX99 solver {#Stat17}
>DATAFILE \
>\<ID individual\> \<field type I or A\> \
>\<...\>
>mate1 I \
>present1 R \
>mate2 I \
>present2 R \
>\<...>\
>mateN I \
>presentN R \
>MODEL \
>\<trait1\> ~ \<...\> !RANDOM \<...\> G(<ID individual\>,present1\*mate1 AND present2\*mate2 \<...\> AND presentN\*mateN) \
[\<trait2\> \<...\>] \
><...>\
>[\<traitN\> \<...\>]

Both the pen mates and their presence need to be defined in the data file. The number of additional columns is therefore equal to two times the number of pen mates (mate1, mate2, ...,
mateN, present1, present2, ..., presentN).!#ENDIF

!#IF(M99)!#ELSE
#### 1.1.1.   Syntax of the social interaction model for the hpblup solver {#Stat18}
>DATAFILE\
>Animal I\
>\<...\>\
>mate1 I \
>mate2 I \
>\<...\>\
>mateN I\
>MODEL \
>\<trait1\> ~ \<...\> \<...\> !RANDOM \<...\> G(Animal,LINK(mate1)) \
>[\<traitN\> \<...\>]\
>LINKEDEFFECTS \
>mate1 ~ mate2 ... mateN

The pen mates need to be defined in the data file. The number of additional columns is equal to the number of pen mates (mate1, mate2, ..., mateN). For slightly varying group sizes, just use a
zero for a missing pen mate.

Section:

**LINKEDEFFECTS**\
The section LinkedEffects is used to specify which effects are linked to the leading effect and should be combined with the leading effect. The leading effect should be presented before the tilde (~); linked effects should be presented after it. The number of lines in the LinkedEffect section matches the number of unique occurrences of the LINK function in the MODEL section. So if multiple traits contain G(Animal,LINK(mate1)) in the model, only one line is needed in the LinkedEffect section.

Qualifier:

**LINK**\
The function LINK specifies the leading effect of a set of linked effects in the model.!#ENDIF

#### 1.1.1. Associated output files {#Stat19}

|Output file | Description |
| --- | --- |
|Solani.txt | The solutions of the social genetic effects are included as additional columns in |
|  | Solani.txt. The exact layout of Solani.txt is printed at the end of solver.log.|
|Solani.out | As Solani.txt, but for alphanumerical ID labels|

### 1.1. Random regression models {#Stat20}

#### 1.1.1.   General {#Stat21}

There are two types of random regression models supported by !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF, the non-genetic and genetic random regression model. Both original covariates and polynomials derived from an independent variable may be used in the model.
In a non-genetic random regression model, the regression of the observations on an independent covariate is fitted as a random effect. Random regression in !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF has to be specified as regression nested within a class variable. If no nested regression is required, the user needs to add a column of ones to the data file, and fit the covariate within this class effect of a single level. The internal structure of !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF requires that any random effect be associated with a class effect. This can be seen in the parameter files, too, where variance-covariance matrices are all specified by class effect.
In a genetic random regression model, trait observations are regressed on the covariate within animals, taking into account the genetic relationships between animals. The estimated breeding values from such an analysis concern the animal-specific parameters of the line or curve fitted. The user needs to convert these estimates to estimated breeding values at a given level of the covariate or for a function of levels of the covariate.
If the relationship between an observed trait and an independent variable is non-linear, it may still be possible to model the relationship with polynomials, as a special case of multiple linear regression. Polynomial regression is a form of linear regression in which the relationship between the independent variable x and the observed trait is modelled as an nth degree polynomial in x by fitting (n+1) covariates derived from x. Polynomials may be provided by the user either in the data file or in a covariate table, or may calculated during the preparations for the analysis and stored in a covariate table. Polynomials calculated by !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF are Legendre polynomials.

!#IF(HPB)!#ELSE
#### 1.1.1. Syntax of a simple non-genetic random regression model for the MiX99 solver {#Stat22}
>MODEL \
>\<trait1\> ~ \<...\> !RANDOM \<class\>\*\<covariate\> [\<class\>\*\<covariate\> \<...\>]\
>\<...\>\
>[\<traitN\> \<...\>]

The random regression term consists of a class effect with field type integer (I) or alphanumerical (A) and a covariate with field type real (R). Each random regression term has to be present in the variance-covariance matrix of the class effect in the parameter file (see chapter [1.1.](#Comp02)).

Qualifier:

**\* (star)**\
The star is used for nesting a covariate within a class effect, to yield a regression coefficient for each level of the class effect. There is no specific order of class effect and covariate in the term.

#### 1.1.1. Syntax of a simple genetic random regression model for the MiX99 solver {#Stat23}
>MODEL \
>\<trait1\> ~ <...> !RANDOM G(\<ID\>\*\<covariate\>[,\<ID\>\*\<covariate\>]) <...> \
>\<...\>\
>[\<traitN\> \<...\>]

The regression terms nested within the individual’s ID are placed within the function G(...) to indicate that the relationship matrix of individuals should be used.

#### 1.1.1. Syntax of a polynomial regression model using a covariate table for the MiX99 solver {#Stat24}
>CVRTABLE \<name covariate\> \
>MODEL \
>\<trait1\> ~ \<...\> \<class\>\*CVR(\<n1\>) !RANDOM \<class\>\*CVR(\<n2\>) G(\<ID\>*CVR(\<n3\>)) \<...\>\
>\<...\>\
>[\<traitN\> \<...\>]

For the use of covariate table files with the MiX99 solver, see chapter [1.1.1.1.](#Obse10) and [1.1.1.1.](#Obse12).

Qualifier:

**CVR(...)**\
The CVR function is used in the MODEL section and is a shorthand for all polynomial terms to be fitted and may be used in the same way as any individual random regression term. The alternative way to specify polynomial random regression is to use the individual columns of the covariate table file. The names of the columns are cvr00, cvr01, cvr02, ..., cvrnn. The label is lowercase and has exactly two digits ranging from 00 to 99.!#ENDIF

!#IF(M99)!#ELSE
#### 1.1.1. Syntax of a simple non-genetic random regression model for the hpblup solver {#Stat25}
>REGFILE \
>\<field ID\> \<field type I or A\> \
>REG02 \<file name REG02\> !REGTYPE \<R or H\> \
REGPARFILE \
>REG02 \<file name REG02\> \
>MODEL \
>\<trait1\> ~ \<...\> !RANDOM \<class\>\*hpReg(\<field ID\>,2) [\<class\>\*hpReg(\<field dam ID\>,2) \<...\>]\
>\<...\>\
>[\<traitN\> \<...\>]

For the hpblup solver, covariates in a random regression should be provided in a covariate table or a general covariate file, but not as a field in the data file. The random regression term consists of a class effect with field type integer (I) or alphanumerical (A) and a covariate with field type real (R). Each random regression term has to be present in the variance-covariance matrix of the class effect in the parameter file (see chapter 6.1).

Qualifier:

**\* (star)**\
The star is used for nesting a covariate within a class effect, to yield a regression coefficient for each level of the class effect. There is no specific order of class effect and covariate in the term.

#### 1.1.1. Syntax of a simple genetic random regression model for the hpblup solver {#Stat26}
>REGFILE \
>\<field ID\> \<field type I or A\> \
>REG02 \<file name REG02\> !REGTYPE \<R or H\> \
REGPARFILE \
>REG02 \<file name REG02\> \
>MODEL \
>\<trait1\> ~ <...> !RANDOM G(\<ID\>\*hpReg(\<field ID\>,2)) <...> \
>\<...\>\
>[\<traitN\> \<...\>]

For the hpblup solver, covariates in a random regression should be provided in a covariate table or a general covariate file, but not as a field in the data file. The regression terms nested within the individual’s ID are placed within the function G(...) to indicate that the relationship matrix of individuals should be used.

#### 1.1.1. Syntax of a polynomial regression model using a covariate table for the hpblup solver {#Stat27}
>CVRTABLE !nCVRTABLES 2 \
>TABLE01 \<filename\> !CVRNUM \<nth order\> !CVRMIN \<minimum value\> !CVRMAX \<maximum value\>  !CVRSingleCov !CVRIndex \<index field name\> \
>TABLE04 \<filename\> !CVRNUM \<nth order\> !CVRMIN \<minimum value\> !CVRMAX \<maximum value\>  !CVRSingleCov !CVRIndex \<index field name\>\
>MODEL \
>\<trait\> ~ \<fixed effects\> \<Class1\>\*TABLE01 !RANDOM \<Class2\>\*TABLE04 G(Animal\*TABLE04)

For the use of covariate table files with the hpblup solver, see chapter [1.1.1.1.](#Obse11) and [1.1.1.1.](#Obse13).

Qualifier:

**TABLEnn**\
The TABLEnn label is a shorthand for a specific covariate table file. It automatically fits all covariates in the file, unlike for the CVR(...) function for the MiX99 solver, which can be used to fit a smaller number of covariates from a covariate table file. The names of the covariates in the parameter file with trait variance-covariance matrices are TABLEnn_cc, where nn is the table number and cc the covariate number starting with 00 (for example TABLE01_00 for the first covariate).!#ENDIF

#### 1.1.1.   Associated output files {#Stat28}
|Output file | Description |
| --- | --- |
|Solani.txt | The solutions of the genetic nested regression effects are included as additional |
| | columns in Solani.txt. The exact layout of Solani.txt is printed at the end of solver.log. |
|Solani.out | As Solani.txt, but for alphanumerical ID labels|
|Solr00.txt | The solutions of the non-genetic nested regression effects are included as |
| | additional columns in Solr00.txt. The exact layout of Solr00.txt is printed at the end |
| | of solver.log.|
|Solr00.out | As Solr00.txt, but for alphanumerical class labels|

### 1.1. Weighting residuals by record {#Stat29}

#### 1.1.1   General {#Stat30}

If the common assumption of constant standard deviation of the residuals (i.e. homogeneous residual variance) is not met, it is possible to weight individual records. Less precise measurements get less weight and more weight is given to more precise measurements when estimating breeding values.
An example is the use of de-regressed breeding values as a pseudo-phenotype. The standard deviation of the residual depends on the reliability of the original estimated breeding value. A weighting factor based on the reliability can be used to give more weight to pseudo-phenotypes based on a relatively large amount of information.
Another example is variation in residual variances within contemporary groups. Observations in contemporary groups with a large residual variance can be given a proportionally lower weighting factor.

#### 1.1.1. Syntax {#Stat31}
>MODEL \
>\<trait1\> [!WEIGHT \<weighting factor\>] ~ \<fixed effects\> !RANDOM G(\<ID\>) [\<non-genetic random effects\>] \
>\<...\>\
>[\<traitN\> \<...\>]

Qualifier:

**!WEIGHT**\
A field in the data file can be specified as a weighting factor for a specific trait using the !WEIGHT qualifier.

#### 1.1.1. Associated output files {#Stat32}

The standard output files are used for a weighted analysis.

### 1.1. Combining effects across traits {#Stat33}

#### 1.1.1.   General {#Stat34}

If a trait measured in different cycles or parities or on individuals of different strains and crosses is modelled as multiple traits, it may be desirable to estimate fixed effects across these traits, in order to increase the precision of the solutions of the model. Random effects can easily be combined by specifying covariances between the traits that are equivalent to a correlation close to unity. For fixed effects, it has to be specified across which traits the effect should be estimated.

#### 1.1.1. Syntax {#Stat35}
>MODEL \
>\<trait1\> ~ \<fixed1\> !RANDOM G(\<ID\>) [\<random1\>] \
>\<trait2\> ~ \<fixed1\> !RANDOM G(\<ID\>) [\<random1\>] \
\<...\>\
><traitN\> ~ \<fixed\> !RANDOM G(\<ID\>) [\<random\>]\
>COMBINE \
>\<fixed1\> ~ \<trait1\> \<trait2\>

Section:

**COMBINE**\
The section COMBINE allows to specify across which traits a fixed effect should be estimated. It supports class effects, covariates and nested covariates.

#### 1.1.1. Associated output files {#Stat36}

The standard output files are used for an analysis with fixed and random effects estimated across several traits.

### 1.1. Correction of heterogeneous residual variances {#Stat37}

#### 1.1.1. General {#Stat38}

If residual variance within contemporary groups varies (heterogeneous residual variance), the user may specify appropriate weighting factors in the data file and weight records accordingly (see chapter [1.1.](#Stat29)).
!#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF also offers the possibility to calculate appropriate weighting factors in a three-step approach. In the first step, the traits are analysed with the assumption of homogeneous residual variance. The residuals (ê) are read from the output of step 1 and the linearized squared residuals (z) for trait i and animal j are calculated as

![equation01](https://raw.githubusercontent.com/JantN1966/MasterManual/main/Images/StatMod01.jpg)\

Var(e~i~) is the residual variance of trait i used in the first step and is obtained from the res(idual) matrix in the parameter file or, if residual variance classes are used, the residual variance of the corresponding class of the record.
In the second step, these linearised squared residuals are analysed using a suitable model.
The predicted phenotypes of this second model are used to calculate weighting factors. The weighting factor for trait i and individual j is calculated from the predicted value of the linearised squared residual (Z~ij~) as

![equation01](https://raw.githubusercontent.com/JantN1966/MasterManual/main/Images/StatMod02.jpg)\

where Z~i.~ is the average predicted value of the linearized squared residual for trait i across all individuals.
In the third step, the analysis of the first step is repeated, but with a weighting factor added to account for heterogeneous residual variance.
!#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF can run these three steps in a single process.

#### 1.1.1. Syntax {#Stat39}
>MODEL \
>\<trait1\>  ~ \<fixed1\> !RANDOM \<random1\> G(\<ID\>) \
>\<trait2\>  ~ \<fixed2\> !RANDOM \<random2\> G(\<ID\>) \
>\<trait3\>  ~ \<fixed3\> !RANDOM \<random3\> G(\<ID\>)\
>VARMODEL \
>LSR1  ~ \<fixed\> !RANDOM \<random\> G(<ID>) !VARTRAIT \<trait1\> LSR2  ~ \<fixed\> !RANDOM \<random\> G(\<ID\>) !VARTRAIT \<trait2\>\
>SOLVING \
>!DHGLM !HETCOR

Section:

**VARMODEL**\
The VARMODEL section specifies the statistical model for the second step for the linearized squared residuals.

Qualifiers:

**!VARTRAIT**\
The qualifier !VARTRAIT in the VARMODEL section is mandatory and links the linearized squared residual to the
original trait. Original traits do not have to be all represented in the VARMODEL section.

**!DHGLM**\
The option !DHGLM in the SOLVING section prepares !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF for multiple calls of the kernel.

**!HETCOR**\
The qualifier !HETCOR in the SOLVING section creates the data file and instruction file for each step.

#### 1.1.1. Associated output files {#Stat40}

The standard output files are used for an analysis with correction for heterogeneous variances.
!#IF(HPB)!#ELSE
### 1.1. Using a threshold model for a categorical trait (MiX99 solver only) {#Stat41}

#### 1.1.1. General {#Stat42}

The linear model used in MiXBLUP to estimate breeding values is based on the assumptions that a trait has a continuous normal distribution, its components of variance are homogeneous and residuals are uncorrelated with genetic and non-genetic random effects.
There are traits that are recorded as categories. A binary trait has only two possible categories, for example, present or absent, true or false, all or none. Traits with more than two categories may be ordered, for example small-medium-large, or unordered, such as red-yellow-blue. For categorical traits, the usual assumptions of a linear model are violated.

It has been proposed to overcome this by assuming a continuous trait underlying the categorical trait. Thresholds on the underlying scale determine the recorded category on the observed scale. The threshold model is more demanding than the linear model.
There are methods available for the threshold model: Newton-Raphson (NR) and Expectation-Maximisation (EM). Both methods give the same results but use a different route. Both methods have two levels of iterations. The outer level iterates on the thresholds, given the set of estimated solutions of the previous iteration. The inner level iterates on the solutions given the current estimates of the threshold.
Currently only one categorical trait can be analysed with a threshold model in a multi-trait evaluation of any number of traits analysed with a linear model.
Although theoretically incorrect, assuming a linear model for a categorical trait often yield solutions that rank selection candidates largely in correct order. This is especially the case for intermediate prevalence of categories.

#### 1.1.1. Input files {#Stat43}

Category labels must be numbered 1 to the number of categories for the MiXBLUP kernel.
MiXBLUP can rename category labels for this purpose from a file with ordered labels by trait. The file is specified with !CONVERTCAT. The first field is the trait name in the data file.
Subsequent fields contain the category labels. The position in the sequence determines the new sequential integer code, 1..n. Although MiXBLUP currently supports only a single trait with a threshold model in combination with any number of traits with a linear model, multiple traits may be specified for use across evaluations. In the example below, the stature categories Small, Medium and Large are converted to 1, 2 and 3, according to their positions in the record. The diseased categories 1 and 0 are converted to 1 and 2. Note that a binary trait coded as 0/1 has to be converted to 1 and 2.

>Stature Small Medium Tall \
>Diseased 1 0

_Example_. Category conversion table.

It is also possible to fix thresholds at a predefined value, using !THRFIXED. Thresholds must be taken from a N(0,1) underlying distribution. The file may contain any number of categorical traits, but in any evaluation, only one categorical trait can be analysed with a threshold model, currently. The number of thresholds to be specified is the number of categories minus 1. Thresholds may be taken from a previous analysis or calculated from the observed prevalence in a larger set of data.

>Stature -0.34 0.56 \
>Diseased 0.0

_Example_. Table with fixed thresholds.

#### 1.1.1. Syntax {#Stat44}
>DATAFILE \<filename\> [!CONVERTCAT \<filename\>] \
>\<...\>\
>MODEL \
>\<trait1\>  ~ \<fixed1\> !RANDOM \<random1\> G(\<ID\>)\
>\<...\>\
>\<trait3\>  ~ \<fixed3\> !RANDOM \<random3\> G(\<ID\>) !THRESHOLD \<number of thresholds\>\
>SOLVING \
>[!THRMAXIT \<maximum number of NR or EM iterations at outer level\>]
>[!THRMAXPCG \<maximum number of iterations at inner level\>] \
>[!THRMETHOD \<EM or NR\>] \
>[!THRFIXED \<filename\>]

Qualifiers:

**!CONVERTCAT**\
The qualifier !CONVERTCAT in the DATAFILE section is optional. It can be used to specify a file with category labels.

**!THRESHOLD**\
The option !THRESHOLD in the MODEL section is mandatory and specifies which trait is to be analysed with a threshold model.

**!THRMAXIT**\
The qualifier !THRMAXIT in the SOLVING section can be used to specify the maximum number of NR or EM iterations. The default number is 5,000.

**!THRMXPCG**\
The qualifier !THRMAXPCG in the solving section is optional and specifies the maximum number of iterations within each NR or EM iteration. The default number is 100.

**!THRMETHOD**\
The qualifier !THRMETHOD is optional and specifies the method to implement the threshold model. The default method is NR. The alternative method is EM.

**!THRFIXED**\
The qualifier !THRFIXED is optional and can be used to specify a file with fixed thresholds per trait.

#### 1.1.1. Associated files {#Stat45}

The standard output files are used for an analysis with a threshold model.
!#ENDIF
