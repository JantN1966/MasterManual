INCLUDE 'modhashfun.f90'
INCLUDE 'modtable.f90'
INCLUDE 'ModManual.f90'

! ================================================================================================
! PROGRAM       Update cross-references in manual
! aim           Update cross-references and set up table of contents in manual
! interface     In:  Extracted manual with 1.1 headings
!               Out: Extracted manual with numbered headings
! ================================================================================================
  PROGRAM UpdateCrossReference
  use modtable, only: tablechar_t 
  use ModManual

  IMPLICIT NONE
 
  type(tablechar_t) :: HashHeadingID
  type(TypeManual),DIMENSION(:),ALLOCATABLE :: Manual, TableContents

  CHARACTER(LEN=100)    :: Path, ManualFile, NewFile, RefLabel
  CHARACTER(LEN=200)    :: Heading
  CHARACTER(LEN=2) :: Option
  CHARACTER(LEN=20) :: Hashes, Numbering, Addition, HeadingID, Spaces
  CHARACTER(LEN=5000) :: NewLine
  CHARACTER(LEN=20),DIMENSION(:),ALLOCATABLE :: HeadingID2Numbering
  INTEGER :: iLine, nLine, iLineToC, nLineToC, ErrIO, nChapters, iLast, iDot, LastLineTitlePage
  INTEGER :: iStart, iChr, iCurlyOpen, iCurlyClose, iSquareOpen, iBracketClose, iHash, nHash, nHeading
  LOGICAL :: IsHeading, InWord, IsNew
  
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
    WRITE (*,*) ' Use UpdateCrossReference.exe -f <your manual file> [-p <path to your manual files>]'
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
    WRITE (*,*) ' Use UpdateCrossReference.exe -f <your manual file> [-p <path to your manual files>]'
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
  
! (3) get number of lines and number of chapters
  nLine=0
  nChapters=0
  DO
    READ (11,'(A)', IOSTAT=ErrIO) NewLine
    IF (ErrIO /= 0) EXIT
    nLine=nLine+1
    IF (NewLine(1:3) == '## ') THEN
      nChapters=nChapters+1
      IF (nChapters == 1) LastLineTitlePage=nLine-1
    ENDIF
  ENDDO
  ALLOCATE (Manual(nLine))
  REWIND 11

! (4) open new manual file
  iDot=INDEX(ManualFile,'.')
  IF (INDEX(ManualFile(1:iDot),'_') == 0) THEN
    NewFile=ManualFile(1:iDot-1)//'_3.md'
  ELSE
    NewFile=ManualFile(1:iDot-3)//'_3.md'
  ENDIF
  OPEN(21,FILE=NewFile,STATUS='UNKNOWN',ACCESS='SEQUENTIAL',FORM='FORMATTED',RECL=5000)

! (5) read manual and store in derived type array
  iLine=0
  DO 

!   (5.1) read record
    READ (11,'(A)', IOSTAT=ErrIO) NewLine
    IF (ErrIO /= 0) EXIT
    
    iLine=iLine+1
    Manual(iLine)%LineLength=LEN_TRIM(NewLine)
    Manual(iLine)%Line=TRIM(NewLine)
    Manual(iLine)%IsHeading=(NewLine(1:2) == '##')
  ENDDO
  
! (6) read headings and store heading ID in hash table
  HashHeadingID=tablechar_t(6)
  nHeading=0

  DO iLine=1,nLine
    IF (.NOT. Manual(iLine)%IsHeading) CYCLE
    
!   (6.1) prepare for reading a heading
    Hashes=' '
    Numbering=' '
    Heading=' '

!   (6.2) verify that first word consists of hashes only
    InWord=.TRUE.
    IsHeading=.TRUE.
    iChr=1
    DO
      IF (Manual(iLine)%Line(iChr:iChr) /= ' ') THEN
        IsHeading=(IsHeading .AND. Manual(iLine)%Line(iChr:iChr) == '#')
        Hashes=TRIM(Hashes)//Manual(iLine)%Line(iChr:iChr)
      ELSE
        InWord=.FALSE.
        EXIT
      ENDIF
      iChr=iChr+1
    ENDDO
    IF (.NOT. IsHeading) THEN
      Manual(iLine)%IsHeading=.FALSE.
      CYCLE
    ENDIF

!   (6.3) verify that second word is the default numbering of main body of text or an appendix (first character is A instead of 1) 
    DO
      IF (.NOT. InWord) THEN
        IF (Manual(iLine)%Line(iChr:iChr) /= ' ') THEN
          InWord=.TRUE.
          IsHeading=(IsHeading .AND. INDEX('123456789A',Manual(iLine)%Line(iChr:iChr)) /= 0)
          Numbering=TRIM(Numbering)//Manual(iLine)%Line(iChr:iChr)
        ENDIF
      ELSE
        IF (Manual(iLine)%Line(iChr:iChr) /= ' ') THEN
          IsHeading=(IsHeading .AND. INDEX('0123456789.',Manual(iLine)%Line(iChr:iChr)) /= 0)
          Numbering=TRIM(Numbering)//Manual(iLine)%Line(iChr:iChr)
        ELSE
          InWord=.FALSE.
          EXIT
        ENDIF
      ENDIF
      iChr=iChr+1
    ENDDO
    IF (.NOT. IsHeading) THEN
      Manual(iLine)%IsHeading=.FALSE.
      CYCLE
    ENDIF
    
!   (6.4) read heading ID
    iCurlyOpen=INDEX(Manual(iLine)%Line,'{')
    iCurlyClose=INDEX(Manual(iLine)%Line,'}')
    IF (iCurlyOpen == 0) THEN
      WRITE (*,*) ' No heading ID found in section heading! Line skipped.'
      WRITE (*,*) ' Check: '
      WRITE (*,*) Manual(iLine)%Line
      Manual(iLine)%IsHeading=.FALSE.
      CYCLE
    ENDIF

