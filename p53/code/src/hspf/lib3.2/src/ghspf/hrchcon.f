C
C
C
      SUBROUTINE   PCONS
C
C     + + + PURPOSE + + +
C     Process input to the cons section of the rchres module
C
C     + + + COMMON BLOCKS- SCRTCH, VERSION CONS1 + + +
      INCLUDE    'crhco.inc'
      INCLUDE    'crin2.inc'
      INCLUDE    'cmpad.inc'
C
C     + + + LOCAL VARIABLES + + +
      INTEGER    I1,I2,I4,IVAL(1),J,N,RETCOD,I
      REAL       RVAL(11),R0
C
C     + + + EXTERNALS + + +
      EXTERNAL   ZIPI,ITABLE,RTABLE
      EXTERNAL   ZIPR,MDATBL
C
C     + + + OUTPUT FORMATS + + +
 2000 FORMAT (/,' PROCESSING INPUT FOR SECTION CONS')
 2010 FORMAT (/,' FINISHED PROCESSING INPUT FOR SECTION CONS')
C
C     + + + END SPECIFICATIONS + + +
C
      I1= 1
      R0 = 0.0
C
      IF (OUTLEV.GT.1) THEN
        WRITE (MESSU,2000)
      END IF
C
C     initialize month-data input
      I= 120
      CALL ZIPR (I,R0,
     O           COAFXM)
      CALL ZIPR (I,R0,
     O           COACNM)
C
C     initialize atmospheric deposition fluxes
      I= 10
      CALL ZIPR (I,R0,
     O           CNCF3)
      CALL ZIPR (I,R0,
     O           CNCF4)
C
C     warning message counter initialization
      J= 10
      N= 0
      CALL ZIPI(J,N,CNWCNT)
C
C     process values in table-type ncons
      I2= 15
      I4= 1
      CALL ITABLE
     I             (I2,I1,I4,UUNITS,
     M              IVAL)
      NCONS= IVAL(1)
C
C     table-type cons-ad-flags
      I2= 16
      I4= 20
      CALL ITABLE
     I             (I2,I1,I4,UUNITS,
     M              COADFG)
C
C     read in month-data tables where necessary
      DO 50 J= 1, NCONS
        N= 2*(J- 1)+ 1
        IF (COADFG(N) .GT. 0) THEN
C         monthly flux must be read
          CALL MDATBL
     I                (COADFG(N),
     O                 COAFXM(1,J),RETCOD)
C         convert units to internal - not done by MDATBL
          IF (UUNITS .EQ. 1) THEN
C           convert from qty/ac.day to qty/ft2.ivl
            DO 30 I= 1, 12
              COAFXM(I,J)= COAFXM(I,J)*DELT60/(24.0*43560.0)
 30         CONTINUE
          ELSE IF (UUNITS .EQ. 2) THEN
C           convert from qty/ha.day to qty/m2.ivl
            DO 40 I= 1, 12
              COAFXM(I,J)= COAFXM(I,J)*DELT60/(24.0*10000.0)
 40         CONTINUE
          END IF
        END IF
        IF (COADFG(N+1) .GT. 0) THEN
C         monthly ppn conc must be read, no conversion needed
          CALL MDATBL
     I                (COADFG(N+1),
     O                 COACNM(1,J),RETCOD)
        END IF
 50   CONTINUE
C
      DO 20 N= 1,NCONS
C       process values in table-type cons-data
        I2= 17
        I4= 11
        CALL RTABLE
     I               (I2,N,I4,UUNITS,
     M                RVAL)
        DO 10 J= 1,5
          CONID(J,N)= RVAL(J)
 10     CONTINUE
        CON(N)= RVAL(6)
        CCONCD(1,N) = RVAL(7)
        CCONCD(2,N) = RVAL(8)
        CCONV(N)    = RVAL(9)
        CQTYID(1,N) = RVAL(10)
        CQTYID(2,N) = RVAL(11)
