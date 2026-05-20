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
    INTEGER, DIMENSION(:),ALLOCATABLE :: StartPos                          ! Start position of each line
    CHARACTER, DIMENSION(:),ALLOCATABLE :: Text                            ! All characters in the file
    LOGICAL, DIMENSION(:,:),ALLOCATABLE :: ToManual                          ! target manuals for each character
  END TYPE TypeFullText

  contains

! ================================================================================================
! SUBROUTINE    String2Vector
! aim           Copies string of characters of length N to vector of single characters of length N
! interface     In: N, String
!               Out: Vector
! ================================================================================================
  SUBROUTINE String2Vector(String,Vector,N)

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
  SUBROUTINE Vector2String(Vector,String,N)

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
  CALL Vector2String(FullText%Text(iPos+1:iPos+Length), chrLine, Length)

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
  TYPE(TypeFullText), INTENT(INOUT)    :: FullText

  INTEGER               :: io, iSize, iPos, nLines
  CHARACTER(LEN=5000)  :: Line

! (1) rewind chapter file and initialise counters
  rewind(iUnit)
  iPos=0
  nLines=0

! (2) read & process lines of the chapter file
  DO
    Line=' '
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
  TYPE(TypeFullText), INTENT(INOUT)  :: FullText

  INTEGER  :: io, iSize, iPos, i, nLines, ii
  CHARACTER(LEN=5000)  :: Line

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
    CALL String2Vector(Line, FullText%Text(iPos+1:iPos+iSize), iSize)
    iPos=iPos+iSize
  ENDDO

! (3) last position of StartPos contains the last filled position of Text
  FullText%StartPos(nLines+1)=iPos

  END SUBROUTINE ReadFullText

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

END MODULE ModFullText

