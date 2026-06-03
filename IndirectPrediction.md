!#IF(M99)!#ELSE
## 1. Indirect prediction {#Indi01}

For an individual that is genotyped, but does not have a phenotype or progeny with a phenotype yet, each genomic estimated breeding value (GEBV) is just a function of SNP marker genotypes, SNP marker effects and the average polygenic estimated breeding value of its parents. There is limited benefit of solving equations for these animals iteratively. These GEBV can be predicted indirectly as a separate step after the routine genetic evaluation.

### 1.1. General {#Indi02}

In some breeding programs, there is a constant influx of newly genotyped young individuals, but there are only a limited number of routine genetic evaluations in a year. Indirect prediction of their GEBV avoids having to run the full genetic evaluation multiple times. In other breeding programs, there may be a large number of genotyped individuals that will never have a phenotype or progeny with a phenotype. Using indirect prediction for these individuals reduces the size of the genetic evaluation and saves computing time and resources.
Indirect prediction is a feature of the hpblup solver.

### 1.1. Indirectly predicting genomic estimated breeding values {#Indi03}

#### 1.1.1 General {#Indi04}

If indirect prediction is used to predict GEBV of individuals without phenotypes or progeny with phenotypes, then these individuals are not included in the routine genetic evaluation. After the routine genetic evaluation is completed, the user provides a pedigree file and a genotype file that contain individuals in the evaluation and individuals excluded from the routine genetic evaluation. MiXBLUP identifies the latter group of individuals in the pedigree and genotype file and predicts GEBV for these individuals indirectly.

#### 1.1.1 Supported evaluations {#Indi05}

Indirectly predicting GEBV is only supported when using the hpblup solver and either ssSNPBLUP or ssGBLUP applying the Ta or Tac decomposition of G. MiXBLUP will verify that the routine genetic evaluation is suitable for indirect prediction. If the routine genetic evaluation is unsuitable, it will result in a fatal error.

#### 1.1.1 Syntax {#Indi06}
The recommended syntax for calling MiXBLUP for indirect prediction is:

>MiXBLUP pred -p \<pedigree file\> -g \<genotype file\>

The old syntax is still supported:

>MiXPred.exe -p \<pedigree file\> -g \<genotype file\>

#### 1.1.1 Output files {#Indi07}

The file with the solutions of the routine genetic evaluation is renamed to Solani_old.out. The solutions of routine genetic evaluation and those of indirect prediction are written to Solani.out.
!#ENDIF
