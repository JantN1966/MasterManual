## 1. Control of analysis and output {#Cont01}

**This chapter describes the control part of the instruction file, which can be used to control the analysis and the output generated from the analysis.**

### 1.1. Control of the analysis {#Cont02}

#### 1.1.1. General {#Cont03}

Control of an iterative process like solving a linear system to estimate breeding values involves setting the convergence criterion and the maximum number of iterations, specifying whether
the run is a continuation or a new start and defining the starting values for a new evaluation. An more advanced option is to specify the type of preconditioner to be used for solving the
system. Generally, the default type of preconditioner is optimal. The default varies across models to specify genetic similarity between individuals.

#### 1.1.1. Syntax {#Cont04}
!#IF(HPB)!#ELSE
##### 1.1.1.1 Syntax when using MiX99 solver {#Cont05}
>SOLVING\
>[!MAXIT \<number of rounds\>]\
>[!STOPCRIT \<convergence criterion\>]\
>[!NOPEEK]\
>[!PEEKFIRST \<iteration number\>]\
>[!PEEKEVERY \<number of rounds\>]\
>[!PEEKKEEP]\
>[!RESTART]\
>[!GFROMDISK]\
>PRECON \<n, b, d\>\
>[!WITHINBL \<b, d\>]\
>[!ACROSSBL \<f, m, b, d\>]

Sections:

**SOLVING**
The SOLVING section is used to control the process and the output of the analysis.

**PRECON \<option\>**
The PRECON section can be used to change the type of preconditioner. Possible options are n (no
preconditioner), b (block-diagonal preconditioner) and d (diagonal preconditioner).

Qualifiers:

**!MAXIT \<number of iterations\>**
The optional !MAXIT qualifier in the SOLVING section can be used to set the maximum number of iterations to
be used. If !MAXIT is not specified, the default maximum number of iterations is 5,000.

**!STOPCRIT \<convergence criterion\>**
If the convergence criterion needs to be different from 1.0E-04, it can be set with the optional !STOPCRIT qualifier in the SOLVING section.

**!NOPEEK**
!#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF stores intermediate results by default every 100th iteration. All solutions files are created and starting values for a restart are stored as if solutions have converged. By default, only the last set of preliminary results is kept. The name of each of the file is the normal file name extended with _PEEK, so for example Solani_PEEK.txt and solunf_PEEK. The last set of preliminary results will be removed when convergence has been attained or the maximum number of iterations reached The process of storing preliminary results can be avoided by specifying !NOPEEK.

**!PEEKFIRST \<iteration number\>**
The iteration number at which the preliminary results are stored for the first time can be specified with !PEEKFIRST.

**!PEEKEVERY \<number of iterations\>**
The number of iterations between storing two subsequent sets of preliminary results can be specified with !PEEKEVERY.

**!PEEKKEEP**
Instead of only keeping the last set of preliminary results, !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF can also retain each set of preliminary results. In this case, the name of each file is the normal file name extended with the iteration number, so for example Solani_100.txt and solunf_100.txt. This option can be specified with !PEEKKEEP. This option is useful for investigating the causes of unexpected convergence behaviour.

**!RESTART**
The optional qualifier !RESTART can be used to specify that preliminary solutions of an interrupted analysis or old solutions of the previous analysis are to be used as starting values for the new evaluation. This option links old solutions to class effect levels using the coded labels.

**!GFROMDISK**
The !GFROMDISK qualifier instructs the solver to read the inverse genomic relationship matrix from disk during solving. This was the only option in older versions of !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF. The new default is to keep this matrix in memory, which is more demanding for memory requirement, but it saves the time to read this matrix every iteration.

**!WITHINBL \<option\>**
The optional qualifier !WITHINBL is used in the PRECON section and can be used to use a different preconditioner for the within-block effects than the default preconditioner type. Valid options are b (block-diagonal) and d (diagonal).

**!ACROSSBL \<option\>**
The optional qualifier !ACROSSBL is used in the PRECON section and can be used to use a different preconditioner for the across-block effects than the default preconditioner type. Valid options are f (full), m (mixed), b (block-diagonal) and d (diagonal).!#ENDIF

!#IF(M99)!#ELSE
##### 1.1.1.1 Syntax when using hpblup solver {#Cont06}
>SOLVING\
>[!hpblup]\
>[!hpCriterion \<type of convergence criterion\>]\
>[!NumProc \<number of cpu\>]\
>[!MAXIT \<number of rounds\>]\
>[!STOPCRIT \<convergence criterion\>]\
>[!STARTVAL_CHECK]\
>[!MIRACULIX]\
>[!MIRACULIX_GPU]\
>[!NOPEEK]\
>[!PEEKFIRST \<iteration number\>]\
>[!PEEKEVERY \<number of rounds\>]\
>[!PEEKKEEP]

!#ENDIF
!#IF(HPB)
Sections:

**SOLVING**
The SOLVING section is used to control the process and the output of the analysis.
!#ENDIF
!#IF(M99)!#ELSE
Additional qualifiers:

**!hpblup**
This qualifier is used to trigger MiXBLUP to call the hpblup solver instead of the default MiX99 solver

