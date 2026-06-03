! ================================================================================================
! PROGRAM       Assign heading ID
! aim           Assign a unique ID to each heading as a one-off to facilitate cross-referencing
! interface     In:  Master chapter file
!               Out: Master chapter file with heading ID's
! ================================================================================================
  PROGRAM AssignHeadingID

  IMPLICIT NONE
 
  CHARACTER(LEN=100)    :: Path, ChapterFile, NewFile, Heading
  CHARACTER(LEN=2) :: Option
  CHARACTER(LEN=6) :: HeadingID
  CHARACTER(LEN=5000) :: NewLine
  INTEGER :: iLine, ErrIO, iCurrent, iLast, iDot
  
! (1) read command line options
  Path=' '
  ChapterFile=' '
! (1.1) read first CLI option
  CALL GetArg(1,Option)
  IF (Option == '-f') THEN
    CALL GetArg(2,ChapterFile)
  ELSE IF (Option == '-p') THEN
    CALL GetArg(2,Path)
  ELSE
    WRITE (*,*) ' First command line option not recognized! ',Option
    WRITE (*,*) ' Use AssignHeadingID.exe -f <your chapter file> [-p <path to your chapter file>]'
    STOP
  ENDIF

! (1.2) read second CLI option
  CALL GetArg(3,Option)
  IF (Option == '-f') THEN
    CALL GetArg(4,ChapterFile)
  ELSE IF (Option == '-p') THEN
    CALL GetArg(4,Path)
  ELSE
    WRITE (*,*) ' Second command line option not recognized! ',Option
    WRITE (*,*) ' Use AssignHeadingID.exe -f <your chapter file> [-p <path to your chapter file>]'
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
  OPEN (unit=11,FILE=TRIM(Path)//ChapterFile,STATUS='OLD')

! (3) open new manual file
  HeadingID=' '
  HeadingID(1:4)=ChapterFile(1:4)
  iDot=INDEX(ChapterFile,'.')
  NewFile=ChapterFile(1:iDot-1)//'_2.md'
  OPEN(21,FILE=NewFile,STATUS='UNKNOWN',ACCESS='SEQUENTIAL',FORM='FORMATTED',RECL=5000)

! (4) initialise numbering of Heading ID
  iCurrent=1

! (5) look up headings and replace the numbering
  DO 

!   (5.1) read record
    READ (11,'(A)', IOSTAT=ErrIO) NewLine
    IF (ErrIO /= 0) EXIT
    
!   (5.2) write lines that are not a heading unchanged to the new file
!    WRITE (*,*) ' First character on the line: ',NewLine(1:1)
    IF (NewLine(1:2) /= '##') THEN
      WRITE (21,'(A)') TRIM(NewLine)
      CYCLE
    ENDIF

!   (5.3) add a heading ID to the heading
    WRITE (HeadingID(5:6),'(I2.2)') iCurrent
    WRITE (21,'(A,X,3A)') TRIM(NewLine),'{#',HeadingID,'}'
    iCurrent=iCurrent+1
    
  ENDDO
  
  CLOSE (UNIT=11)
  CLOSE (UNIT=21)

  END PROGRAM AssignHeadingID
  
