## 1. Validation studies with MiXBLUP {#Vali01}

Estimated breeding values (EBV) are used to identify the best individuals to become the parents of the next generation. The implicit assumption is that EBV are a reasonable prediction of performance of future progeny. BLUP evaluations to estimate breeding values often span many generations. Statistical model and components of variance and covariance among traits may have been suitable for earlier generations, but to what extent do EBV of the current generation predict the performance of progeny well? This is explored in validation studies.

### 1.1	General {#Vali02}

It is good management practice to do validation studies regularly. In practice, validation studies are quite cumbersome to do, involve a lot of manual work and are prone to making mistakes. This makes it difficult to compare results between validation studies.
MiXValidate has been designed to facilitate validation studies that are easy to do and transparent to interpret. MiXValidate creates a partial dataset given the validation individuals and the genetic effect to validate. It verifies that the list of validation individuals does not contain multiple generations. It estimates breeding values for the partial dataset and for the full dataset. It calculates validation statistics that are well-defined. Finally, it displays the amount of information that is available for validating the EBV and it leaves out validation individuals that do not have sufficient data available for validation.

### 1.1. Validation individuals {#Vali03}

MiXValidate supports two types of validation studies. Parent validation focuses on how well parent EBV predict progeny performance. Individual validation checks how well EBV predict future performance of the individual itself. Parent validation can be done for either sires or dams. The user provides a file with validation individuals. This is a text file with just a list of original IDs, one ID per line.
Validation individuals have to be from a single generation. MiXValidate gives a warning if more than one generation of a family is present among the validation individuals. The youngest individual from such a family will have more data removed for validation than other validation individuals, thus affecting the validation statistics.

### 1.1. Validation effect {#Vali04}

There are traits that are affected by the genotype of other individuals, in addition to the genotype of the individual itself. For example, daily gain of piglets in the first weeks of their life is also determined by the genotype of the dam. Social behavior of pen mates affects the growth of individuals, in addition to their own genotype. These are referred to as indirect genetic effects and direct genetic effects, respectively.
The process of creating the partial dataset is completely dependent on which genetic effect needs to be validated. Data records are omitted based on the field in the data file with the validation effect. A trait with a statistical model with direct and indirect genetic effects therefore needs two separate MiXValidate analyses for validation: one for the direct genetic effect as validation effect and one for the indirect genetic effect as validation effect.

### 1.1. Creating partial dataset {#Vali05}
The idea behind creating the partial dataset is to create a dataset that reflects the situation at the point of selection for breeding or further testing. Any performance records on relatives collected after selection of the individual should be removed. The common practice to use a specific date after which all data records are omitted, only works well in the case of non-overlapping generations.
With individual validation, MiXValidate removes data records of validation individuals and their siblings, and of descendants of these two groups. With parent validation, MiXValidate removes data records of progeny of validation individuals, descendants of this progeny and descendants of siblings of validation individuals. If the user specifies to remove data records of validation individuals, then these will be removed, as well as data records of siblings of validation individuals. The above can be applied to any genetic effect as validation effect (Table 1).

**Table 1.** Type of data records and type of removal in partial dataset

|Validation Effect	| Direct | Direct | Maternal | Maternal | Maternal | Maternal|
| --- | --- | --- | --- | --- | --- | --- |
|**Validation Type** | **Parent** | **Individual** | **Parent** | **Parent** | **Individual** | **Individual**|
|**Data field** | **Direct** | **Direct** | **Maternal** | **Direct** | **Maternal** | **Direct**|
|Validation Individual | X1 | X2 | X1 | - | X2 | -|
|Siblings^a^ | X1 | X3 | X1 | - | X3 | -|
|Progeny^b^ | X2 | X3 | X2 | X3 | X3 | X3|
|Descendants^c^ | X3 | X3 | X3 | X3 | X3 | X3|

^a^ Siblings of validation individuals\
^b^ Progeny of validation individuals\
^c^ Descendants of progeny or siblings of validation individuals\
X1 data records are removed if !ValNoOwnPerf is specified\
X2 data records are removed and removed records are used for validation statistics\
X3 data records are removed and removed records are not used for validation statistics

Data records of descendants are removed to allow the user to do validation studies retrospectively, so in any generation before the current generation. Descendants are not included in the validation statistics.
The user can also specify a list of individuals for which all data records should be removed. MiXValidate will not remove any additional records in the partial data. It can be used for example to use a fixed date by adding all individuals with a data record after the date to the remove list.

