!#IF(M99)!#ELSE
## 1. Multi-trait genome-wide association studies (GWAS)

**A Genome-Wide Association Study (GWAS) is an approach that examines the entire genome to identify genetic variations associated with a particular complex trait of interest. It involves scanning the genomes of many individuals to find genetic differences, typically single nucleotide polymorphisms (SNPs), that occur more frequently in individuals with a specific complex trait of interest. By identifying these associated genetic variants, breeders can gain insights into the underlying biology of the complex trait of interest.**

### 1.1. General

Genome-wide association study (GWAS) is a common tool in genetic research for identifying loci associated with complex traits. However, the increasing availability of single nucleotide polymorphism (SNP) genotypes and whole-genome sequencing (WGS) data presents significant computational challenges due to the large number of individuals and SNPs. Traditional mixed linear model association (mlma) analyses, as implemented in for example the software GCTA, while considered the gold standard, are computationally intensive.
For limited datasets, such as those with a single trait of interest and up to 40,000 genotyped individuals, MiXBLUP (Chapter 10.2) can be used to obtain frequentist p-values needed for GWAS using a single-step genomic BLUP. The implemented approach is only feasible for a single trait and up to 40,000 genotyped individuals.
The computational limitations are removed by using an approximate GWAS based on the solutions of single-step SNP best linear unbiased prediction (ssSNPBLUP) or single-step genomic BLUP using a component-wise Ta decomposition of the inverse of G (ssGTacBLUP). The approximate GWAS approach implemented in MiXBLUP (Chapter 10.3) includes two steps. First, SNP effects are estimated by solving ssSNPBLUP with a preconditioned conjugate gradient method. Second, prediction error variances for all SNP effects, needed for computing frequentist p-values, are approximated by the diagonal elements of the inverse of the coefficient matrix of a SNPBLUP model. For efficiency, a sliding-window approach is used assuming that linkage disequilibrium between SNPs that are more than 50,000 SNPs apart is zero, resulting in multiple inversions of coefficient matrices of size equal to 50,000, instead of one single inversion of a matrix encompassing all SNPs.

### 1.1. Computation of frequentist p-values for limited datasets

#### 1.1.1. General

For limited datasets, such as those with a single trait of interest and up to 40,000 genotyped individuals, MiXBLUP can be used to obtain frequentist p-values  needed for GWAS using a single-step genomic BLUP. The implemented approach requires computation of the inverse of the coefficient matrix of the evaluation, which limits its application to a single trait and up to 40,000 genotyped individuals.

#### 1.1.1. Syntax for calculating frequentist p-values
>ERMFILE \<genotype file\> !Construct SSmat !SingleStep !METHOD VanRaden !NoScale !NoReg\
>\<...\>\
>SOLVING\
>!hpblup\
>!pvalue_exact

Qualifier:

**!pvalue_exact**
The qualifier !pvalue_exact is used to specify the calculation of frequentist p-values through full inversion of the coefficient matrix of ssGBLUP.
For calculating frequentist p-values with a single-step genomic evaluation, it is recommended to use a genomic relationship matrix computed following the first approach of VanRaden (2028) (!METHOD VanRaden) together with the !NoScale and !NoReg options. This option is only available with the solver hpblup.

#### 1.1.1. Associated output files
Frequentist p-values are saved in a file called Pvalue.out. The format of the file is the same as the one of Relani.out. The order of the frequentist p-values follow the order of the SNPs in the genotype file.

#### 1.1.1. Example  (move to appendix later)
>TITLE GWAS for Trait1\
>DATAFILE Data.txt !MISSING -9\
> fixeff1 I\
> ID1 I\
> trait1 T\
>ERMFILE Genotype.bed !Plink !CONSTRUCT SSmat\
> ID1 I\
> !SingleStep\
> !LAMBDA 1.0\
> !ALPHA 0.95\
> !BETA 0.05\
> !OMEGA 1.0\
> !MAF 0.005\
> !NOSCALE\
> !NOREG\
> !METHOD VanRaden\
>PEDFILE Pedigree.txt !CalcInbr\
> ID1  I\
> sire I\
> dam I\
>PARFILE ../para.var\
>MODEL\
>trait1 ~ fixeff1 !RANDOM G(ID1)\
>SOLVING\
> !hpblup\
> !pvalue_exact\
>END

