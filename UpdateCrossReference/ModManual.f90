! ================================================================================================
! MODULE                ModManual
! aim                   Store the manual in a derived type array
! ================================================================================================
MODULE ModManual
  IMPLICIT NONE

  TYPE :: TypeManual                                      ! This has the whole command file as a long string
    INTEGER :: LineLength
    CHARACTER(LEN=:),ALLOCATABLE :: Line
    LOGICAL :: IsHeading
    CHARACTER(LEN=:),ALLOCATABLE :: Numbering
    CHARACTER(LEN=:),ALLOCATABLE :: Heading
    INTEGER :: iHash
    INTEGER :: iLevel
  END TYPE TypeManual

END MODULE ModManual