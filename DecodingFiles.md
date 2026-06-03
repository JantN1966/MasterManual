## 1. Decoding any file with coded class effect labels {#Deco01}

**!#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF produces quite a range of internal files with information that might be useful for the user in specific cases. Internal files contain coded labels of class effects and need to be decoded to be useful.**

### 1.1. General {#Deco02}

The solver requires that labels of class effect levels are coded 1 to N. In order to make coding and decoding as efficiently as possible, the key to code and decode labels is stored in a binary file. Therefore !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF has tools to decode files instead of to decode files manually.

### 1.1. Decoding coded labels {#Deco03}

#### 1.1.1. General {#Deco04}

The decoding tool can be used for either the default or the hpblup solver. It will detect which solver has been used. If both types of key exist in the folder, the user is asked which key to use. If neither key exists, an error is given. The tool can be used to decode individual coded labels, a file with coded labels created by the user or an internal file created by !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF.

#### 1.1.1. Syntax {#Deco05}

The tool to decode coded labels is called from the command line as:

>Coded2Original.exe

If the tool identifies hpblup as the solver used, it will ask for the field name in the genetic evaluation of the coded labels to decode. The solver hpblup has a separate key for each class effect. Genetic class effect levels (i.e. IDs) of indirect genetic effects are coded using the key of the direct genetic effect. The default solver just has a single key for all alphanumerical class effects.

#### 1.1.1. Decoding individual coded class effect labels {#Deco06}

For decoding (one or a few) individual class effect labels, answer ‘1’ to the question

>Do you want to decode (1) individual IDs or (2) a file with coded IDs?

The user then specifies the codes to decode one by one and closes by entering code ‘0’, which closes the tool.

#### 1.1.1. Decoding a file that contains coded class effect labels {#Deco07}
For decoding (one or a few) individual class effect labels, answer ‘2’ to the question

>Do you want to decode (1) individual IDs or (2) a file with coded IDs?

The user is then asked three more questions:

>Enter name of file with IDs to convert:
>Enter field number with coded IDs to decode:
>Enter name of new file with decoded IDs:

The new file is the same as the existing file, except for the coded label replaced with the original label.
