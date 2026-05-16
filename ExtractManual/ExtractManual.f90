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
  USE ModSections

  IMPLICIT NONE
  TYPE(TypeFullText) :: FullText
  TYPE(TypeSections,DIMENSION(:),ALLOCATABLE  :: Sections ! (to do)
 
  CHARACTER(LEN=100)    :: Path, ChaptersFile, ChFileName
  CHARACTER(LEN=200),DIMENSION(:),ALLOCATABLE  ::  TextFile
  CHARACTER(LEN=2) :: Option
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
  
  DO iFile=1,nFiles

!   (3) read a chapter as a vector of characters
!   (3.1) open file
    OPEN (UNIT=11,FILE=TextFile(iFile),STATUS='OLD')
    
!   (3.2) read dimensions of chapter
    CALL GetDimFullText(iUnit, FullText)
    
!   (3.3) store contents of chapter
    CALL ReadFullText(iUnit, FullText)
    
!   (4) identify type-specific sections of the chapter text
    
  
  END PROGRAM ExtractManual