### 1.1. Types of validation {#Vali06}
MiXValidate presents validation statistics of two types of forward validation: LR method (Legarra and Reverter, 2018) and adjusted-phenotype validation (Mäntysaari et al., 2010).  The LR method compares solutions of validation individuals from evaluation of the partial data with the corresponding solutions from evaluation of the full data. Adjusted-phenotype validation compares solutions of validation individuals from evaluation of the partial data with omitted adjusted phenotypes. Adjusted-phenotype validation is implemented for direct genetic effects only, for now.

### 1.1. Command-line syntax {#Vali07}
The recommended way to call MiXBLUP for a validation study is:
>MiXBLUP val -i \<instruction file\>

The old syntax is now deprecated but still supported:
>MiXValidate.exe \<instruction file\>

### 1.1. Syntax {#Vali08}
Starting point for the instruction file for MiXValidate is the MiXBLUP instruction file of the routine evaluation. A new section VALIDATION needs to be added and the qualifiers !YieldDev and !HeritabFile need to be added to the SOLVING section.

>SOLVING\
>[...]\
>!YieldDev\
>!HeritabFile \<name of file with heritability per trait\>\
>VALIDATION\
>!ValList \<name of file with validation individuals\>\
>[!ValEffect \<field name genetic effect to validate\>]\
>[!ValParent \<sire | dam\>]\
>[!ValNoOwnPerf]\
>[!ValRemoveList \<name of file with individuals to remove in partial data\>]\
>[!ValMinRec \<n\>]\
>[!ValSolutions \<solutions file\>]

Qualifiers:

**!ValList \<name file\>**
The !ValList qualifier is mandatory and specifies the name of the file with validation individuals. The file contains a record for each validation individual with only the ID of the individual.

**!ValEffect \<validation effect name\>**
The !ValEffect qualifier is optional and specifies the genetic effect to validate. Default is  the direct genetic effect.

**!ValParent \<sire | dam\>**
The !ValParent qualifier is optional and specifies that parent validation will be used and for which parent. If the !ValParent qualifier is omitted, then individual validation will be used. If the !ValParent qualifier is used without a setting, then sire validation will be used.

**!ValNoOwnPerf**
 The !ValNoOwnPerf qualifier is optional and only has a meaning in the context of parent validation. It specifies that data records of validation individuals and their siblings will also be removed in the partial data.

**!ValRemoveList \<file with individuals to remove in partial data\>**
The !ValRemoveList qualifier is optional and causes MiXValidate to remove ONLY data records of the individuals in the specified file, so no additional data records are removed.

**!ValMinRec \<n\>**
The qualifier !ValMinRec is optional and specifies the minimum number of data records available for a validation individual to be included in the validation statistics. This minimum number applies to own performance in case of individual validation and progeny records in case of parent validation. Records of other descendants and siblings of validation individuals and their descendants do not count towards this minimum number. The default minimum number is 1.

**!ValSolutions \<name file\>**
The qualifier !ValSolutions is optional and specifies the solutions file to use for validation. !ValSolutions is not needed in most cases, but it can be used to validate an index of all EBV in the evaluation, for example. The default is the default MiXBLUP file with genetic effect solutions (Solani.out or Solani.txt).

**!YieldDev**
The qualifier !YieldDev is mandatory to enable adjusted-phenotype validation.

**!HeritabFile \<file with direct heritability per trait\>**
The qualifier !HeritabFile is required for adjusted-phenotype validation to get realized prediction accuracies. The file contains a line for each trait. A line consists of trait name (case-sensitive) and direct heritability.

### 1.1. Validation statistics {#Vali09}
Validation statistics can be found in MiXBLUP.log.
The first table gives an overview of the amount of data available for validation. The example (Figure X.1) is taken from a parent validation study, using dams, of a maternal genetic effect that was only fitted for trait1.

