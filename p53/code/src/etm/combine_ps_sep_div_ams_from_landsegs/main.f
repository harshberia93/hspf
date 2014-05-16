************************************************************************
** Program to take the pssep wdm for each land segment that drains to **
**   a river segment and add it to the river's pssep wdm              **
************************************************************************

      implicit none

      include 'combine_ps_sep_div_from_landsegs.inc'

      real dvaltemp(ndaymax,maxRvar) ! temp variable for daily values to river

      integer numsegs          ! number of land segments in this river segment
      integer jday,jdaytot        ! julian day 
      real fac1,fac2,fac3
      real SFarea

      character*3 cRvar     ! character representation of integers
      character*25 PsScen,SepScen,DivScen
      integer lenPsScen,lenSepScen,lenDivScen

      character*30 keyword    ! send to subroutine readcontrol

      integer maxvars      ! variables for getdsns
      parameter (maxvars = 11)
      character*3 type        ! send to getdsns
      character*4 Psvarname(maxvars)  ! send to getdsns
      character*4 Sepvarname(maxvars)  ! send to getdsns
      character*4 Divvarname(maxvars)  ! send to getdsns
      character*4 Amsvarname(maxvars)
      integer Psdsns(maxvars)         ! Point Source dsns 
      integer Sepdsns(maxvars)         ! Septic dsns
      integer Divdsns(maxvars)         ! Diversion Dsns
      integer Amsdsns(maxvars)          ! atmos sediment dsns
      integer nPsdsns,nSepdsns,nDivdsns,nAmsdsns  ! number of dsns for each data type
 
      integer i, nv, n      ! indices
      integer nvs(maxRvar)           ! number of values for each type of data

      integer wdmrch,wdmlnd    ! file number for river and land wdms
      parameter (wdmrch=dfile+1)
      parameter (wdmlnd=wdmrch+1)

      integer sdate(ndate), edate(ndate)  ! start and end dates in wdm format
      integer Nexits,lakeflag
      character*1 resflag
      integer timestep

**************** END DECLARATIONS **************************************

      read*,rscen,rseg     ! variables supplied by pp/run/run_river.com

      call lencl(rscen,lenrscen)

      print*,'Making ps_sep_div_ams WDM for ',rseg,' ',rscen(:lenrscen)

********* FIRST GET THE SEGMENTS IN THIS RIVER
      call getl2r(rseg,rscen,lenrscen,
     O            numsegs,l2r)

******** READ THE CONTROL FILE FOR START AND STOP TIME and SCENARIOS
      keyword = 'POINT SOURCE'
      call readcontrol_tp(rscen,lenrscen,keyword,
     .                    T1year,T1month,T1day,
     .                    T2year,T2month,T2day,
     .                    PsScen)
      call lencl(PsScen,lenPsScen)
      keyword = 'SEPTIC'
      call readcontrol_tp(rscen,lenrscen,keyword,
     .                    T1year,T1month,T1day,
     .                    T2year,T2month,T2day,
     .                    SepScen)
      call lencl(SepScen,lenSepScen)
      keyword = 'DIVERSIONS'
      call readcontrol_tp(rscen,lenrscen,keyword,
     .                    T1year,T1month,T1day,
     .                    T2year,T2month,T2day,
     .                    DivScen)
      call lencl(DivScen,lenDivScen)

      call readcontrol_Rioscen(
     I                         rscen,lenrscen,
     O                         ioscen)
      call lencl(ioscen,lenioscen)

******* POPULATE dsns, ndsns for each data type
      type = 'PTS'
      call getdsns(
     I             ioscen,lenioscen,type,maxvars,
     O             nPsdsns,Psvarname,Psdsns)
      type = 'SEP'
      call getdsns(
     I             ioscen,lenioscen,type,maxvars,
     O             nSepdsns,Sepvarname,Sepdsns)
      type = 'DIV'
      call getdsns(
     I             ioscen,lenioscen,type,maxvars,
     O             nDivdsns,Divvarname,Divdsns)
      type = 'AMS'
      call getdsns(
     I             ioscen,lenioscen,type,maxvars,
     O             nAmsdsns,Amsvarname,Amsdsns)
      
******** OPEN THE RIVER PSSEP WDM FILE FOR WRITING
      call lencl(rseg,lenrseg)
      wdmfnam = 'ps_sep_div_ams_'//rscen(:lenrscen)//'_'//
     .           rseg(:lenrseg)//'.wdm' 
      call wdbopnlong(wdmrch,wdmfnam,0,err)    ! open river read/write
      if (err .ne. 0) go to 998