C
C       total storage of conservatives
        RCON(N)= CON(N)*VOL
C
 20   CONTINUE
      IF (OUTLEV.GT.1) THEN
        WRITE (MESSU,2010)
      END IF
C
      RETURN
      END
C
C
C
      SUBROUTINE   CONS
C
C     + + + PURPOSE + + +
C     Simulate behavior of conservative constituents; calculate
C     concentration of conservative constituents after advection
C
C     + + + COMMON BLOCKS- SCRTCH, VERSION CONS2 + + +
      INCLUDE    'crhco.inc'
      INCLUDE    'cmpad.inc'
C
C     + + + LOCAL VARIABLES + + +
      INTEGER    FPT,I,N
      REAL       INCON
C
C     + + + FUNCTIONS + + +
      REAL       DAYVAL
C
C     + + + EXTERNALS + + +
      EXTERNAL   ADVECT,DAYVAL
C
C     + + + END SPECIFICATIONS + + +
C
C     get time series
      IF (PRECFP .GE. 1) THEN
C       precipitation is input
        PREC= PAD(PRECFP+IVL1)
      ELSE
C       no precipitation
        PREC= 0.0
      END IF
C
      IF (HYDRFG .NE. 1) THEN
C       section hydr is inactive, so sarea must be on the pad if needed
        SAREA= PAD(SAFP+IVL1)
      END IF
C
      DO 10 I= 1,NCONS
C       get inflowing material from pad
        FPT = ICNFP(I)
C
        IF (FPT .GT. 0) THEN
          ICON(I)= PAD(FPT+IVL1)
C         convert inflow to internal units
          ICON(I)= ICON(I)*CCONV(I)
        ELSE
          ICON(I) = 0.0
        END IF
C
C       compute atmospheric deposition influx
        N= 2*(I-1)+ 1
C       dry deposition
        IF (COADFG(N) .LE. -1) THEN
          COADDR(I)= SAREA*CCONV(I)*PAD(COAFFP(I)+IVL1)
        ELSE IF (COADFG(N) .GE. 1) THEN
          COADDR(I)= SAREA*CCONV(I)*DAYVAL(COAFXM(MON,I),
     I                                     COAFXM(NXTMON,I),DAY,NDAYS)
        ELSE
          COADDR(I)= 0.0
        END IF
C       wet deposition
        IF (COADFG(N+1) .LE. -1) THEN
          COADWT(I)= PREC*SAREA*PAD(COACFP(I)+IVL1)
        ELSE IF (COADFG(N+1) .GE. 1) THEN
          COADWT(I)= PREC*SAREA*DAYVAL(COACNM(MON,I),COACNM(NXTMON,I),
     I                                 DAY,NDAYS)
        ELSE
          COADWT(I)= 0.0
        END IF
C
        INCON= ICON(I)+ COADDR(I)+ COADWT(I)
C
        CALL ADVECT
     I              (INCON,VOLS,SROVOL,VOL,EROVOL,SOVOL,
     I               EOVOL,NEXITS,
     M               CON(I),
     O               ROCON(I),OCON(1,I))
        RCON(I)= CON(I)*VOL
 10   CONTINUE
C
      RETURN
      END
C
C
C
      SUBROUTINE   CONACC
     I                    (FRMROW,TOROW)
C
C     + + + PURPOSE + + +
C     Accumulate fluxes in module section cons for printout
C
C     + + + DUMMY ARGUMENTS + + +
      INTEGER    FRMROW,TOROW
C
C     + + + ARGUMENT DEFINITIONS + + +
C     FRMROW - row containing incremental flux accumulation
C     TOROW  - flux row to be incremented
C
C     + + + COMMON BLOCKS- SCRTCH, VERSION CONS2 + + +
      INCLUDE   'crhco.inc'
      INCLUDE   'cmpad.inc'
C
C     + + + LOCAL VARIABLES + + +
      INTEGER   I
C
C     + + + EXTERNALS + + +
      EXTERNAL  ACCVEC