**!hpCriterion**
This qualifier is used to specify the convergence criterion to be used, ck, cr or cd (default).

**!STARTVAL_CHECK**
The optional qualifier !STARTVAL_CHECK only applies to the hpblup solver and links old solutions to class effect levels using the original class effect labels. Compared to the !RESTART option, the !STARTVAL_CHECK option will do an extra step of decoding class effect levels of old solutions and re-coding them given the new set of data. The !RESTART option can be used for the hpblup solver, but old solutions will be linked to incorrect class effect levels if any previously used class effect levels with a solution are no longer present. In that case, solutions are still correct, provided that they have converged, but it takes more iterations to obtain them than using the correct old solutions as starting values.

**!NumProc <number>**
This qualifier is optional and can be used to specify the number of cpus to be allocated to hpblup. This number
has to be equal to or lower than number available for the evaluation.!#ENDIF
!#IF(MiX)
For the meaning of the other qualifiers, see previous chapter.
!#ELIF(HPB)
Qualifiers:

**!MAXIT \<number of iterations\>**
The optional !MAXIT qualifier in the SOLVING section can be used to set the maximum number of iterations to
be used. If !MAXIT is not specified, the default maximum number of iterations is 5,000.

**!STOPCRIT \<convergence criterion\>**
If the convergence criterion needs to be different from 1.0E-04, it can be set with the optional !STOPCRIT qualifier in the SOLVING section.

**!MIRACULIX**
This qualifier is used to specify that the solver should use Miraculix for multiplication of the genotype matrix.

**!MIRACULIX_GPU**
This qualifier is used to specify that the solver should use Miraculix in a graphics processing unit (gpu) for multiplication of the genotype matrix. This qualifier only works if an NVIDIA gpu is available and configured, and CUDA libraries are installed. 

**!NOPEEK**
MiXBLUP stores intermediate results by default every 100th iteration. All solutions files are created and starting values for a restart are stored as if solutions have converged. By default, only the last set of preliminary results is kept. The name of each of the file is the normal file name extended with _PEEK, so for example Solani_PEEK.txt and solunf_PEEK. The last set of preliminary results will be removed when convergence has been attained or the maximum number of iterations reached The process of storing preliminary results can be avoided by specifying !NOPEEK.

**!PEEKFIRST \<iteration number\>**
The iteration number at which the preliminary results are stored for the first time can be specified with !PEEKFIRST.

**!PEEKEVERY \<number of iterations\>**
The number of iterations between storing two subsequent sets of preliminary results can be specified with !PEEKEVERY.

**!PEEKKEEP**
Instead of only keeping the last set of preliminary results, MiXBLUP can also retain each set of preliminary results. In this case, the name of each file is the normal file name extended with the iteration number, so for example Solani_100.txt and solunf_100.txt. This option can be specified with !PEEKKEEP. This option is useful for investigating the causes of unexpected convergence behaviour.
!#ENDIF

### 1.1. Control of output {#Cont07}

#### 1.1.1. General {#Cont08}

A successful analysis produces at least a log file and files with solutions to all effects in the model. In some cases, additional results may be required for development or evaluation purposes. Various options are available to specify these additional files when required.

#### 1.1.1. Syntax {#Cont09}

!#IF(HPB)!#ELSE
##### 1.1.1.1. Syntax when using MiX99 solver {#Cont10}
>SOLVING \
>[!BASEANIMALSZERO \<filename\>]\
>[!YHAT]\
>[!EHAT]\
>[!YIELDDEV]\
>[!IDD]\
>[!DYD]\
>[!KEEPTMP]\
>[!SELINDEX \<filename\>]\
>[!FILTER \<label>]\
>TMPDIR \<work directory\>

Sections:

**TMPDIR**
The TMPDIR section can be used to specify an existing folder to store the temporary files of the kernel.

Qualifiers:

**!BASEANIMALSZERO \<filename\>**
The estimated breeding values of each individual in Solani.txt or Solani.out can be presented as a deviation of a genetic base, which is the average of a specified group of individuals, which are referred to as base animals. The ID of the base animals should be given in the specified file, or in BaseAnimals.dat. The file should contain one ID per row. The average per trait of the group of base animals is included in the log file MiXBLUP.log. If not all individuals are present in the data file, then a warning is given in the log file MiXBLUP.log. The specified file BaseAnimals.dat should contain the original IDs as they appear in the pedigree file.

**!YHAT**
The optional qualifier !YHAT creates a prediction for each observed trait and each animal in the data file. The predictions are stored in Yhat.txt, which is a text file that contains the animal ID in the first column and predicted observations for each trait in the model in subsequent columns. Missing observations in the data file get the code -8192.0 in the file with predictions.

**!EHAT**
The optional qualifier !EHAT stores the residual term of each observed trait and each animal in the data file. The residuals are stored in Ehat.txt, which is in text format and contains the animal ID in the first column and residuals for each trait in the model in subsequent columns. Missing observations in the data file get the code -8192.0 in the file with residuals.

