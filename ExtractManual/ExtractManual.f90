  INCLUDE 'ModFullText.f90'

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

  IMPLICIT NONE
  TYPE(TypeFullText) :: FullText
 
  CHARACTER(LEN=100)    :: Path, ChaptersFile, ChFileName
  CHARACTER(LEN=200),DIMENSION(:),ALLOCATABLE  ::  TextFile
  CHARACTER(LEN=2) :: Option
  CHARACTER(LEN=11) :: Incorrect
  CHARACTER(LEN=5000) :: NewLine(3)
  INTEGER :: iFile, nFiles, iChr, nChr, iType, iInstr, iSkip, iLast, ErrIO, iUnit, MaxLineLen, iLine
  INTEGER :: iLineLen(3)
  LOGICAL :: IsInstruction, CurrentToManual(3), ElseToManual(3), InSection

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
  OPEN(21,FILE='ManualMiX99BLUP.md',STATUS='UNKNOWN',ACCESS='SEQUENTIAL',FORM='FORMATTED',RECL=5000)
  OPEN(22,FILE='ManualMiXBLUP.md',STATUS='UNKNOWN',ACCESS='SEQUENTIAL',FORM='FORMATTED',RECL=5000)
  OPEN(23,FILE='ManualHPBLUP.md',STATUS='UNKNOWN',ACCESS='SEQUENTIAL',FORM='FORMATTED',RECL=5000)

  iUnit=11
  DO iFile=1,nFiles

!   (3) read a chapter as a vector of characters
!   (3.1) open file
    OPEN (UNIT=iUnit,FILE=TextFile(iFile),STATUS='OLD')
    
!   (3.2) read dimensions of chapter
    CALL GetDimFullText(iUnit, FullText)
    
!   (3.3) store contents of chapter
    CALL ReadFullText(iUnit, FullText)
    
!   (3.4) identify the longest line
    MaxLineLen=0
    DO iLine=2,FullText%nLines
      MaxLineLen=MAX(MaxLineLen,FullText%StartPos(iLine)-FullText%StartPos(iLine-1))
    ENDDO
    WRITE (*,'(A,A,A,I0)') ' Maximum line length in: ',TRIM(TextFile(iFile)), ' is ', MaxLineLen
    
!   (4) identify type-specific sections of the chapter text
!   (4.1) get the total number of characters in the chapter
    nChr=SIZE(FullText%Text)

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
        IF (iInstr == 1) THEN ! IF
          InSection=.TRUE.
          CurrentToManual=.FALSE.
          ElseToManual=.TRUE.
          CurrentToManual(iType)=.TRUE.
          ElseToManual(iType)=.FALSE.
        ELSE IF (iInstr == 2) THEN ! ELIF
          CurrentToManual=.FALSE.
          CurrentToManual(iType)=.TRUE.
          ElseToManual(iType)=.FALSE.
        ELSE IF (iInstr == 3) THEN             ! ELSE
          CurrentToManual=ElseToManual
        ELSE IF (iInstr == 4) THEN             ! ENDIF
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
    
!    DO iChr=1,100
!      WRITE (*,'(I3,X,A,X,L1,X,L1,X,L1)') iChr,FullText%Text(iChr),FullText%ToManual(:,iChr)
!    ENDDO
!    iLine=1
!    DO
!      IF (FullText%StartPos(iLine) <= 100) THEN
!        WRITE (*,*) ' Line starting position ',iLine, FullText%StartPos(iLine)
!        iLine=iLine+1
!      ELSE
!        EXIT
!      ENDIF
!    ENDDO
    
!   (5) write manual-specific chapters
    DO iLine=1,FullText%nLines
      NewLine(:)=' '
      iLineLen(:)=0
      DO iChr=FullText%StartPos(iLine)+1,FullText%StartPos(iLine+1)
        DO iType=1,3
          IF (FullText%ToManual(iType,iChr)) THEN
            NewLine(iType)=NewLine(iType)(1:iLineLen(iType))//FullText%Text(iChr)
            iLineLen(iType)=iLineLen(iType)+1
          ENDIF
        ENDDO
      ENDDO
      DO iType=1,3
        WRITE(UNIT=20+iType,FMT='(A)') NewLine(iType)(1:iLineLen(iType))
      ENDDO
    ENDDO
    
!   (6) add a page break at the end of each chapter
    DO iType=1,3
      WRITE (20+iType,'(A)') '<div style="page-break-after:always;"></div>'
      WRITE (20+iType,*)
      WRITE (20+iType,*)
    ENDDO
    
!   (7) write details of chapter read
    WRITE (*,'(A,I0,A,I0)') ' Chapter written. Number of lines: ',FullText%nLines,'; number of characters: ',nChr
    WRITE (*,*)
    
!   (8) close chapter & initialise FullText for next chapter
    CLOSE (UNIT=iUnit)
    FullText%nLines=0
    DEALLOCATE(FullText%StartPos, FullText%Text,FullText%ToManual)

  ENDDO
  
  END PROGRAM ExtractManual
  
