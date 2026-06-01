## 1. Running !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF
**This chapter describes practical issues when analyzing data with !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF.**

### 1.1 Starting a !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF evaluation
Solving mixed model equations using !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF involves execution of several programs. The main executable is !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF.exe. This is the parser and it either calls the MiX99 executables dataprocessor.exe, solver.exe or reliabilities.exe, or it calls one of the hpblup executables hpblup.exe or hpblup_gpu.exe. For calculation of a genomic relationship matrix, !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF calls calc_grm.exe. 

The recommended way to call !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF for breeding value estimation is:

>!#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF.exe blup -i \<name instruction file\>

Calling !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF without any arguments prints a help message (also available with the “--help” flag).
Each flag under the new syntax has a long and a short version, long versions are always preceded by two dashes and short versions by a single dash. The user may choose the long versions for readability and documentation or the short ones for brevity and reduced typing.

Table with flag options:

|Purpose | Command | Long flag | Short flag | Usage|
| --- | --- | --- | --- | --- |
|EBV calculation | blup | --instruction | -i | Instruction file|
|Reliability | rel |  |  |  |
|Validation | val |  |  |
|Indirect Prediction | pred | --pedigree | -p | Pedigree file|
|  |  | --genotype |-g | Genotype file|
|  | any | --debug | -D | Debug options (s t m l)|

!#IF(HPB)!#ELSEThe old syntax to call MiXBLUP is deprecated, but still available:

>MiXBLUP.exe \<name instruction file\>
!#ENDIF

### 1.1 Choosing a breeding value evaluation or a reliability calculation
!#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF either estimates breeding values, using either the default or the hpblup solver, or calculates approximate reliabilities, using reliabilities.exe. The type of analysis is controlled with the !RELIABILITY qualifier in the SOLVING section in the instruction file. If it is specified, a reliabilities calculation is started. See Chapter 9 for the additional changes in the instruction file when a reliabilities analysis is required.
By default, a breeding value analysis is started. The hpblup solver can be called with !hpblup in the SOLVING section (see Chapter 8).

### 1.1 A breeding value analysis with previous solutions as starting values
In case of large evaluations of breeding values, there may be a substantial saving in time to convergence of 10-30% by using the previous solutions as starting values for the current evaluation. This is activated by specifying the !#IF(HPB)!#ELSE!RESTART!#ENDIF qualifier !#IF(MiX)or the !#ENDIF!#IF(M99)!#ELSE!STARTVAL_CHECK!#ENDIF qualifier in the SOLVING section. It does not have an effect on a reliabilities analysis.
!#IF(HPB)!#ELSEFor the MiX99 solver, the only additional file necessary for using previous solutions is the Solunf file. If !RESTART is specified, MiXBLUP renames the file Solunf to Solold. If the file Solold is present, the preprocessor dataprocessor will create a file Solvec. This file will be used to initialise the solution vector of the mixed-model equations before the start of the iteration process (in solver). If any of the effects in the statistical model has been defined with field type A (alphanumerical labels), then the file Code.inp of the previous analysis must be present, too. The file Code_index.inp of a previous analysis is not used for a restart.!#ENDIF
!#IF(M99)!#ELSEFor the hpblup solver, it is better to use !STARTVAL_CHECK instead of !RESTART. Additional files needed are startval_mixblup.new (in case the pedigree contains multiple base populations) or solutions_mixblup.dat (pedigree contains a single base population). !#ENDIF!#IF(MiX)MiXBLUP!#ELIF(HPB)HPBLUP!#ENDIF!#IF(M99)!#ELSE renames these files to startval_mixblup.dat. This file is read by the hpblup solver for initializing the solutions vector. The file hpCodes.bin is also needed as it contains the key between original and coded labels.!#ENDIF

### 1.1 Monitoring and checking the process
When developing new analyses, it may be useful to monitor the progress of the analysis. This can be specified with “-D s” on the command line, for example

> !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF blup -i TestRun.inp -D s

The output of the --debug or -D option is written to the screen log.
Useful debug options:

**-D s**
The debug option s provides more detail on the stage of the evaluation.

**-D t**
The debug option t provides more detail on the run time of the various stages of the evaluation.

**-D m**
The debug option m provides more detail on the memory use of the various stages of the evaluation.

**-D l**
The debug option l (lowercase L) provides more detail on the current host, the license host, the type of license, the path to the license, and the end date of the license.

After the run is finished, it is worth to look through the various log-files.
!#IF(HPB)!#ELSEFor the MiX99 solver, check ERMcalc_grm.log, dataprocessor.log and solver.log. !#ENDIF!#IF(M99)!#ELSEFor the hpblup solver, check ERMcalc_grm.log, hpblup.log and log_hpblup.dat. !#ENDIFIn !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF.log some information is given about pre- and post-processing of the data. It also lists error messages, if any. If all programs have run successfully, it is worth to check !#IF(HPB)!#ELSEsolver.log for the MiX99 solver !#ENDIF!#IF(MiX)or !#ENDIF!#IF(M99)!#ELSEhpblup.log and convergence.dat for the hpblup solver!#ENDIF, to see how the convergence was reached. In cases with poor convergence, it will give a warning and some model checking may be appropriate. !#IF(HPB)!#ELSEWhen reliabilities are calculated, one can check the reliabilities.log, or reliabilities_direct.log and reliabilities_indirect.log when reliabilities are calculated for both direct and indirect genetic effects, such as maternal genetic effects.!#ENDIF

### 1.1 Interrupting a process of the kernel
!#IF(HPB)!#ELSEThe MiX99 solver can be interrupted by placing an empty file with file name **STOP** in the folder of the analysis.!#ENDIF
!#IF(M99)!#ELSEThe hpblup solver can be interrupted by placing an empty file with file name **stopiter** or **STOP** in the folder of the analysis.!#ENDIF
After every iteration, both solvers check whether the stop file is present. If so, it will start producing the output files as if convergence had been attained, instead of the next iteration, and it will stop afterwards.