**!YIELDDEV**
The optional qualifier !YIELDDEV stores the observation corrected for fixed effects and non-genetic random effects for each observed trait and animal in the data file. The yield deviations are stored in YD.txt, which is in text format and contains the animal ID in the first column and yield deviations for each trait in the model in subsequent columns. Missing observations in the data file get the code -8192.0 in the output file.

**!IDD**
The optional qualifier !IDD (“individual daughter deviation”) stores the yield deviation corrected for the genetic contribution of the dam for each observed trait and animal in the data file. The individual sire progeny deviations are stored in IDD.txt, which is in text format and contains the animal ID in the first column and yield deviations for each trait in the model in subsequent columns. Missing observations in the data file get the code -8192.0 in the output file.

**!DYD**
The optional qualifier !DYD (“daughter yield deviation”) stores the individual yield deviations averaged by sire. The daughter yield deviations are stored in soldyd.txt, a text file that contains sire in the first column, the number of progeny included in the progeny yield deviation in the fourth column, the progeny yield deviations by trait followed by the same number of fields to indicate whether the progeny yield deviation of the corresponding trait is valid (value is 1) or not (value is 0).

**!KEEPTMP**
The optional qualifier !KEEPTMP can be used to stop the removal of temporary files at the end of an analysis, for example to check for possible errors. The default is that all large temporary files are deleted as soon as they are no longer required.

**!SELINDEX \<filename\>**
The qualifier !SELINDEX can be used to automatically calculate a selection index value as the sum of weighted genetic solutions (weighted EBV). The selection index value is added as an additional column in the Solani output
file. The file specified after the qualifier contains the selection index weighting factor for each combination of genetic effect and trait in the model. The syntax is \<trait\>(\<genetic effect\>) \<selection index weighting factor\>, for example: phen1(animal) 1.0.

**!FILTER \<label\>**
The qualifier !FILTER can be used to automatically prune the Solani output file. It can be used to include or exclude individuals from the solutions file. The pedigree file should contain a field either with the text \<label\> or something else. To exclude individuals marked with 'dead', use !FILTER <>dead. To include individuals born in 2025 only, use !FILTER 2025.!#ENDIF

##### 1.1.1.1. Syntax when using hpblup solver {#Cont11}
>SOLVING\
>[!BASEANIMALSZERO \<filename\>]\
>[!YHAT]\
>[!EHAT]\
>[!YIELDDEV]\
>[!KEEPTMP]\
>[!SELINDEX <filename>]\
>[!FILTER \<label>]\
>TMPDIR \<work directory\>

!#IF(HPB)
Sections:

**TMPDIR**
The TMPDIR section can be used to specify an existing folder to store the temporary files of the kernel.

Qualifiers:

**!BASEANIMALSZERO \<filename\>**
The estimated breeding values of each individual in Solani.txt or Solani.out can be presented as a deviation of a genetic base, which is the average of a specified group of individuals, which are referred to as base animals. The ID of the base animals should be given in the specified file, or in BaseAnimals.dat. The file should contain one ID per row. The average per trait of the group of base animals is included in the log file MiXBLUP.log. If not all individuals are present in the data file, then a warning is given in the log file MiXBLUP.log. The specified file BaseAnimals.dat should contain the original IDs as they appear in the pedigree file.

**!YHAT**
The optional qualifier !YHAT creates a prediction for each observed trait and each animal in the data file. The predictions are stored in Yhat.txt, which is a text file that contains the animal ID in the first column and predicted observations for each trait in the model in subsequent columns. Missing observations in the data file get the code -8192.0 in the file with predictions.

**!EHAT**
The optional qualifier !EHAT stores the residual term of each observed trait and each animal in the data file. The residuals are stored in Ehat.txt, which is in text format and contains the animal ID in the first column and residuals for each trait in the model in subsequent columns. Missing observations in the data file get the code -8192.0 in the file with residuals.

**!YIELDDEV**
The optional qualifier !YIELDDEV stores the observation corrected for fixed effects and non-genetic random effects for each observed trait and animal in the data file. The yield deviations are stored in YD.txt, which is in text format and contains the animal ID in the first column and yield deviations for each trait in the model in subsequent columns. Missing observations in the data file get the code -8192.0 in the output file.

**!KEEPTMP**
The optional qualifier !KEEPTMP can be used to stop the removal of temporary files at the end of an analysis, for example to check for possible errors. The default is that all large temporary files are deleted as soon as they are no longer required.

**!SELINDEX \<filename\>**
The qualifier !SELINDEX can be used to automatically calculate a selection index value as the sum of weighted genetic solutions (weighted EBV). The selection index value is added as an additional column in the Solani output
file. The file specified after the qualifier contains the selection index weighting factor for each combination of genetic effect and trait in the model. The syntax is \<trait\>(\<genetic effect\>) \<selection index weighting factor\>, for example: phen1(animal) 1.0.

**!FILTER \<label\>**
The qualifier !FILTER can be used to automatically prune the Solani output file. It can be used to include or exclude individuals from the solutions file. The pedigree file should contain a field either with the text \<label\> or something else. To exclude individuals marked with 'dead', use !FILTER <>dead. To include individuals born in 2025 only, use !FILTER 2025.!#ENDIF