![](https://raw.githubusercontent.com/JantN1966/MasterManual/main/Images/ValStud01.jpg)

**Figure 1.** Overview of data available for validation of a maternal genetic effect

|label | Field name of trait as specified in MiXValidate instruction file|
| --- | --- |
|N | Number of validation individuals|
|nExcl| Number of validation individuals excluded from calculation of validation statistics because of insufficient number of data records|
|nMin | Lowest number of data records for a validation individual|
|nMax | Highest number of data records for a validation individual|
|Avg | Average number of data records per validation individual|

For individual validation, the number of data records is always on the individual itself only. For parent validation, it is the number of data records across progeny.
In the example, validation individuals consisted of all dams in a generation. Of the 800 dams, 800 – 286 = 514 individuals had progeny appearing in the maternal genetic effect field of a data record, so progeny that were a dam, too. The number of data record per validation individual varied from 0 to 72 with an average of 12.
A validation study using the same validation individuals and the same data records, but for the direct genetic effect gives a different table (Figure 2).

![](https://raw.githubusercontent.com/JantN1966/MasterManual/main/Images/ValStud02.jpg)

**Figure 2.** Overview of data available for validation of a direct genetic effect
Validation statistics are presented in two or three tables, depending on the validation effect. The first table shows LR validation statistics only for included validation individuals. The last table show LR validation statistics for all validation individuals (Figure 3 and Figure 4).

![](https://raw.githubusercontent.com/JantN1966/MasterManual/main/Images/ValStud03.jpg)

**Figure 3.** Validation statistics for a maternal genetic effect
The explanation of columns in these tables is as follows.

|Solution | Combination of validation effect and trait name|
| --- | --- |
|n | Number of validation individuals included in calculations|
|intercept | Intercept of regressing solutions from full data (W) on solutions of partial data (P)|
|slope W on P | Slope of regressing solutions from full data (W) on solutions of partial data (P)|
|correlation | Pearson correlation between solutions from full data and solutions of partial data|
|level bias | Average of solutions from full data minus average of solutions from partial data|
|pred accuracy | Covariance between solutions from full data and solutions of partial data divided by genetic standard deviation among validation individuals.

 The genetic standard deviation among validation individuals is estimated as the square root of (1-F~VI~)\*var~A~, with F~VI~ the average inbreeding coefficient among validation animals and var~A~ the additive genetic variance that applies to the combination of validation effect and trait.

For validation studies of a direct genetic effect, the second table shows the adjusted-phenotype validation statistics (Figure 4).


![](https://raw.githubusercontent.com/JantN1966/MasterManual/main/Images/ValStud04.jpg)

**Figure 4.** Validation statistics for a direct genetic effect
The explanation of columns in the second table is as follows.
|Solution | Combination of validation effect and trait name|
| --- | --- |
|n | Number of validation individuals included in calculations|
|intercept | Intercept of weighted regression of adjusted phenotypes from full data (W) on solutions of partial data (P)|
|slope W on P | Slope of weighted regression of adjusted phenotypes from full data (W) on solutions of partial data (P)|
|correlation | Weighted Pearson correlation between adjusted phenotypes from full data and solutions of partial data|
|level bias | Average of adjusted phenotypes from full data minus average of solutions from partial data|
|pred accuracy | Weighted correlation between adjusted phenotypes from full data and solutions of partial data divided by the expected prediction accuracy. |

The expected prediction accuracy is calculated as the square root of N~prog~ * h^2^ /(N~prog~ \* h^2^ + 4 – h^2^) for parent validation or the square root of h^2^ for individual validation, where N~prog~ is the average number of progeny records and h~2~ is the heritability of the combination of validation effect and trait, read from the file specified with !HeritabFile.

Adjusted phenotypes are obtained from the evaluation of the full data set and are the sum of genetic effects and the residual effect.
The expectation of intercept and level bias is zero for LR validation if a suitable genetic base is used. A suitable genetic base consists of a number of high-reliability males at least two generation before the validation individuals. This can be done with !BaseAnimalsZero \<file\> in the SOLVING section.
The expectation for slope is 1.0 for LR validation. For adjusted-phenotype validation, it is 0.5 for parent validation and 1.0 for individual validation.
The realized prediction accuracy is an estimate of the average accuracy of estimated breeding values of validation individuals from the partial data. Note that this different from the calculated accuracy of estimated breeding values from the inverse coefficient matrix or approximations thereof (!Reliability). The latter is a relative measure of the amount of information available to estimate the breeding value assuming that the model and variance components are appropriate and that there is no confounding of effects.
Note that this evaluation is based on the assumption that the accuracy (or reliability) of the EBV of validation individuals from the partial dataset is non-zero and more or less the same across validation animals. The realized prediction accuracy is an estimate of the average of this accuracy across validation individuals. It is advised not to include individuals with a much lower accuracy of the partial EBV in the group of validation individuals. Avoid parent-offspring pairs among the validation individuals for this reason.

### 1.1. ASSOCIATED OUTPUT FILES {#Vali10}
|Output file |Description|
|--- | --- |
|MiXBLUP.log | Contains the summary tables of validation statistics|
|LogValidationData.txt | For each validation individual by trait: number of data records, EBV partial & EBV whole|

