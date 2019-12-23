      SUBROUTINE BPASS(FL,FH,FILT,NPTS,SI,SCR)
C    BPASS1 GENERATES A ZERO PHASE TIME DOMAIN FILTER.  THE IMPULSE RESPONSE
C WILL HAVE AN ENERGY OF 1., THUS ALLEVIATING SCALING PROBLEMS DUE TO DIFFERENT
C BANDWIDTHS.
C    THE DESIGN IS DONE IN THE TIME DOMAIN AND IS THE SHORTEST AND SIMPLIEST,
C BUT IS NOT AS GOOD (STEEPNESS OF CUT OFF) AS SOME OPTIMIZING METHODS.
C THE FILTER IS BETTER THE MORE POINTS IT HAS, AND IS WORSE THE LESS POINTS IT
C HAS.  39 POINTS IS A NICE NUMBER
C    THE METHOD OF DESIGN IS:
C   1) GENERATE A COSINE AT A FREQUENCY W1 WHICH IS HALFWAY BETWEEN THE CUTOFF
C     IN THE FREQUENCY DOMAIN THIS IS A SPIKE AT FREQUENCY W1.
C   2) MULTIPLY 1 BY A SINC FUNCTION OF FREQUENCY WC WHICH IS HALF THE BANDWIDTH
C     IN THE FREQUENCY DOMAIN THIS IS CONVOLVING 1 WHITH A BOX CAR.
C   3) MULTIPLY THE RESULT BY A WINDOW TO PREVENT DISCONTINUITIES.  IN THE
C     FREQUENCY DOMAIN THIS IS CONVOLVING THE BOX CAR WITH A SMOOTHING FUNCTION.
C
C  ARGUMENTS:
C      FL     - THE FREQUENCY OF THE LOW CORNER
C      FH     - THE FREQUENCY OF THE HIGH CORNER
C      FILT   - THE ARRAY TO RECEIVE THE TIME DOMAIN FILTER POINTS.
C      NPTS   - THE NUMBER OF FILTER POINTS WANTED
C      SI     - THE SAMPLE INTERVAL IN SECONDS
C      SCR    - A SCRATCH ARRAY AT LEAST NPTS/2+1 LONG
C
C
C  WRITTEN AND COPYRIGHTED BY:
C  PAUL HENKART, SCRIPPS INSTITUTION OF OCEANOGRAPHY, FEBRUARY 1979
C  ALL RIGHTS ARE RESERVED BY THE AUTHOR.  PERMISSION TO COPY OR REPRODUCE THIS
C  SUBROUTINE, BY COMPUTER OR OTHER MEANS, MAY BE OBTAINED ONLY FROM THE AUTHOR.
c  mod 6 Oct 09 - hange the documentation - sample interval, not sample rate.
c
      DIMENSION FILT(*),SCR(*)
      PI2=6.283197
      N=NPTS/2+1                                                         /* THE CENTRE POINT OF A ZERO PHASE FILTER
      W1=(FL+FH)/2.                                                     /* FIND THE CENTRE FREQUENCY
      WC=(FH-FL)/2.                                                     /* THE WIDTH OF THE BANDPASS
C****
C****    GENERATE A COSINE WAVE
C****
      P=1./W1/SI
      DO 100 I=1,N
  100 SCR(I)=COS(FLOAT(I-1)/P*PI2)
C****
C****   MULTIPLY BY A HALF SINC
C****
      P=1./WC/SI
      SCR(1)=1.
      DO 200 I=2,N
      X=FLOAT(I-1)/P*PI2
  200 SCR(I)=SCR(I)*SIN(X)/X
C****
C****     MULTIPLY BY A GOOD WINDOW  ( HAMMING)
C****
      CALL WINDOW(-6,FILT,N,DUM)
      DO 300 I=1,N
  300 SCR(I)=SCR(I)*FILT(N-I+1)
C****
C****      NOW MAKE A SYMMETRICAL FILTER OUT OF IT
C****
      DO 400 I=1,N
      FILT(I)=SCR(N-I+1)
      FILT(N+I-1)=SCR(I)
  400 CONTINUE
C****
C****        MAKE THE FILTER HAVE AN ENERGY OF 1.
C****
      E=0.
      DO 500 I=1,NPTS
  500 E=E+FILT(I)*FILT(I)
      C=1./SQRT(E)
      DO 550 I=1,NPTS
  550 FILT(I)=FILT(I)*C
      RETURN
      END