C
C     + + + END SPECIFICATIONS + + +
C
C     handle flux groups dealing with reach-wide variables
      CALL ACCVEC
     I            (NCONS,CNIF(1,FRMROW),
     M             CNIF(1,TOROW))
      CALL ACCVEC
     I            (NCONS,CNCF1(1,FRMROW),
     M             CNCF1(1,TOROW))
      CALL ACCVEC
     I            (NCONS,CNCF3(1,FRMROW),
     M             CNCF3(1,TOROW))
      CALL ACCVEC
     I            (NCONS,CNCF4(1,FRMROW),
     M             CNCF4(1,TOROW))
C
      IF (NEXITS .GT. 1) THEN
C       handle flux groups dealing with individual exit gates
        DO 10 I=1,NCONS
          CALL ACCVEC
     I                (NEXITS,CNCF2(1,I,FRMROW),
     M                 CNCF2(1,I,TOROW))
 10     CONTINUE
      END IF
C
      RETURN
      END
C
C
C
      SUBROUTINE   CONPRT
     I                    (LEV,PRINTU)
C
C     + + + PURPOSE + + +
C     Convert quantities from internal to external units, calculate
C     materials balance and print out results
C     Note: local arrays have same dimensions as corresponding arraysc
C       in osv, except for dropping of dimension lev, where applicable
C
C     + + + DUMMY ARGUMENTS + + +
      INTEGER    LEV,PRINTU
C
C     + + + ARGUMENT DEFINITIONS + + +
C     LEV    - current output level (2-pivl,3-day,4-mon,5-ann)
C     PRINTU - fortran unit number on which to print output
C
C     + + + COMMON BLOCKS- SCRTCH, VERSION CONS2 + + +
      INCLUDE    'crhco.inc'
      INCLUDE    'cmpad.inc'
C
C     + + + LOCAL VARIABLES + + +
      INTEGER     I,J,PADFG,I1
      REAL        CONDIF,PCFLX1,PCFLX2(5),PIFLX,PRCON,PRCONS,FACTA,
     #            PCFLX3,PCFLX4,PADTOT,CONIN
      CHARACTER*8 UNITID
C
C     + + + EXTERNALS + + +
      EXTERNAL   TRNVEC,BALCHK