!   (6.5) read heading and heading ID
    Heading=Manual(iLine)%Line(iChr:iCurlyOpen-1)
    HeadingID=TRIM(Manual(iLine)%Line(iCurlyOpen+2:iCurlyClose-1))
    WRITE (*,'(A,2(X,A))') TRIM(Numbering), TRIM(Heading), HeadingID

!   (6.6) store heading ID in hash table
    CALL HashHeadingID%add(HeadingID, iHash, isNew)
    IF (.NOT. IsNew) THEN
      WRITE (*,*) ' Non-unique heading ID found! Line skipped. Check:' 
      WRITE (*,*) Manual(iLine)%Line
      Manual(iLine)%IsHeading=.FALSE.
      CYCLE
    ENDIF
    
!   (6.7) store hash number of heading ID and numbering
    Manual(iLine)%iHash=iHash
    Manual(iLine)%Numbering=Numbering
    Manual(iLine)%Heading=Heading
    Manual(iLine)%iLevel=LEN_TRIM(Hashes)-1
    nHeading=nHeading+1
  ENDDO
  nHash=iHash
  ALLOCATE(HeadingID2Numbering(nHash))
  
! (7) store chapter number against hash number of Heading ID
  DO iLine=1,nLine
    IF (.NOT. Manual(iLine)%IsHeading) CYCLE
    HeadingID2Numbering(Manual(iLine)%iHash)=Manual(iLine)%Numbering
  ENDDO
  
! (8) update cross-references
  DO iLine=1,nLine
    IF (Manual(iLine)%IsHeading) CYCLE
    iStart=1
    DO
      iChr=INDEX(Manual(iLine)%Line(iStart:),'](#')
      IF (iChr == 0) EXIT
      iSquareOpen=INDEX(Manual(iLine)%Line(iStart:),'[')
      IF (iSquareOpen == 0) THEN
        WRITE (*,*) ' cross-reference found, but no opening [ ; check line ',iLine
        EXIT
      ENDIF
      iBracketClose=INDEX(Manual(iLine)%Line(iStart-1+iChr:),')')
      IF (iBracketClose == 0) THEN
        WRITE (*,*) ' cross-reference found, but no closing ) ; check line ',iLine
        EXIT
      ENDIF
      RefLabel=Manual(iLine)%Line(iStart-1+iSquareOpen+1:iStart-1+iChr-1)
      HeadingID=Manual(iLine)%Line(iStart-1+iChr+3:iStart-1+iChr-1+iBracketClose-1)
      iHash=HashHeadingID%getindex(HeadingID)
      IF (iHash < 0) THEN
        WRITE (*,*) ' Heading ID in cross-reference not found! Check ',TRIM(HeadingID), ' on line ',iLine
        EXIT
      ENDIF
      NewLine=' '
      NewLine=Manual(iLine)%Line(1:iStart-1+iSquareOpen)//TRIM(HeadingID2Numbering(iHash))//Manual(iLine)%Line(iStart-1+iChr:)
      Manual(iLine)%Line=TRIM(NewLine)
      iStart=iStart-1+iChr-1+iBracketClose+1
    ENDDO
  ENDDO

! (9) create table of contents
  Spaces=' '
  ALLOCATE (TableContents(nHeading+3))
  iLineToC=1
  TableContents(iLineToC)%Line='## Table of Contents {#Tabl01}'
  TableContents(iLineToC)%LineLength=LEN_TRIM(TableContents(iLineToC)%Line)
  iLineToC=iLineToC+1
  TableContents(iLineToC)%Line=' '
  TableContents(iLineToC)%LineLength=0
  DO iLine=1,nLine
    IF (.NOT. Manual(iLine)%IsHeading) CYCLE
    IF (Manual(iLine)%iLevel < 9) THEN
      HeadingID=HashHeadingID%get(Manual(iLine)%iHash)
      iLineToC=iLineToC+1
      TableContents(iLineToC)%Line=Spaces(1:(Manual(iLine)%iLevel-1)*3)//'['//TRIM(Manual(iLine)%Numbering)// &
      & ' '//TRIM(Manual(iLine)%heading)//'](#'//TRIM(HeadingID)//') \'
      TableContents(iLineToC)%LineLength=LEN_TRIM(TableContents(iLineToC)%Line)
    ENDIF
  ENDDO
  nLineToC=iLineToC
  
! (10) write out updated manual
  iLine=1
  WRITE (21, '(A)') Manual(iLine)%Line
  DO iLine=2,LastLineTitlePage
    IF (Manual(iLine)%LineLength == 0 .AND. Manual(iLine-1)%LineLength == 0) CYCLE
    WRITE (21, '(A)') Manual(iLine)%Line
  ENDDO
  DO iLineTOC=1,nLineToC
    WRITE (21, '(A)') TableContents(iLineToC)%Line
  ENDDO
  WRITE (21,*)
  WRITE (21,'(A)') '\newpage'
  DO iLine=LastLineTitlePage+1,nLine
    IF (Manual(iLine)%LineLength == 0 .AND. Manual(iLine-1)%LineLength == 0) CYCLE
    IF(Manual(iLine)%Line == '\newpage') THEN
      WRITE (21,*)
      WRITE (21,*) '[Back to Table of Contents](#Tabl01)'
      WRITE (21,*)
    ENDIF
    WRITE (21, '(A)') Manual(iLine)%Line
  ENDDO

! (11) close units
  CLOSE (UNIT=11)
  CLOSE (UNIT=21)

  END PROGRAM UpdateCrossReference
  
