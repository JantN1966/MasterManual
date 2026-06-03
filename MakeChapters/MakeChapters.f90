! ================================================================================================
! PROGRAM       Make Chapters in manual
! aim           Convert numbering of headings to sequential numbering
! interface     In:  Extracted manual with 1.1 headings
!               Out: Extracted manual with numbered headings
! ================================================================================================
  PROGRAM MakeChapters

  IMPLICIT NONE
 
  CHARACTER(LEN=100)    :: Path, ManualFile, NewFile, Heading
  CHARACTER(LEN=2) :: Option
  CHARACTER(LEN=20) :: Hashes, Numbering, Addition
  CHARACTER(LEN=5000) :: NewLine
  INTEGER :: CurrentChapter(10)
  INTEGER :: iLine, ErrIO, iLevel, iCurLevel, iChr, iLast, iDot
  LOGICAL :: IsHeading, InWord
  
! (1) read command line options
  Path=' '
  ManualFile=' '
! (1.1) read first CLI option
  CALL GetArg(1,Option)
  IF (Option == '-f') THEN
    CALL GetArg(2,ManualFile)
  ELSE IF (Option == '-p') THEN
    CALL GetArg(2,Path)
  ELSE
    WRITE (*,*) ' First command line option not recognized! ',Option
    WRITE (*,*) ' Use MakeChapters.exe -f <your manual file> [-p <path to your manual files>]'
    STOP
  ENDIF

! (1.2) read second CLI option
  CALL GetArg(3,Option)
  IF (Option == '-f') THEN
    CALL GetArg(4,ManualFile)
  ELSE IF (Option == '-p') THEN
    CALL GetArg(4,Path)
  ELSE
    WRITE (*,*) ' Second command line option not recognized! ',Option
    WRITE (*,*) ' Use MakeChapters.exe -f <your manual file> [-p <path to your manual files>]'
    STOP
  ENDIF
  
! (1.3) end path with folder delimiter
  IF (LEN_TRIM(Path) /= 0) THEN
    iLast=LEN_TRIM(Path)
    IF (Path(iLast:iLast) /= '/') THEN
      Path=TRIM(Path)//'/'
    ENDIF
  ENDIF

! (2) open manual file
  OPEN (unit=11,FILE=TRIM(Path)//ManualFile,STATUS='OLD')

! (3) open new manual file
  iDot=INDEX(ManualFile,'.')
  NewFile=ManualFile(1:iDot-1)//'_2.md'
  OPEN(21,FILE=NewFile,STATUS='UNKNOWN',ACCESS='SEQUENTIAL',FORM='FORMATTED',RECL=5000)

! (4) initialise chapter numbering
  CurrentChapter(1:10)=0

! (5) look up headings and replace the numbering
  DO 

!   (5.1) read record
    READ (11,'(A)', IOSTAT=ErrIO) NewLine
    IF (ErrIO /= 0) EXIT
    
!   (5.2) write lines that are not a heading unchanged to the new file
    IF (NewLine(1:1) /= '#') THEN
      WRITE (21,'(A)') TRIM(NewLine)
      CYCLE
    ENDIF
    
!   (5.3) prepare for reading a heading
    Hashes=' '
    Numbering=' '
    Heading=' '

!   (5.4) verify that first word consists of hashes only
    InWord=.TRUE.
    IsHeading=.TRUE.
    iChr=1
    DO
      IF (NewLine(iChr:iChr) /= ' ') THEN
        IsHeading=(IsHeading .AND. NewLine(iChr:iChr) == '#')
        Hashes=TRIM(Hashes)//NewLine(iChr:iChr)
      ELSE
        InWord=.FALSE.
        EXIT
      ENDIF
      iChr=iChr+1
    ENDDO
    IF (.NOT. IsHeading) THEN
      WRITE (21,'(A)') TRIM(NewLine)
      CYCLE
    ENDIF

!   (5.5) verify that second word is the default numbering of main body of text or an appendix (first character is A instead of 1) 
    DO
      IF (.NOT. InWord) THEN
        IF (NewLine(iChr:iChr) /= ' ') THEN
          InWord=.TRUE.
          IsHeading=(IsHeading .AND. (NewLine(iChr:iChr) == '1' .OR. NewLine(iChr:iChr) == 'A'))
          Numbering=TRIM(Numbering)//NewLine(iChr:iChr)
        ENDIF
      ELSE
        IF (NewLine(iChr:iChr) /= ' ') THEN
          IsHeading=(IsHeading .AND. (NewLine(iChr:iChr) == '1' .OR. NewLine(iChr:iChr) == '.'))
          Numbering=TRIM(Numbering)//NewLine(iChr:iChr)
        ELSE
          InWord=.FALSE.
          EXIT
        ENDIF
      ENDIF
      iChr=iChr+1
    ENDDO
    IF (.NOT. IsHeading) THEN
      WRITE (21,'(A)') TRIM(NewLine)
      CYCLE
    ENDIF

!   (5.6) read hashes, numbering and heading
    Heading=TRIM(Newline(iChr:))
    iCurLevel=LEN_TRIM(Hashes)-1
    CurrentChapter(iCurLevel)=CurrentChapter(iCurLevel)+1
    CurrentChapter(iCurLevel+1:10)=0

!   (5.7) replace the numbering with the current chapter numbering
    Numbering=' '
    DO iLevel=1,iCurLevel
      WRITE (Addition,'(I0,A)') CurrentChapter(iLevel),'.'
      Numbering=TRIM(Numbering)//TRIM(Addition)
    ENDDO
    WRITE (*,*) ' Numbering & Heading: ',TRIM(Numbering), TRIM(Heading)
    
!   (5.8) write updated heading to new file
    WRITE (21,'(A,X,A,X,A)') TRIM(Hashes), TRIM(Numbering), TRIM(Heading)
  ENDDO
  
  CLOSE (UNIT=11)
  CLOSE (UNIT=21)

  END PROGRAM MakeChapters
  