C
C     + + + OUTPUT FORMATS + + +
 2000 FORMAT (/,' *** CONS ***')
 2010 FORMAT (/,'   CONSERVATIVE NO.',I3,9X,5A4)
 2020 FORMAT (/,'   STATE VARIABLE')
 2030 FORMAT (  '     CONCENTRATION  ','(',2A4,')',1X,1PE10.3)
 2040 FORMAT (/,'   FLUXES  (',2A4,')',15X,'TOTAL     TOTAL',
     #          4X,'INDIVIDUAL GATE OUTFLOWS (OCON)')
 2050 FORMAT (  ' ',34X,'INFLOW   OUTFLOW',5I10)
 2060 FORMAT (  ' ',36X,'ICON     ROCON',16X,'OCON')
 2070 FORMAT (  ' ',30X,10(1PE10.3))
 2080 FORMAT (/,'   FLUXES  (',2A4,')',10X,'<---ATMOSPHERIC DEPOSITION',
     #          '--->     OTHER     TOTAL    INDIVIDUAL GATE OUTFLOWS',
     #          ' (OCON)')
 2090 FORMAT (  ' ',37X,'DRY       WET     TOTAL    INFLOW',
     #          '   OUTFLOW',5I10)
 2100 FORMAT (  ' ',34X,'COADDR    COADWT   ATM DEP      ICON',
     #          '     ROCON',16X,'OCON')
 2110 FORMAT (/,'   FLUXES  ','(',2A4,')',15X,'TOTAL     TOTAL')
 2120 FORMAT (  ' ',36X,'ICON     ROCON')
 2130 FORMAT (/,'   FLUXES  (',2A4,')',10X,'<---ATMOSPHERIC DEPOSITION',
     #          '--->     OTHER     TOTAL')
 2140 FORMAT (  ' ',34X,'COADDR    COADWT   ATM DEP      ICON',
     #          '     ROCON')
 2150 FORMAT (2A4)
C
C     + + + END SPECIFICATIONS + + +
C
      WRITE (PRINTU,2000)
C
      I1= 1
      PADTOT= 0.0
C
      DO 10 I= 1,NCONS
C       convert variables to external units
        FACTA= 1.0/CCONV(I)
C       rchres-wide variables
        PIFLX= CNIF(I,LEV)*FACTA
C       storages
        PRCON = CNST(I,1)*FACTA
        PRCONS= CNST(I,LEV)*FACTA
C       computed fluxes
        PCFLX1= CNCF1(I,LEV)*FACTA
C
        PADFG= 0
        J= (I-1)*2+ 1
        IF ( (COADFG(J) .NE. 0) .OR. (COADFG(J+1) .NE. 0) ) THEN
          PADFG= 1
        END IF
C
        IF (PADFG .EQ. 1) THEN
          IF (COADFG(J) .NE. 0) THEN
            PCFLX3= CNCF3(I,LEV)*FACTA
          ELSE
            PCFLX3= 0.0
          END IF
          IF (COADFG(J+1) .NE. 0) THEN
            PCFLX4= CNCF4(I,LEV)*FACTA
          ELSE
            PCFLX4= 0.0
          END IF
          PADTOT= PCFLX3+ PCFLX4
        END IF
C
        IF (NEXITS .GT. 1) THEN
C         exit-specific variables
          CALL TRNVEC
     I                (NEXITS,CNCF2(1,I,LEV),FACTA,0.0,
     O                 PCFLX2)
        END IF
C
C       do printout on unit printu
        WRITE (PRINTU,2010)  I, (CONID(J,I),J=1,5)
        WRITE (PRINTU,2020)
        WRITE (PRINTU,2030)  (CCONCD(J,I),J=1,2), CON(I)
C
        IF (NEXITS .GT. 1) THEN
          IF (PADFG .EQ. 0) THEN
            WRITE (PRINTU,2040)  (CQTYID(J,I),J=1,2)
            WRITE (PRINTU,2050)  (J,J=1,NEXITS)
            WRITE (PRINTU,2060)
            WRITE (PRINTU,2070)  PIFLX, PCFLX1,(PCFLX2(J),J=1,NEXITS)
          ELSE
            WRITE (PRINTU,2080)  (CQTYID(J,I),J=1,2)
            WRITE (PRINTU,2090)  (J,J=1,NEXITS)
            WRITE (PRINTU,2100)
            WRITE (PRINTU,2070)  PCFLX3, PCFLX4, PADTOT, PIFLX, PCFLX1,
     #                          (PCFLX2(J),J=1,NEXITS)
          END IF
        ELSE
          IF (PADFG .EQ. 0) THEN
            WRITE (PRINTU,2110)  (CQTYID(J,I),J=1,2)
            WRITE (PRINTU,2050)
            WRITE (PRINTU,2120)
            WRITE (PRINTU,2070)  PIFLX, PCFLX1
          ELSE
            WRITE (PRINTU,2130)  (CQTYID(J,I),J=1,2)
            WRITE (PRINTU,2090)
            WRITE (PRINTU,2140)
            WRITE (PRINTU,2070)  PCFLX3, PCFLX4, PADTOT, PIFLX, PCFLX1
          END IF
        END IF
C
C       material balance check
        WRITE (UNITID,2150)  (CQTYID(J,I),J=1,2)
C
C       calculate net quantity of conservative entering rchres
        CONIN= PIFLX+ PADTOT
        CONDIF= CONIN - PCFLX1
C
        J= 3
        CALL BALCHK
     I              (J,RCHNO,DATIM,MESSU,PRINTU,MSGFL,
     I               PRCONS,PRCON,CONIN,CONDIF,UNITID,I1,
     M               CNWCNT(I))
C
 10   CONTINUE
C
      RETURN
      END
C
C
C
      SUBROUTINE   CONRST
     I                    (LEV)
C
C     + + + PURPOSE + + +
C     Reset flux and state variables for module section c1s
C
C     + + + DUMMY ARGUMENTS + + +
      INTEGER    LEV
C
C     + + + ARGUMENT DEFINITIONS + + +
C     LEV    - current output level (2-pivl,3-day,4-mon,5-ann)
C
C     + + + COMMON BLOCKS- SCRTCH, VERSION CONS2 + + +
      INCLUDE    'crhco.inc'
      INCLUDE    'cmpad.inc'
C
C     + + + LOCAL VARIABLES + + +
      INTEGER    I
C
C     + + + EXTERNALS + + +
      EXTERNAL   SETVEC
C
C     + + + END SPECIFICATIONS + + +
C
C     handle flux groups dealing with reach-wide variables
      CALL SETVEC
     I           (NCONS,0.0,
     O            CNIF(1,LEV))
      CALL SETVEC
     I           (NCONS,0.0,
     O            CNCF1(1,LEV))
      CALL SETVEC
     I           (NCONS,0.0,
     O            CNCF3(1,LEV))
      CALL SETVEC
     I           (NCONS,0.0,
     O            CNCF4(1,LEV))
C
      IF (NEXITS .GT. 1) THEN
C       handle flux groups dealing with individual exit gates
        DO 10 I= 1,NCONS
          CALL SETVEC
     I                (NEXITS,0.0,
     O                 CNCF2(1,I,LEV))
C
 10     CONTINUE
      END IF
C
C     keep present conservative storages in state variable array
C     used for material balance check
      DO 30 I= 1,NCONS
        CNST(I,LEV)= CNST(I,1)
 30   CONTINUE
C
      RETURN
      END
C
C
C
      SUBROUTINE   CONSRB
C
C     + + + PURPOSE + + +
C     Handle section cons
C
C     + + + COMMON BLOCKS- SCRTCH, VERSION CONS2 + + +
      INCLUDE  'crhco.inc'
      INCLUDE  'cmpad.inc'
C
C     + + + LOCAL VARIABLES + + +
      INTEGER   I,L
C
C     + + + END SPECIFICATIONS + + +
C
      DO 30 L= 1,NCONS
        IF (ROCNFP(L) .GE. 1) THEN
C         convert outflow to external units
          PAD(ROCNFP(L)+IVL1)= ROCON(L)/ CCONV(L)
        END IF
        IF (COADDX(L) .GE. 1) THEN
          PAD(COADDX(L)+IVL1)= COADDR(L)/ CCONV(L)
        END IF
        IF (COADWX(L) .GE. 1) THEN
          PAD(COADWX(L)+IVL1)= COADWT(L)/ CCONV(L)
        END IF
C
        IF (NEXITS .GT. 1) THEN
          DO 10 I= 1,NEXITS
            IF (OCNFP(I,L) .GE. 1) THEN
              PAD(OCNFP(I,L)+IVL1)= OCON(I,L)/ CCONV(L)
            END IF
C
 10       CONTINUE
        END IF
 30   CONTINUE
C
      RETURN
      END
C
C
C
      SUBROUTINE   CONSRP
C
C     + + + PURPOSE + + +
C     Handle section cons
C
C     + + + COMMON BLOCKS- SCRTCH, VERSION CONS2 + + +
      INCLUDE    'crhco.inc'
      INCLUDE    'cmpad.inc'
C
C     + + + LOCAL VARIABLES + + +
      INTEGER    L
C
C     + + + END SPECIFICATIONS + + +
C
      DO 10 L= 1,NCONS
        IF (CNFP(L) .GE. 1) THEN
          PAD(CNFP(L) + IVL1)= CON(L)
        END IF
 10   CONTINUE
C
      RETURN
      END
