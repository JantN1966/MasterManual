## 1. How to start {#HowT01}

!#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF is easy to use and easy to install. This chapter describes how to install the software and how to obtain and install a license.\

### 1.1.  Installing !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF software {#HowT02}

Download the appropriate zip-file from http://www.!#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF.eu and unzip the folder with the executables.\
Copy the executables to a central folder that can be accessed from other folders. The user needs to create a file, named ‘SysDir.inp’, which contains the path to the central folder with executables. This file should be copied to any folder from which !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF is run. The path to !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF.exe should be included in the command file that starts up the analysis or added to the system path. !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF uses SysDir.inp to locate the other executables.\

### 1.1.  !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF Licenses {#HowT03}

To run !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF software on your computer you need a license. There are different license types for !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF. A license can be ordered at http://www.!#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF.eu.\

The license key of the commercial licenses is computer-specific. Therefore, if executables and the license key ‘LICENSE.DAT’ are moved to another computer, !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF will give an error message. Running !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF with the run-time option –D l (minus, uppercase D, lowercase L) writes the host name, license type and expiry date in the license file to the screen output.\
So if you want to transfer the !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF software with an existing license to a new computer, you have to request a new license from info@mixblup.eu with the LICREQST.DAT attached (how to generate a LICREQST.DAT file see below). You will receive a new license for the remainder of the license period.\
The license key provides the information about the !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF version, the license type and the expiry date of the license. A trial license can be used for one month and a trial license key is not computer-specific. The small and full commercial license can be used for one year. The license key for these licenses is computer-specific.\

#### Trial License {#HowT04}

Order a trial license at http://www.!#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF.eu. After receiving your order, we send the necessary license key to the e-mail address in the order.\

#### Commercial licenses {#HowT05}

Order a commercial license at http://www.!#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF.eu. While entering the order you are asked to upload one or more ‘LICREQST.DAT’ files. For each computer you need to upload a separate ‘LICREQST.DAT’ file. This file is required to generate a license key for your computer. Also renewing a license for the next calendar year you need to do by filling in the !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF License Order & Renewal Form on the website.\

#### Generating a license-request file and installing the license {#HowT06}

The name of the license request file is ‘LICREQST.DAT’. The name of a license file is ‘LICENSE.DAT’.
* Run !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF.exe once without the need for an instruction file. !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF creates the file LICREQST.DAT in the working directory.
* After payment of the license one or more ‘LICENSE.DAT’ files will be sent back and should be saved in the bin folder of the corresponding computer(s).
* Store the license key ‘LICENSE.DAT’ in the C:\!#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF\bin-folder for Windows or in the /usr/bin-folder for Linux.

#### Alternative license directory {#HowT07}

If the license key cannot be stored in the default directory, the user may create a file, named LicDir.inp, which contains the path to the license file. If this file exists, !#IF(HPB)HPBLUP!#ELSEMiXBLUP!#ENDIF will look for the license file in the specified folder.


