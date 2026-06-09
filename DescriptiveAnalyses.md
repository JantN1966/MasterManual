## 1. Descriptive analyses {#Desc01}

**To be able to configure a genetic evaluation appropriately, and interpret the results correctly, it is important to understand the data structure in detail. MiXBLUP provides tools to analyze and describe the data structure.**

### 1.1. General {#Desc02}

Optimal genetic and genomic evaluations require sufficient valid data records for each trait, sufficient genetic and genomic relationships in the data and sufficient information to fit the model chosen (Chapter [1.1.](#Desc03)). A more specific detail is whether the objective choice of base populations in the pedigree is sufficiently supported by the data (Chapter [1.1.](#Desc11)).

### 1.1. Descriptive statistics of performance data, genomic data and pedigree {#Desc03}

#### 1.1.1. General {#Desc04}

Aspects of data structure that are important to consider for optimal genetic evaluations are the amount of valid information per trait, amount of genetic and genomic relationships in the data, and amount of information available for the model fitted.

#### 1.1.1. Syntax {#Desc05}
>DATAFILE \<file name\> !Stats N [D H L]

Qualifier:

**!Stats**
The !Stats qualifier can be used to specify the calculation of descriptive statistics of the data structure. It can be used with either the default or the hpblup solver.
There are four types of statistics that can be produced: N for numbers of records in data, pedigree and genotype file (Chapter [1.1.1.](#Desc06)) ; D for means and standard deviations of traits and covariates in the data (Chapter [1.1.1.](#Desc07)); H for grouping class effect levels for each trait by the number of records per class (Chapter [1.1.1.](#Desc08)) and L for a table by trait with number of records for each class effect level (Chapter [1.1.1.](#Desc09)). For large evaluations, it is recommended to use !STATS NDH, as the option L might produce a very large output file. Types may be specified in any order. If D, H or L are specified, N is automatically included.

#### 1.1.1. Counts (option N) {#Desc06}

The counts option (option N) produces five tables. The first table shows the number of records in data, pedigree and genotype file. It provides some basic information on the amount of available information in the input files.
The second table presents a breakdown of the number of records per trait. It provides the number of data records, the number of individuals with a data record, the number of individuals with data and genotype, which is the size of the reference population of the trait, and the number of invalidated records. Invalidation may occur if model information is missing or if the observation is outside of the valid range.
The third table gives the number of levels of class effects in the model across traits. This may be useful for software that estimate variance components and require the number of level of each class effect upfront.
The fourth table shows pedigree completeness.
The fifth table provides some information on the use of base populations. See Chapter [1.1.](#Desc11) for more detailed information on the subjective choice of base populations.

#### 1.1.1. Means and standard deviations (option D) {#Desc07}

Means, standard deviations, and minimum and maximum values (option D) are presented in two tables, one for traits and one for covariates. If minimum or maximum values fall outside the valid range, then the qualifier !MinMax can be used to restrict the range in the data evaluated.

#### 1.1.1. Class effect levels grouped by available information (option H) {#Desc08}

For the amount of information available for class effect levels (option H), class effect levels are grouped by the number of records available (0, 1, 2, 3-5, 6-10, 11-20, 21-50, 51-100, 101-200, 201-500, more than 500). The number of class effect levels in each category is presented for each combination of class effect and trait. Many class effect levels with only few records for a trait results in inaccurate estimates and poor correction for systematic non-genetic factors. It may also increase the likelihood of confounding between effect levels of different class effects, which causes only the sum of the two effects to be estimable. Small class effect levels are more of a  problem for fixed effects than random effects, because variance of level effects and a correlation or genetic relationship structure between levels provide additional information and constraints for the latter.

#### 1.1.1. Valid data records for each combination of trait and class effect level (option L) {#Desc09}

It is also possible to print a table with all class effect levels for each combination of trait and class effect and the number of valid data records available (option L). It can be used to identify in which part of the data small class effect levels occur and which effect levels should be combined to achieve a larger number of data records per level. For large evaluations, the table and output file may become very large.

#### 1.1.1. Associated output files {#Desc10}
|Output file | Description|
| --- | --- |
|Statistics.log | Output file with tables for the options specified|

### 1.1. Diagnostics of use of base populations {#Desc11}

#### 1.1.1. General {#Desc12}

Any pedigree has individuals without known parents. In some cases it is reasonable to assume that individuals without known originate from the same large population, but in other cases there is prior knowledge that these individuals come from different populations. Multiple base populations are generally referred to as genetic groups or unknown parent groups. The assumptions are that these groups are infinitely large, so groups, and individuals within a group, are unrelated. Discarded pedigree information and genomic information of descendants may be used to take into account that base populations are finite in reality. Genetic groups with relationships within and between groups are referred to as metafounders (Legarra et al., 2015).
Allocation of individuals without known parents to a base population is a subjective process. The aim is to stay as close as possible to the true base population to minimize bias, but with sufficient individuals in each base population to minimize the mean squared error.
For metafounders, it is important that there is sufficient information to estimate relationships within and between base populations. MiXBLUP provides statistics of quantity, quality, and proximity of genomic information for base populations. Quantity of genomic information is expressed as equivalent number of base animals genotyped (Chapter [1.1.1.](#Desc13)). Quality of genomic information is expressed as auto-similarity with other base populations (Chapter [1.1.1.](#Desc14)). Proximity of genomic information is expressed as number of generations between pedigree and genomic base populations (Chapter [1.1.1.](#Desc15)).

#### 1.1.1. Equivalent number of base animals genotyped {#Desc13}

The first statistic quantifies the amount of genotype information available for each base population. For this purpose we define a genomic base population which consists of all genotyped animals with a path of non-genotyped ancestors to a base population. Genotyped animals that are descendants of two genotyped parents are not included as they do not provide genotype information to a base population (c equals 0.0). Imputation of non-genotyped animals from genotyped descendants only using pedigree relationships, causes loss of information, because the genotype information has to be distributed to two parents in every generation without genotypes. We therefore introduce equivalent number of base animals genotyped for a base population (Neq~i~). It is calculated as:

![](https://raw.githubusercontent.com/JantN1966/MasterManual/main/Images/DescStat01.jpg)

where N is the number of animals in the genomic base population, q~ij~ is the fraction relating the contribution of base population i to the total genetic value of the animal j, gener~j~ is the maximum number of generations between animal j and base population i, and c~i~j is the contribution of the genomic base animal j to base population i. So for example, a genotyped individual has one non-genotyped parent, hence c equals 0.50. The genotyped individual is linked to a specific base population only through one grandparent, hence q is 0.25.

#### 1.1.1. Auto-similarity to another base population {#Desc14}

The second statistic is the extent to which the same genotype information was used for a pair of base populations, which we call auto-similarity of one base population to another. To illustrate the concept, imagine 24 balls, 8 red, 8 blue and 8 orange. The balls are placed in two bowls, so the first bowl contains 5 red and 4 blue balls. The second contains the remaining 3 red, 4 blue and 8 orange. The similarity of bowl one to bowl two is 3 red + 4 blue over 9 balls is 0.78. The similarity of the second bowl to the first one is 3 red + 4 blue over 15 balls is 0.47. The colors in the illustration are genotyped animals and the bowls are base populations. So auto-similarity of base population i to j (AS~i to j~) is calculated as:

![](https://raw.githubusercontent.com/JantN1966/MasterManual/main/Images/DescStat02.jpg)

where q~ik~ and q~jk~ and c~ik~ are defined as q~ij~ and c~ij~ in Chapter [1.1.1.](#Desc13). An AS~i to j~ of 0 means that genotype information available to two base populations is independent. A value of 1 means that genotype information available is identical.

#### 1.1.1. Number of generations between pedigree and genomic base populations {#Desc15}

The third statistic is the weighted average number of generations between base animals in a base population and the genomic base population. It is calculated as:

![](https://raw.githubusercontent.com/JantN1966/MasterManual/main/Images/DescStat03.jpg)

where q~ij~, c~ij~ and gener~j~ are defined as above. delta~Gener~ differentiates between many remote genotyped descendants and fewer proximate ones for a given Neq.

#### 1.1.1. Syntax {#Desc16}
>PEDFILE \<file name\> !Groups 1.0 !DiagBasePop

Qualifier:
**!DiagBasePop**
The qualifier !DiagBasePop can be used to specify that additional statistics on the suitability of base populations for use as genetic groups or metafounders. The !DiagBasePop is currently only available for the hpblup solver.

#### 1.1.1. Associated output files {#Desc17}
|Output file | Description|
| --- | --- |
|DiagBasePop.log | Summary of diagnostics|
|DBP_DescriptiveStats.log | Descriptive statistics of base populations|
|DBP_EquivalentNrBaseIndiv.log | Equivalent number of genotyped individuals in base population |
|DBP_AutoSimilarity.log | Auto-similarity of each base population with other base populations|
|DBP_WeightedNrGenerations.log | Number of generations between pedigree and genomic base populations|