********* GET START AND END DATE IN WDM FORMAT
      sdate(1) = T1year
      sdate(2) = T1month
      sdate(3) = T1day
      sdate(4) = 0
      sdate(5) = 0
      sdate(6) = 0

      edate(1) = T2year
      edate(2) = T2month
      edate(3) = T2day
      edate(4) = 24
      edate(5) = 0
      edate(6) = 0
      
********* GOT ALL STARTING INFORMATION, THE STRATEGY FROM HERE
******** ON OUT IS TO DIRECTLY TRANSFER THE DIVERSIONS, AND THEN
****** LOOP OVER THE LAND SEGMENTS AND ADD THEM TOGETHER FOR POINT
******  SOURCE AND SEPTIC
      print*,' '
      call ttyput('River segment: ')
      call ttyput(rseg)
      print*,' '
      call ttyput(' Diversions: ')
      wdmfnam = ScenDatDir//'river/div/'//DivScen(:lenDivScen)//
     .          '/DIV_'//rseg(:lenrseg)//'.wdm'
      call wdbopnlong(wdmlnd,wdmfnam,1,err)  ! open diversions read only
      if (err.ne.0) go to 998      
      do n = 1,nDivdsns
        call ttyput(Divvarname(n))
        call ttyput(' ')
        call getdailydsn(wdmlnd,sdate,edate,Divdsns(n),nvals,dval)
        call putdailydsn(wdmrch,sdate,edate,Divdsns(n),nvals,dval)
      end do
      call wdflcl (wdmlnd,err)
      if (err.ne.0) go to 996

********* LOOP OVER SEGMENTS and EXTRACT POINT SOURCE VARIABLES
      print*,' '
      call ttyput(' Point Sources: ')
      print*,' '
      call ttyput('  Variables: ')
      do n = 1,nPsdsns
        call ttyput(Psvarname(n))
        call ttyput(' ')
      end do
      print*,' '
      call ttyput('  Land segments: ')
      do n = 1,nPsdsns              ! initialize temp variable
        nvs(n) = 0
        do nv = 1,ndaymax
          dvaltemp(nv,n) = 0.
        end do
      end do

      do i = 1,numsegs

        call lencl(l2r(i),lenlseg)

        call ttyput(l2r(i)(:lenlseg))
        call ttyput(' ')

************ READY TO OPEN WDM FILE
        wdmfnam = ScenDatDir//'river/ps/'//PsScen(:lenPsScen)//
     .            '/ps_'//l2r(i)(:lenlseg)//'_to_'//
     .            rseg(:lenrseg)//'.wdm'
        call wdbopnlong(wdmlnd,wdmfnam,1,err)     ! open land-to-river 
        if (err .ne. 0) go to 998             ! pointsource wdm read only

        do n = 1,nPsdsns
          call getdailydsn(wdmlnd,sdate,edate,Psdsns(n),
     O                            nvals,dval)   
          nvs(n) = max(nvs(n),nvals)
          do nv = 1,nvs(n)
            dvaltemp(nv,n) = dvaltemp(nv,n) + dval(nv)
          end do

        end do            ! end loop over pssep variables

        call wdflcl (wdmlnd,err)
        if (err.ne.0) go to 996

      end do            ! end loop over land segments for river

************* STORE IN NEW WDM
      do n = 1,nPsdsns         ! store in wdm
        do nv = 1,nvs(n)
          dval(nv) = dvaltemp(nv,n)
        end do
        call putdailydsn(wdmrch,sdate,edate,Psdsns(n),nvs(n),dval)
      end do
*************** END OF POINT SOURCE SECTION

********* LOOP OVER SEGMENTS and EXTRACT SEPTIC VARIABLES
      print*,' '
      call ttyput(' Septic: ')
      print*,' '
      call ttyput('  Variables: ')
      do n = 1,nSepdsns
        call ttyput(Sepvarname(n))
        call ttyput(' ')
      end do
      print*,' '
      call ttyput('  Land segments: ')
      do n = 1,nSepdsns              ! initialize temp variable
        nvs(n) = 0
        do nv = 1,ndaymax
          dvaltemp(nv,n) = 0.
        end do
      end do

      do i = 1,numsegs

        call lencl(l2r(i),lenlseg)

        call ttyput(l2r(i)(:lenlseg))
        call ttyput(' ')