### 1.1. Approximation of frequentist p-values for large-scale datasets
#### 1.1.1. General
The approximate GWAS approach implemented in MiXBLUP includes two steps.
First, SNP effects are estimated by solving ssSNPBLUP or ssGTAcBLUP with a preconditioned conjugate gradient method. See Chapter X for more details on how to run a ssSNPBLUP or ssGTAcBLUP evaluation with MiXBLUP.
Second, prediction error variances for all SNP effects, needed for computing frequentist p-values, are approximated by the diagonal elements of the inverse of the coefficient matrix of a SNPBLUP model. For efficiency, a sliding-window approach is used assuming linkage disequilibrium between SNPs more than 50,000 SNPs apart is zero, resulting in multiple inversions of coefficient matrices of size equal to 50,000, instead of one single inversion of a matrix encompassing all SNPs.
This approach allows MiXBLUP to approximate frequentist p-values for large-scale multi-trait single-step genomic evaluations.

#### 1.1.1. Syntax for calculating frequentist p-values
>ERMFILE \<genotype file\> !Construct SSmat !SingleStep !Tac\
>\<...\>\
>SOLVING\
>!hpblup\
>!gwas \<file with SNP effect solutions\> \<SNP effect ID\>

Or

>SNPFILE \<genotype file\> !NoPrune !NoCheck\
>\<...\>\
>SOLVING\
>!hpblup\
>!gwas \<file with SNP effect solutions\> \<SNP effect ID\>

Qualifier: 

**!gwas  <field name Solgreg_mat file>  <field name SNP effect ID>**
The qualifier !gwas is used to approximate frequentist p-values for large-scale datasets. The first field corresponds to the file with estimated SNP effects obtained from a previous ssSNPBLUP or ssGTAcBLUP evaluation. This file is called Solreg_mat.txt. The second field corresponds to the first ID of the SNP effect.
The approximation of frequentist p-values for large-scale datasets relies on the approximation of genomic reliabilities (Chapter 9). Therefore, approximating frequentist p-values requires an instruction file for approximating genomic reliabilities, with the qualifier !gwas (instead of !greliability) in the SOLVING section.

SNP effect solutions are stored in Solreg_mat.txt, both for ssGBLUP, using a Ta or Tac decomposition of G, and ssSNPBLUP. /<SNP effect ID/> is the hpblup EFFECT_ID of the SNP effect, which can be found in the hpblup instruction file hpInstr.txt.

#### 1.1.1. Associated output files
Approximate p-values are saved in a file called Pvalue_approx.out. The format of the file is the same as the one of Relani.out. The order of the approximate p-values follows the order of the SNPs in the genotype file. 

#### 1.1.1. Example (move to appendix later)
>TITLE Approximate GWAS for Trait1\
>DATAFILE data.txt !MISSING -9\
> fixeff1 I\
> blockid I !BLOCK\
> ID1 I\
> trait1 T\
>ERMFILE Genotype.bed !Plink !CONSTRUCT SSmat !SingleStep !NumProc 10\
> ID1 I\
> !LAMBDA 1.0\
> !ALPHA 0.95\
>PEDFILE pedigree.txt !CalcInbr\
> ID1  I\
> sire I\
> dam I\
> blockped I !BLOCK\
>PARFILE ../para.var\
>MODEL\
> trait1 ~ BL(fixeff1) !RANDOM G(ID1)\
>SOLVING\
> !gwas Solreg_mat.txt 3\
>END
!#ENDIF
