      SUBROUTINE RECTC(N,BUF,AMP,PHZ)
C    RECTC COMPUTES THE RECTANGULAR COORDINATES FROM THE POLAR COORDINATES.
C   ARGUMENTS:
C  N    - THE NUMBER OF COORDINATES TO CONVERT. AMP AND PHZ MUST CONTAIN N POINTS.
C  BUF  - THE REAL ARRAY N*2 LONG CONTAINING THE RECTANGULAR COORDINATES.
C  AMP  - THE ARRAY CONTAINING THE AMPLITUDE SPECTRUM.
C  PHZ  - THE ARRAY CONTAINING THE PHASE SPECTRUN.
C
      DIMENSION BUF(1),AMP(1),PHZ(1)
      M=1
      DO 100 I=1,N
         ANGLE = PHZ(I)
         BUF(M) = AMP(I)*COS(ANGLE)
         BUF(M+1) = AMP(I)*SIN(ANGLE)
  100 M=M+2
      RETURN
      END
