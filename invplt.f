      SUBROUTINE INVPLT(VTUPLE,ISCR,IBUF,LBUF,ICHAR)
C     INVPLT INITIALIZES THE VELOCITY SPECTRA PLOT.  IT PRINTS THE HEADER OF
C  THE PLOT AND FILLS THE BACKGROUND OF THE PLOT WITH THE CHARACTER IN ICHAR.
C  IT ALSO PUTS IN THE GRID FOR FOLLOWING THE VELOCITY DOWN THE PAGE.
C
C  ARGUMENTS:
C  VTUPLE - AN ARRAY CONSISTING OF THE START TIME OF THE ANALYSIS, THE END
C           TIME OF THE ANALYSIS, AND THE NUMBER OF PRINTER COLUMNS BETWEEN THE
C           TWO.
C  ISCR   - AN SCRATCH ARRAY AT LEAST 2000 16 BIT WORDS.
C  LBUF   - THE TRACE HEADER ARRAY.
C  ICHAR  - THE A2 FORMATED CHARACTER TO FILL THE BACKGROUND OF THE PLOT WITH.
C
C
C  WRITTEN AND COPYRIGHTED BY:
C  PAUL HENKART, SCRIPPS INSTITUTION OF OCEANOGRAPHY, 20 MAY 1981
C  ALL RIGHTS ARE RESERVED BY THE AUTHOR.  PERMISSION TO COPY OR REPRODUCE THIS
C  SUBROUTINE, BY COMPUTER OR OTHER MEANS, MAY BE OBTAINED ONLY FROM THE AUTHOR.
c
c  mod 10 Mar 94 - grid at end of plot was off 1 column
c  mod 17 Oct 95 - The grid was right, it was pltvs that was off!
C
      INTEGER*2 ISCR,IBUF
      CHARACTER*1 ICHAR
      COMMON /VELDAT/IA(900)
      CHARACTER*132 IA
      DIMENSION VTUPLE(111)
      COMMON /READT/ ILUN,NUMHDR,NUMDAT,IUNHDR
      DIMENSION  ISCR(111),LBUF(111),IBUF(111)
      CHARACTER*132 MASTER
      CHARACTER*4 LMONTH(12)
      DATA LMONTH/' JAN',' FEB',' MAR',' APR',' MAY','JUNE','JULY',
     *  ' AUG','SEPT',' OCT',' NOV',' DEC'/
      DATA MASTER/' '/

      LSIZE=900
      PRINT 1
1     FORMAT('1')
      PRINT 20
      PRINT 20
C      PRINT 10, (ISCR(I),I=1,12)                                           /* FORM FEED FIRST
      PRINT 20
   10 FORMAT(' SIOSEIS VELOCITY SPECTRA LEVEL 1.0 PERFORMED ON ',8A2,
     *  ' AT ',4A2)
      PRINT 20
   20 FORMAT('  ')
      ltemp = ibuf(79)                                                   /* convert to 32 bit integer!
      ltemp1 = ibuf(80)
      CALL JULCAL(MONTH,IDAY,ltemp,ltemp1)                               /* CONVERT JULIAN  TO CALENDAR
      PRINT 40,LBUF(6),IDAY,LMONTH(MONTH),IBUF(79),(IBUF(I),I=81,83)
   40 FORMAT(' RP',I5,' WAS RECORDED ON',I3,1X,A4,1X,I4,' AT ',2I2,':',
     *  I2)
      PRINT 41,LBUF(3),LBUF(4),LBUF(10)
   41 FORMAT(' TRACE 1 OF THE RP CAME FROM SHOT',I10,' TRACE ',I3,
     *  ' RANGE ',I10)
      PRINT 20
      PRINT 45
   45 FORMAT(' SEMBLANCE VALUES ARE SCALED SO THAT 9 IS THE LARGEST ',
     *  'POSSIBLE VALUE.')
      PRINT 20
      PRINT 50
   50 FORMAT(40X,'VELOCITY')
      COLS=VTUPLE(3)-1.
      NCOLS=VTUPLE(3)+10
      VINC=(VTUPLE(2)-VTUPLE(1))/COLS*10
      V=VTUPLE(1)
      I=1
   60 ISCR(I)=V
      I=I+1
      V=V+VINC
      IF(V.LE.VTUPLE(2)) GO TO 60
      I=I-1
      PRINT 70,(ISCR(J),J=1,I)                                          /* PRINT THE VELOCITY SCALE OF THE PLOT
   70 FORMAT(8X,I4,10(5X,I5))
      DO 90 I=1,132                                                      /* BUILD THE BACKGROUND AND THE GRID
   90 MASTER(I:I)=ICHAR                                                  /* THIS IS THE BACKGROUND
      DO 100 I=11,132,5
  100 MASTER(I:I)='+'                                                   /* THIS IS THE GRID
      PRINT 81,MASTER(1:NCOLS)
   81 FORMAT(A)
      DO 110 I=1,LSIZE                                                   /* NOW FILL THE ENTIRE PLOT WITH THE MASTER
  110 IA(I)=MASTER
      RETURN
      END
