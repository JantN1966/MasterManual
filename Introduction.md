## 1. Introduction\
!#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF has been developed for routine breeding value estimation in commercial genetic programmes and supports modern applications, such as random regression models, group selection, the use of 
genetic markers or haplotypes and the use of genomic information.\

### 1.1   Overview\
The intention of developing !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF was to utilize efficient computing strategies for solving mixed model equations. With !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF it is possible to use sophisticated models in estimation of breeding values !#IF(HPB)in plants and animals!#ELSEin animals, like cattle, pigs, poultry, sheep, horses, goats, dogs, and aquatic species!#ENDIF. The software also supports many ways to specify genetic similarity between individuals, including pedigree, marker information and genomic information. The statistical method used for genetic evaluation is best linear unbiased prediction (BLUP), which is currently the common methodology for genetic evaluation.\
!#IF(MiX)MiXBLUP supports two solvers.!#ENDIF !#IF(HPB)!#ELSEThe MiX99 solver has been developed for efficient use of disk space and memory. Due to iteration on data and a very fast algorithm in the solver (preconditioned conjugate gradient, PCG), it is able to solve mixed model equations very fast. It is derived from MiX99 and was initially developed for classical genetic evaluation without the use of markers or genes by LUKE National resources Institute Finland. The adaptation for the use of marker and genomic information was implemented by Wageningen UR Livestock Research in collaboration with LUKE.\!#ENDIF
!#IF(M99)!#ELSEThe hpblup solver has been developed specifically for efficient genetic evaluation using a very large amount of genomic information. It is !#IF(MiX)also !#ENDIFbased on a PCG algorithm, but genomic information is stored in memory during solving and it uses multiple cores whenever beneficial.\

### 1.1   Manual\
This manual will guide the user through the use of !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF. The examples provide a way to test the software, to get a feel for the software. A set of examples is provided as an Appendix to the manual. The number of the example refers to the corresponding chapter of this manual.\
A schematic overview of the input files, output files and instruction file is in Figure 1.\

![_Figure 1._ Schematic overview of the input and output files of !#IF(HPB)HPBLUP\!#ELSEMiXBLUP\!#ENDIF.](C:\Users\napel002\source\git_repositories\MasterManual\Images\IntroductionFigure1.jpg)\

### 1.1   System requirements\
!#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF is written in standard Fortran 90 language and is self-contained. The program runs in !#IF(HPB)!#ELSEWindows,!#ENDIF Linux and Unix environments and is available in 64-bit version. !#IF(HPB)!#ELSEIn Windows, it runs in the command-line interpreter, cmd.exe or in the Windows PowerShell. The Windows release it is routinely tested in a Windows 11 operating system.\!#ENDIF
!#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF allocates memory depending on the need. Small applications can be run with a minimum of memory available. Very large applications may need a substantial amount of memory, especially genomic analyses!#IF(HPB)\!#ELSE and the calculation of reliabilities\!#ENDIF.
!#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF supports the use of multiple cores. !#IF(HPB)!#ELSEThe MiX99 solver uses all available cores for the most common genomic evaluations, only.!#ENDIF!#IF(M99)!#ELSE The hpblup solver is optimised for 10-15 cores for all available types of evaluation.!#ENDIF Preparation of data for solving and processing its results are done with a single core.\
\
\

