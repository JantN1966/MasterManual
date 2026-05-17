! ================================================================================================
! MODULE                ModFullText
! aim                   Store the full text of a chapter file, including instructions
! Contains subroutines  - String2Vector(vector,string,N)
!                       - Vector2String(string,vector,N)
!                       - GetLine(iLine, FullText, chrLine, Length)
!                       - GetDimFullText(Unit, FullText)
!                       - ReadFullText(Unit, FullText)
!                       - GetWord(InputLine,iArg,iFirstPos,iLastPos)
! ================================================================================================
MODULE ModFullText

  IMPLICIT NONE

  CHARACTER(LEN=1), PARAMETER :: ContinuationMark= '&'         ! signal for line continuation
  CHARACTER(LEN=1), PARAMETER :: CommentCode= '#'              ! signal for comments
  INTEGER, PARAMETER :: MaxLineLenText=25000

  TYPE :: TypeFullText                                         ! This contains the full text as a long string
    INTEGER :: nLines                                          ! Number of lines
    INTEGER, DIMENSION(:) :: StartPos                          ! Start position of each line
    CHARACTER, DIMENSION(:) :: Text                            ! All characters in the file
    LOGICAL, DIMENSION(:,:) :: ToManual                          ! target manuals for each character
  END TYPE TypeFullText

  contains

! ================================================================================================
! SUBROUTINE    String2Vector
! aim           Copies string of characters of length N to vector of single characters of length N
! interface     In: N, String
!               Out: Vector
! ================================================================================================
  SUBROUTINE String2Vector(Vector,String,N)

  INTEGER, INTENT(IN) :: N
  CHARACTER(LEN=N), INTENT(IN) :: String
  CHARACTER,DIMENSION(:), INTENT(OUT) :: Vector
  INTEGER :: i

  DO i=1,N
    Vector(i)=String(i:i)
  ENDDO

  END SUBROUTINE String2Vector

! ================================================================================================
! SUBROUTINE    Vector2String
! aim           Copies vector of single characters of length N to string of characters of length N
! interface     In: N, Vector
!               Out: String
! ================================================================================================
  SUBROUTINE Vector2String(String,Vector,N)

  INTEGER, INTENT(IN) :: N
  CHARACTER,DIMENSION(:), INTENT(IN) :: Vector
  CHARACTER(LEN=N), INTENT(OUT) :: String
  INTEGER :: i

  DO i=1,N
    String(i:i)=Vector(i)
  END DO
  
  END SUBROUTINE Vector2String

! ================================================================================================
! SUBROUTINE    GetLine
! aim           Get line iLine from full chapter text in FullText%Text and present as string in
!               chrLine, but check first whether line is not too long.
! interface     In: iLine = target line number in instruction file
!                   FullText = instruction file as a vector of single characters
!               Out: chrLine = target line from instruction file as string
!                    Length = length of target line
! ================================================================================================
  SUBROUTINE GetLine(iLine, FullText, chrLine, Length)
  IMPLICIT NONE

  TYPE(TypeFullText), INTENT(IN)  :: FullText
  INTEGER, INTENT(IN)  :: iLine
  CHARACTER(*), INTENT(OUT)  :: chrLine
  INTEGER, INTENT(OUT)  :: Length

  INTEGER                       :: j, N, iPos
  CHARACTER(LEN=72)             :: ErrDescr2

  N=LEN(chrLine)
  chrLine= ' '
  iPos=FullText%StartPos(iLine)
  Length=FullText%StartPos(iLine+1) -iPos
  CALL Vector2String(chrLine, FullText%Text(iPos+1:iPos+Length), Length)

  END SUBROUTINE GetLine

! ================================================================================================
! SUBROUTINE    GetDimFullText
! aim           Reads full text of chapter from file number Unit
!               Only size of the file and number of lines is calculated and used to allocate memory
! interface     In:  Unit             file with full text
!               Out: FullText
! ================================================================================================
  SUBROUTINE GetDimFullText(iUnit, FullText)

  INTEGER, INTENT(IN)                   :: iUnit
  TYPE(TypeFullText), INTENT(OUT)    :: FullText

  INTEGER               :: io, iSize, iPos, nLines
  CHARACTER(LEN=25000)  :: Line

! (1) rewind chapter file and initialise counters
  rewind(iUnit)
  iPos=0
  nLines=0

! (2) read & process lines of the chapter file
  DO
    READ(iUnit,'(A)',iostat=io) Line
    IF (io /= 0) EXIT
    nLines=nLines+1
    iSize=LEN_TRIM(Line)
    iPos=iPos+iSize
  ENDDO

! (3) store the number of lines
  FullText%nLines=nLines

! (4) allocate memory to FullText
  ALLOCATE(FullText%StartPos(nLines+1), FullText%Text(iPos),FullText%ToManual(3,iPos))
  FullText%ToManual=.FALSE.

  END SUBROUTINE GetDimFullText

