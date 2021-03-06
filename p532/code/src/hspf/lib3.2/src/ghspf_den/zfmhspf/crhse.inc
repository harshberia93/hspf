C     from CRHSE.INC   
C     RCHRES module common
C
C     + + + PARAMETERS + + +
      INCLUDE 'pmxexi.inc'
C
C            SEDTRN section
      COMMON/SCRTCH/HYDRFG,ADFG,CONSFG,HTFG,SEDFG,GQFG,OXFG,NUTFG,
     $              PLKFG,PHFG,ACIDFG,DUMZ,PFLAG,DUMY,PIVL,PYREND,
     $              RCHPFG,UUNITS,IUNITS,OUNITS,PUNIT,MESSU,MSGFL,
     $              RCHNO,RCHID,DELT,DELT60,DELTS,NDAY,NDAYS,LKFG,
     $              NEXITS,HRFG,DAYFG,STFG,EDAYFG,EMONFG,EPYRFG,YR,
     $              MON,DAY,HR,MIN,IVL,IVL1,PIVLNO,NXTMON,SPAFP,
     $              SPAKND,SPIVL,SPOPNO,DUMGEN,DUM1,AUX3FG,DUM2,DELTH,
     $              DB50,DUM3,LEN,DUM4,SLOPE,DUM5,VOL,VOLS,DUM6,AVDEP,
     $              TWID,HRAD,DUM7,AVVEL,DUM8,TAU,RO,DUM9,VOLFP,DUM10,
     $              AVDFP,TWIDFP,HRADFP,DUM11,AVVFP,DUM12,TAUFP,ROFP,
     $              DUM13,SROVOL,EROVOL,SOVOL,EOVOL,DUM14,TW,DUM15,
     $              TWFP,DUM16,SDIF,SDIFFP,SANDFG,SDPM,BEDWID,BEDWRN,
     $              POR,DB50E,DB50M,WSANDE,SDWCT1,SDWCT2,SDECNT,SDST,
     $              RSED,SSED,BEDDEP,RSEDFP,SSEDFP,BDDPFP,SDCF1,SDCF2,
     $              DEPSFP,ROSDFP,SDCF3,OSEDFP,DUMRCH
      INTEGER       HYDRFG,ADFG,CONSFG,HTFG,SEDFG,GQFG,OXFG,NUTFG,
     $              PLKFG,PHFG,ACIDFG,DUMZ(2),PFLAG(11),DUMY(1),PIVL,
     $              PYREND,RCHPFG,UUNITS,IUNITS,OUNITS,PUNIT(2),MESSU,
     $              MSGFL,RCHNO,RCHID(5),NDAY(12),NDAYS,LKFG,NEXITS,
     $              HRFG,DAYFG,STFG,EDAYFG,EMONFG,EPYRFG,YR,MON,DAY,
     $              HR,MIN,IVL,IVL1,PIVLNO,NXTMON,SPAFP,SPAKND,SPIVL,
     $              SPOPNO,DUMGEN(15),AUX3FG,VOLFP,AVDFP,TWIDFP,
     $              HRADFP,AVVFP,TAUFP,ROFP,TWFP,SDIFFP(3),SANDFG,
     $              SDWCT1(2,3),SDWCT2(2),SDECNT(3),RSEDFP(10),
     $              SSEDFP(4),BDDPFP,DEPSFP(4),ROSDFP(4),
     $              OSEDFP(MXEXIT,4)
      REAL          DELT,DELT60,DELTS,DELTH,DB50,LEN,SLOPE,AVDEP,TWID,
     $              HRAD,AVVEL,TAU,RO,SROVOL,EROVOL,SOVOL(MXEXIT),
     $              EOVOL(MXEXIT),TW,SDIF(3,5),SDPM(6,3),BEDWID,BEDWRN,
     $              POR,DB50E,DB50M,WSANDE,RSED(10),SSED(4),BEDDEP,
     $              SDCF1(4,5),SDCF2(4,5),SDCF3(MXEXIT,4,5)
      DOUBLE PRECISION  VOL,VOLS,SDST(3,5)
      INTEGER       DUM1(2134),DUM2(503),DUM3(103),DUM4,DUM5(9),
     $              DUM6(710),DUM7,DUM8(2),DUM9(102),DUM10(602),DUM11,
     $              DUM12(2),DUM13(4764),DUM14(1341),DUM15,DUM16(85),
     $              DUMRCH(7228)
C
      EQUIVALENCE   (ASVEC,HYDRFG),(UNIT,UUNITS),(TIMFG,HRFG),
     $              (DATIM,YR),(ISED,SDIF(1,1)),(SDGPM,BEDWID),
     $              (RSSED,SDST(1,1)),(DEPSCR,SDCF1(1,1)),
     $              (ROSED,SDCF2(1,1)),(OSED,SDCF3(1,1,1))
      INTEGER       ASVEC(11),UNIT(5),TIMFG(6),DATIM(5)
      REAL          ISED(3),SDGPM(3),DEPSCR(4),ROSED(4),OSED(MXEXIT,4)
      DOUBLE PRECISION  RSSED(3)
C     end byte:  72000 word:18000