************ READY TO OPEN WDM FILE
        wdmfnam = ScenDatDir//'river/septic/'//SepScen(:lenSepScen)//
     .            '/septic_'//l2r(i)(:lenlseg)//'_to_'//
     .            rseg(:lenrseg)//'.wdm'
        call wdbopnlong(wdmlnd,wdmfnam,1,err)     ! open land-to-river 
        if (err .ne. 0) go to 998             ! septic wdm read only

        do n = 1,nSepdsns
          call getdailydsn(wdmlnd,sdate,edate,Sepdsns(n),
     O                            nvals,dval)   
          nvs(n) = max(nvs(n),nvals)
          do nv = 1,nvs(n)
            dvaltemp(nv,n) = dvaltemp(nv,n) + dval(nv)
          end do

        end do            ! end loop over pssep variables

        call wdflcl (wdmlnd,err)
        if (err.ne.0) go to 996

      end do            ! end loop over land segments for river
      
************* STORE IN NEW WDM
      do n = 1,nSepdsns         ! store in wdm
        do nv = 1,nvs(n)
          dval(nv) = dvaltemp(nv,n)
        end do
        call putdailydsn(wdmrch,sdate,edate,Sepdsns(n),nvs(n),dval)
      end do
*************** END OF SEPTIC SECTION
      call readcontrol_Rparamscen(
     I                            rscen,lenrscen,
     O                            paramscen)
      call lencl(paramscen,lenparamscen)
      call getrflags(
     I               paramscen,lenparamscen,rseg,
     O               Nexits,lakeflag,resflag,timestep)

********* SECTION TO ADD AEOLIAN SEDIMENT
      print*,' '
      call ttyput(' Aeolian Sediment: ')
      print*,' '
      call ttyput('  Variables: ')
      do n = 1,nAmsdsns
        call ttyput(Amsvarname(n))
        call ttyput(' ')
      end do
      print*,' '
      
***********GET WATER SURFACE FOR EACH RIVER FROM FTABLE
      if (resflag.eq.'S'.or.resflag.eq.'C'.or.
     .    resflag.eq.'J'                       ) then  ! regular river

        fnam = pardir//'river/'//paramscen(:lenparamscen)//
     .         '/ftables/'//rseg(:lenrseg)//'.ftable'
        open(dfile,file=fnam,status='old',iostat=err)
        if (err.ne.0) go to 991
        
        call read_Sftable(SFarea)
       
      else if (resflag.eq.'V'.or.resflag.eq.'W'.or.
     .         resflag.eq.'R'.or.resflag.eq.'B') then  ! variable ftable reservoir

        fnam = pardir//'river/'//paramscen(:lenparamscen)//
     .         '/variable_ftables/'//rseg(:lenrseg)//'.varftable'
        open(dfile,file=fnam,status='old',iostat=err)
        if (err.ne.0) go to 991

        call read_Vftable(fnam,SFarea)
      
      else

        go to 992

      end if
    
************* STORE IN WDM
      nvals = (T2year-T1year+1)*365   ! get total simulation days
   
      do n = 1,nAmsdsns         
        do nv = 1,nvals
          dval(nv) = SFarea   ! daily water surface
        end do
        call putdailydsn(wdmrch,sdate,edate,Amsdsns(n),nvals,dval)  ! store in wdm
      end do
*************** END OF ATMOS DEPOSITION SECTION

*********** SECTION TO ADD GENERATED OUTFLOW IF CONOWINGO
      if (resflag.eq.'C') 
     .    call resflo(resflag,rscen,rseg,wdmrch,sdate,edate)

      call wdflc1(wdmrch,err)
      if (err.ne.0) go to 995

      print*,' '

      return

********************************* ERROR SPACE **********************************
************* ERROR SPACE **********************************************
991   report(1) = 'Problem opening file:'
      report(2) = fnam
      report(3) = 'error = '
      write(report(3)(9:11),'(i3)')err
      go to 999

992   report(1) = 'rseflag must be S, C, V, W, R, J, or B'
      report(2) = 'S=standard ftables, others=variable ftables'
      report(3) = 'file '//pardir//'river/'//
     .            paramscen(:lenparamscen)//'/gen_info_rseg.csv'
      go to 999

995   report(1) = 'Error: closing river wdm = '
      write(report(1)(28:30),'(i3)')err
      report(2) = ' '
      report(3) = ' '
      go to 999

996   report(1) = 'Error: closing wdm = '
      write(report(1)(22:24),'(i3)')err
      report(2) = ' '
      report(3) = ' '
      go to 999

998   report(1) = wdmfnam
      if (err.eq.0) then
        report(2) = ' is not a wdm file'
      else if (err.eq.-2) then
        report(2) = ' does not exist'
      else
        report(2) = 'Error: opening wdm= '
        write(report(2)(22:24),'(i3)')err
      end if
      report(3) = ' '
      go to 999

999   call stopreport(report)

      end

