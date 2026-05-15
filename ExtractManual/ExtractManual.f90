! ================================================================================================
! PROGRAM       Extract Manual
! aim           Extract a MiX99BLUP, MiXBLUP and HPBLUP manual from master manual in .md format
!               Combine chapters that apply to the specific manual in the correct order
!               Start each chapter on a new page
! interface     In:  File with chapter file names in correct order
!               Out: software-specific manuals for MiXBLUP, MiXBLUP with only MiX99, and HPBLUP
! ================================================================================================
  PROGRAM ExtractManual

  USE ModFullText

  IMPLICIT NONE
  TYPE(TypeFullText) :: FullText
  TYPE(Effects),DIMENSION(:),ALLOCATABLE  :: hpEffects
  CHARACTER(LEN=100)    :: InFile, OutFile, Debug, InstrFile(3), SNPcovFile
  CHARACTER(LEN=500)    :: SystCommand
  CHARACTER(LEN=200)    :: OrgDataFile
  CHARACTER(LEN=MaxLineLenInstr)    :: inputLine
  CHARACTER(LEN=100)     :: FileName, NewFileName
  CHARACTER(LEN=12)     :: cDate,Time
  CHARACTER(LEN=24)     :: fdate
  INTEGER  :: OMP_GET_MAX_THREADS
  INTEGER               :: j, k, iUnit, jUnit, Length,alpha, DebLen, iFile, iSNP, nRecPed, iRun, nRuns, nFldGamma, ihpCov, iLabel, iIndex, iCov
  REAL                  :: time_begin, time_end, Sum2pq, Sum2pqOld
  REAL*8                :: CorrFact
  LOGICAL               :: apaxfile, SNPcombine, IsOpen

  !Init Wall Clock Time
  call GetCPUtime()

! (1.1) Debug% switches on or off whether verbose output is printed (used for debugging)
  CALL GetArg(1,Debug)
  IF (Debug(1:2) /= '-D') THEN
    CALL GetArg(2,Debug)
  ENDIF


  
  END PROGRAM ExtractManual