! =================================================================================================================================
! SUBROUTINE    ReadFullText
! aim           Reads full text of chapter from file number Unit
!               The full text is stored in FullText%Text
!               Store the start of each line in FullText%StartPos
! interface     In:  Unit              file with instruction file
!               Out: FullText         instruction file
! =================================================================================================================================
  SUBROUTINE ReadFullText(iUnit, FullText)

  INTEGER, INTENT(IN)  :: iUnit
  TYPE(TypeFullText), INTENT(OUT)  :: FullText

  INTEGER  :: io, iSize, iPos, i, nLines, ii
  CHARACTER(LEN=25000)  :: Line

! (1) rewind instruction file and initialise counters
  rewind(iUnit)
  iPos=0
  nLines=0

! (2) read & process lines of the instruction file
  DO
    READ(iUnit,'(A)',iostat=io) Line
    IF (io /= 0) EXIT
    nLines=nLines+1
    FullText%StartPos(nLines)=iPos
    iSize=LEN_TRIM(Line)
    CALL String2Vector(FullText%Text(iPos+1:iPos+iSize), inputLine, iSize)
    iPos=iPos+iSize
  ENDDO

! (3) last position of StartPos contains the last filled position of Text
  FullText%StartPos(nLines+1)=iPos

  END SUBROUTINE ReadFullText

! ================================================================================================
! subroutine  GetWord
! aim         get the start and end position on the line of word iArg
! interface   in:  InputLine = Line to be read
!                  iArg      = number on the line of argument to be read
!             out: iFirstPos = the first position on the line of the target word
!                  iLastPos  = the last position on the line of the target word
! date        September 2019
! author      JtN
! ================================================================================================
  SUBROUTINE GetWord(InputLine,iArg,iFirstPos,iLastPos)
    IMPLICIT    NONE

    INTEGER, INTENT(IN)  :: iArg
    INTEGER, INTENT(INOUT)  :: iFirstPos, iLastPos
    CHARACTER(LEN=*), INTENT(IN) :: InputLine
  
    CHARACTER*1                          :: Space
    INTEGER                              :: RecLen
    INTEGER                              :: iField, iPos, FPos
    LOGICAL                              :: InField

  ! (1) initialise
    iField=0
    InField=.FALSE.
    Space= ' '
    RecLen=LEN_TRIM(InputLine)
    iFirstPos=0
    iLastPos=0

  ! (2) read record, character by character and construct fields
    DO iPos=1,RecLen
      IF (InputLine(iPos:iPos) /= Space) THEN
      
  !     (2.1) character is not a field separator
        IF (.NOT. InField) THEN
  
  !       (2.1.1) start of a new field
          iField=iField+1
          IF (iField == iArg) THEN
            iFirstPos=iPos
          ENDIF
          InField=.TRUE.
        ENDIF
      ELSE
      
  !     (2.2) character is a field separator
        IF (InField) THEN
          InField=.FALSE.
          IF (iField == iArg) THEN
            iLastPos=iPos-1
            EXIT
          ENDIF
        ENDIF
      ENDIF
    END DO
    
  ! (3) last position of word is end of line in case of exactly iArg words on the line
    IF (iFirstPos /= 0 .AND. iLastPos == 0) iLastPos=RecLen

    END SUBROUTINE GetWord

! ================================================================================================
! SUBROUTINE    MakeLower
! aim           Change case to a lower case letter: for letters A-Z, only.
! interface     In:
!               Out:
!               inout: Line: character string to be made lowercase on input
!                            character string converted to lowercase on output
! ================================================================================================
pure SUBROUTINE MakeLower(Line)

CHARACTER*(*), INTENT(inout) :: Line

INTEGER       :: i, N, ic

  N=LEN(Line)
  DO i=1,N
    ic=ICHAR(Line(i:i))
    IF ((ic > 64).AND.(ic < 91)) &
      Line(i:i)=CHAR(ic+32)
  END DO

END SUBROUTINE MakeLower

! ================================================================================================
! SUBROUTINE    MakeUpper
! aim           Change case to an uppercase letter: for letters a-z, only.
! interface     In:
!               Out:
!               inout: Line: character string to be made uppercase on input
!                            character string converted to uppercase on output
! ================================================================================================
pure SUBROUTINE MakeUpper(Line)

CHARACTER*(*), INTENT(inout) :: Line

INTEGER       :: i, N, ic

  N=LEN(Line)
  DO i=1,N
    ic=ICHAR(Line(i:i))
    IF ((ic > 96).AND.(ic < 123)) &
      Line(i:i)=CHAR(ic-32)
  ENDDO

END SUBROUTINE MakeUpper

END MODULE ModFullText

