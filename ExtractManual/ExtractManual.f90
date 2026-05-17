! ================================================================================================
! PROGRAM       Extract Manual
! aim           Extract a MiX99BLUP, MiXBLUP and HPBLUP manual from master manual in .md format
!               Combine chapters that apply to the specific manual in the correct order
!               Sections not in an !#IF - !#ENDIF statement are written to all manuals
!               Instructions of an !#IF - !#ENDIF statement are not written to any manual
!               Start each chapter on a new page
! interface     In:  File with chapter file names in correct order
!               Out: software-specific manuals for MiXBLUP, MiXBLUP with only MiX99, and HPBLUP
! ================================================================================================
  PROGRAM ExtractManual

  USE ModFullText
  USE ModSections

  IMPLICIT NONE
  TYPE(TypeFullText) :: FullText
  TYPE(TypeSections,DIMENSION(:),ALLOCATABLE  :: Sections ! (to do)
 
  CHARACTER(LEN=100)    :: Path, ChaptersFile, ChFileName
  CHARACTER(LEN=200),DIMENSION(:),ALLOCATABLE  ::  TextFile
  CHARACTER(LEN=2) :: Option
  CHARACTER(LEN=11) :: Incorrect
  INTEGER               :: iFile, nFiles
  REAL                  :: 
  LOGICAL               :: 

! (1) read command line options
  Path=' '
  Chaptersfile=' '
! (1.1) read first CLI option
  CALL GetArg(1,Option)
  IF (Option == '-f') THEN
    CALL GetArg(2,Chaptersfile)
  ELSE IF (Option == '-p') THEN
    CALL GetArg(2,Path)
  ELSE
    WRITE (*,*) ' First command line option not recognized! ',Option
    WRITE (*,*) ' Use ExtractManual.exe -f <your chapter file> [-p <path to your chapter files>]'
    STOP
  ENDIF

! (1.2) read second CLI option
  CALL GetArg(3,Option)
  IF (Option == '-f') THEN
    CALL GetArg(4,Chaptersfile)
  ELSE IF (Option == '-p') THEN
    CALL GetArg(4,Path)
  ELSE
    WRITE (*,*) ' Second command line option not recognized! ',Option
    WRITE (*,*) ' Use ExtractManual.exe -f <your chapter file> [-p <path to your chapter files>]'
    STOP
  ENDIF
  
! (1.3) end path with folder delimiter
  IF (LEN_TRIM(Path) /= 0) THEN
    iLast=LEN_TRIM(Path)
    IF (Path(iLast:iLast) /= '/') THEN
      Path=TRIM(Path)//'/'
    ENDIF
  ENDIF

! (2) read chapter file names
! (2.1) open file
  OPEN (unit=11,FILE=Chaptersfile,STATUS='OLD')
  
! (2.2) count number of files to read
  iFile=0
  DO
    READ (11,'(A)', IOSTAT=ErrIO) ChFileName
    IF (ErrIO /= 0) EXIT
    iFile=iFile+1
  ENDDO
  nFiles=iFile
  ALLOCATE (TextFile(nFiles))
  REWIND (UNIT=11)
  
! (2.3) read filenames of chapters
  DO iFile=1,nFiles
    READ (11,'(A)', IOSTAT=ErrIO) TextFile(iFile)
    IF (LEN_TRIM(Path) /= 0) TextFile(iFile)=TRIM(Path)//TRIM(TextFile(iFile))
  ENDDO
  CLOSE (UNIT=11)
  
! (3) open new manual files
  OPEN(21,FILE='ManualMiX99BLUP.md',STATUS='UNKNOWN',ACCESS='SEQUENTIAL',FORM='FORMATTED',RECL=25000)
  OPEN(22,FILE='ManualMiXBLUP.md',STATUS='UNKNOWN',ACCESS='SEQUENTIAL',FORM='FORMATTED',RECL=25000)
  OPEN(23,FILE='ManualHPBLUP.md',STATUS='UNKNOWN',ACCESS='SEQUENTIAL',FORM='FORMATTED',RECL=25000)

  DO iFile=1,nFiles

!   (3) read a chapter as a vector of characters
!   (3.1) open file
    OPEN (UNIT=11,FILE=TextFile(iFile),STATUS='OLD')
    
!   (3.2) read dimensions of chapter
    CALL GetDimFullText(iUnit, FullText)
    
!   (3.3) store contents of chapter
    CALL ReadFullText(iUnit, FullText)
    
!   (4) identify type-specific sections of the chapter text
!   (4.1) get the total number of characters in the chapter
    nChr=SIZE(FullText%Text,1)

!   (4.2) initialise manual types of current section and manual types not yet used in current IF statement
    CurrentToManual=.FALSE.
    ElseToManual=.TRUE.
    
!   (4.3) process the first character of the file
    iChr=1
    CALL ReadInstruction(FullText,iChr,iInstr,iType,IsInstruction,iSkip)
    IF (IsInstruction) THEN
      CurrentToManual(iType)=.TRUE.
      ElseToManual(iType)=.FALSE.
    ELSE
      CurrentToManual(:)=.TRUE.
      ElseToManual(:)=.FALSE.
      FullText%ToManual(:,iChr)=CurrentToManual(:)
    ENDIF
    InSection=.TRUE.
    iChr=iChr+1+iSkip
    
!   (4.4) process other characters of the file
    DO
      CALL ReadInstruction(FullText,iChr,iInstr,iType,IsInstruction,iSkip)
      IF (IsInstruction) THEN
        IF (iInstr == 1 .OR. iInstr == 2) THEN ! IF & ELIF
          CurrentToManual(iType)=.TRUE.
          ElseToManual(iType)=.FALSE.
        ELSE IF (iInstr == 3) THEN             ! ELSE
          CurrentToManual=ElseToManual
        ELSE IF (iInstr == 4) THEN             ! ENDIF
          CurrentToManual=.FALSE.
          ElseToManual=.TRUE.
          InSection=.FALSE.
        ELSE
          CALL Vector2String(FullText%Text(iChr:iChr+10),Incorrect,11)
          WRITE (*,*) ' Programming error: instruction code not set in instruction! (file, character, instruction code, instruction) ',iFile, iChr, iInstr, Incorrect
          STOP
        ENDIF
      ELSE
        IF (.NOT. InSection) THEN
          CurrentToManual(:)=.TRUE.
          ElseToManual(:)=.FALSE.
          InSection=.TRUE.
        ENDIF
        FullText%ToManual(:,iChr)=CurrentToManual(:)
      ENDIF
      iChr=iChr+1+iSkip
      IF (iChr > nChr) EXIT
    ENDDO
    
!   (5) write manual-specific chapters
    DO iLine=1,FullText%nLines
      NewLine(:)=' '
      DO iChr=FullText%FirstPos(iLine),FullText%FirstPos(iLine)
        DO iType=1,3
          IF (FullText%ToManual(iType,iChr)) NewLine(iType)=

    
!   (6) add a page break at the end of each chapter
    WRITE (21,'(A)') '<div style="page-break-after:always;"></div>'
    WRITE (22,'(A)') '<div style="page-break-after:always;"></div>'
    WRITE (22,'(A)') '<div style="page-break-after:always;"></div>'
      
  
  END PROGRAM ExtractManual
  
! ================================================================================================
! subroutine  ReadInstruction
! aim         If the current character is the start of an instruction, read the instruction and set
!             type of instruction and the manuals to which section should be written.
! interface   in:  
!             out: 
! date        May 2026
! author      JtN
! ================================================================================================
  SUBROUTINE ReadInstruction(FullText,iChr,iInstr,iType,IsInstruction,iSkip)
  USE ModFullText
  IMPLICIT    NONE

  TYPE(TypeFullText), INTENT(INOUT) :: FullText
  INTEGER, INTENT(IN)  :: iChr
  INTEGER, INTENT(OUT)  :: iInstr, iType, iSkip
  LOGICAL, INTENT(OUT) :: IsInstruction
  
  CHARACTER(LEN=11) :: Instruction
  INTEGER                              :: RecLen
  INTEGER                              :: iField, iPos, FPos
  LOGICAL                              :: InField

! (1) initialise
  IsInstruction=.FALSE.
  iInstr=0
  iType=0
  iSkip=0
  
! (2) read string of length of maximum length of an instruction
  CALL Vector2String(FullText%Text(iChr:iChr+10),Instruction,11)
  
! (3) parse instruction if present
  IF (Instruction(1:4) == '!#IF') THEN
    IsInstruction=.TRUE.
    iInstr=1
    CALL GetType(Instruction,iType)
    iSkip=8
  ELSE IF (Instruction(1:6) == '!#ELIF') THEN
    IsInstruction=.TRUE.
    iInstr=2
    CALL GetType(Instruction,iType)
    iSkip=10
  ELSE IF (Instruction(1:6) == '!#ELSE') THEN
    IsInstruction=.TRUE.
    iInstr=3
    iSkip=5
  ELSE IF (Instruction(1:7) == '!#ENDIF') THEN
    IsInstruction=.TRUE.
    iInstr=4
    iSkip=6
  ENDIF

  END SUBROUTINE ReadInstruction
  
! ================================================================================================
! subroutine  GetType
! aim         Derive target type of manual from the instruction
! interface   in:  
!             out: 
! date        May 2026
! author      JtN
! ================================================================================================
  SUBROUTINE GetType(Instruction,iType)
  
  IMPLICIT NONE
  
  CHARACTER(LEN=11),INTENT(IN) :: Instruction
  INTEGER,INTENT(OUT) :: iType
  
  CHARACTER(LEN=3) :: Label
  CHARACTER(LEN=12) :: DefinedTypes
  INTEGER :: iBrOpen,iBrClose, iPos
  
! (1) find the label of the type of manual, enclosed by brackets
  iBrOpen=INDEX(Instruction,'(')
  iBrClose=INDEX(Instruction,')')
  IF (iBrClose == 0 .OR. iBrOpen == 0) THEN
    WRITE (*,*) ' Instruction incomplete! Check ',Instruction
    STOP
  ENDIF

! (2) read label of manual
  Label=Instruction(iBrOpen+1:iBrClose-1)
  
! (3) read type of manual
  DefinedTypes='M99#MiX#HPB'
  iPos=INDEX(DefinedTypes,Label)
  IF (iPos == 1) iType=1
  IF (iPos == 5) iType=2
  IF (iPos == 9) iType=3

  END SUBROUTINE GetType

