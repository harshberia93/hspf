************************************************************************
** this program gets all the non-land associated loads                **
**  point source, septic, and atmospheric deposition.                 **
**  They are associated with a specific land seg / water seg pair     **
************************************************************************
      implicit none

      include 'data.inc'

****************  daily load
      real dPSrvar(ndaymax,maxRvar) ! daily by river var
      real dATDEPrvar(ndaymax,maxRvar) ! daily by river var
      real dSEPrvar(ndaymax,maxRvar) ! daily by river var
      real dPSload(ndaymax,nloadmax)     ! daily by load var
      real dATDEPload(ndaymax,nloadmax)     ! daily by load var
      real dSEPload(ndaymax,nloadmax)     ! daily by load var

      integer outfil,datwdm,wdmrch
      parameter (outfil=dfile+1)    ! file number for output
      parameter (datwdm=dfile+2)     ! file number for point source
      parameter (wdmrch=dfile+5)    ! file number for fake wdm

      real wateracres(ndaymax)   ! acre to multiply atdep

      integer numsegs          ! number of land segments with this river

      character*11 ps,sep,atdep         ! atdep, pointsource, or septic
      data ps,sep,atdep /'pointsource','septic','atdep'/

      character*25 pradscen, psscen, sepscen
      integer lenpradscen, lenpsscen, lensepscen

************* output flags
      integer idaily,imonthly,iannual,iaveann
      logical daily,monthly,annual,aveann

      integer year1,year2,hour,jday,ndays
      integer nv,nvar,Rvar,nc,ns,nl

      integer julian
      external julian

      logical doatdep,dops,dosep

***************** END DECLARATIONS *************************************

      read(*,*,err=995,end=996) rscen,rseg,
     .                          idaily,imonthly,iannual,iaveann,
     .                          year1,year2

      call lencl(rscen,lenrscen)
      call lencl(rseg,lenrseg)

      daily = .true.
      if (idaily.eq.0) daily = .false.
      monthly = .true.
      if (imonthly.eq.0) monthly = .false.
      annual = .true.
      if (iannual.eq.0) annual = .false.
      aveann = .true.
      if (iaveann.eq.0) aveann = .false.

      print*,'creating data output for ',rseg,' ',rscen(:lenrscen)

********  open FAKE WDM file, used ONLY to solve the problem of
*******       opening and closing WDM file, never close this file
      call lencl(rseg,lenrseg)
      wdmfnam = dummyWDMname
      call wdbopnlong(wdmrch,wdmfnam,0,err)
      if (err .ne. 0) go to 998

********* FIRST GET THE SEGMENTS IN THIS RIVER
      call getl2r(rseg,rscen,lenrscen,
     O            numsegs,l2r)

******** READ THE CONTROL FILE FOR START AND STOP TIME
      call readcontrol_time(rscen,lenrscen,
     O                      sdate,edate)
      sdate(4) = 0
      sdate(5) = 0
      sdate(6) = 0
      edate(4) = 24
      edate(5) = 0
      edate(6) = 0

      ndays = julian(sdate(1),sdate(2),sdate(3),
     .               edate(1),edate(2),edate(3))

*********** READ CONTROL FILE FOR SCENARIOS

      call readcontrol_wdm(rscen,lenrscen,
     O                     pradscen,psscen,sepscen,
     O                     doatdep,dops,dosep)  ! names of wdms
      call lencl(psscen,lenpsscen)
      call lencl(sepscen,lensepscen)
      call lencl(pradscen,lenpradscen)

******* POPULATE variables
      call readcontrol_modules(   ! get active modules
     I                         rscen,lenrscen,
     O                         modules,nmod)
      call readcontrol_Rioscen(
     I                         rscen,lenrscen,
     O                         ioscen)
      call lencl(ioscen,lenioscen)

      call getRvars(              ! get active Rvars
     I              ioscen,lenioscen,
     I              modules,nmod,
     O              nRvar,Rname)

      call loadinfo(            ! get loads for active Rvars
     I              ioscen,lenioscen,
     I              nRvar,Rname,
     O              nloads,loadname,unit,ncons,con,confactor)

      if (dops) then
        call getvars(
     I               ioscen,lenioscen,
     I               nRvar,Rname,ps,
     O               nPSvar,PSdsn,PSname,PSfac)
      end if

      if (dosep) then
        call getvars(
     I               ioscen,lenioscen,
     I               nRvar,Rname,sep,
     O               nSEPvar,SEPdsn,SEPname,SEPfac)
      end if

      if (doatdep) then
        call getvars(
     I               ioscen,lenioscen,
     I               nRvar,Rname,atdep,
     O               nATDEPvar,ATDEPdsn,ATDEPname,ATDEPfac)
      end if

      do ns = 1,numsegs

        call lencl(l2r(ns),lenlseg)

        call ttyput('  land segment ')
        call ttyput(l2r(ns)(:lenlseg))

        do Rvar = 1,nRvar    ! initialize
          do nv = 1,ndaymax
            dPSrvar(nv,Rvar) = 0.0
            dATDEPrvar(nv,Rvar) = 0.0
            dSEPrvar(nv,Rvar) = 0.0
          end do
        end do

***************** POINT SOURCE SECTION

        if (dops) then

          call ttyput(' Point Source, ')

          wdmfnam = ScenDatDir//'river/ps/'//psscen(:lenpsscen)//
     .       '/ps_'//l2r(ns)(:lenlseg)//'_to_'//rseg(:lenrseg)//'.wdm'
          call wdbopnlong(datwdm,wdmfnam,0,err)
          if (err .ne. 0) go to 998     ! open ps wdm

          do Rvar = 1,nRvar
            if (nPSvar(Rvar).le.0) cycle
            do nvar = 1,nPSvar(Rvar)
              call getdailydsn(datwdm,sdate,edate,PSdsn(Rvar,nvar),
     O                         nvals,dval)
              nvals = nvals - 1
              if (nvals.ne.ndays) go to 990

              do nv = 1,ndays
                dPSrvar(nv,Rvar) = dPSrvar(nv,Rvar) 
     .                           + dval(nv) * PSfac(Rvar,nvar)
              end do
            end do
          end do

          call wdflcl(datwdm,err)
          if (err.ne.0) go to 997

        end if


***************** SEPTIC SECTION

        if (dosep) then
          call ttyput('Septic, ')

          wdmfnam = ScenDatDir//'river/septic/'//sepscen(:lensepscen)//
     .              '/septic_'//l2r(ns)(:lenlseg)//'_to_'//
     .              rseg(:lenrseg)//'.wdm'
          call wdbopnlong(datwdm,wdmfnam,0,err)
          if (err .ne. 0) go to 998     ! open septic wdm

          do Rvar = 1,nRvar
            if (nSEPvar(Rvar).le.0) cycle
            do nvar = 1,nSEPvar(Rvar)
              call getdailydsn(datwdm,sdate,edate,SEPdsn(Rvar,nvar),
     O                         nvals,dval)
              nvals = nvals - 1
              if (nvals.ne.ndays) go to 990
  
              do nv = 1,ndays
                dSEPrvar(nv,Rvar) = dSEPrvar(nv,Rvar)
     .                            + dval(nv) * SEPfac(Rvar,nvar)
              end do
            end do
          end do

          call wdflcl(datwdm,err)
          if (err.ne.0) go to 997

        end if

***************** ATMOSPHERIC DEPOSITION SECTION

        if (doatdep) then
          call ttyput('Atmospheric Deposition')

          wdmfnam = ScenDatDir//'climate/prad/'//pradscen(:lenpradscen)
     .              //'/prad_'//l2r(ns)(:lenlseg)//'.wdm'
          call wdbopnlong(datwdm,wdmfnam,0,err)
          if (err .ne. 0) go to 998                  ! open atdep wdm

          call getwateracres(
     I                       rscen,lenrscen,rseg,l2r(ns),
     I                       sdate,edate,
     O                       wateracres)

          do Rvar = 1,nRvar
            if (nATDEPvar(Rvar).le.0) cycle
            do nvar = 1,nATDEPvar(Rvar)
              call getdailydsn(datwdm,sdate,edate,ATDEPdsn(Rvar,nvar),
     O                         nvals,dval)
  
              nvals = nvals - 1
              if (nvals.ne.ndays) go to 990

              do jday = 1,ndays
                dATDEPrvar(jday,Rvar) = dATDEPrvar(jday,Rvar)
     .            + dval(jday) * ATDEPfac(Rvar,nvar) * wateracres(jday)
              end do
            end do
          end do

          call wdflcl(datwdm,err)
          if (err.ne.0) go to 997

        end if

*********** convert to daily loads
        do nl = 1,nloads

          do nv = 1,ndays  ! initialize
            dPSload(nv,nl) = 0.0
            dATDEPload(nv,nl) = 0.0
            dSEPload(nv,nl) = 0.0
          end do

          do nc = 1,ncons(nl)
            do Rvar = 1,nRvar        ! get the right dsn
              if (con(nl,nc).eq.Rname(Rvar)) then
                do nv = 1,ndays
                  dPSload(nv,nl) = dPSload(nv,nl)
     .                         + dPSrvar(nv,Rvar) * confactor(nl,nc)
                  dSEPload(nv,nl) = dSEPload(nv,nl)
     .                         + dSEPrvar(nv,Rvar) * confactor(nl,nc)
                  dATDEPload(nv,nl) = dATDEPload(nv,nl)
     .                         + dATDEPrvar(nv,Rvar) * confactor(nl,nc)
                end do
              end if
            end do
          end do
        end do

***************** output section
        if (daily) then
          call writeDATdaily(rscen,l2r(ns),rseg,outfil,sdate,
     .                       dops,wateracres,ps,
     .                       ndays,nloads,loadname,dPSload)
          call writeDATdaily(rscen,l2r(ns),rseg,outfil,sdate,
     .                       dosep,wateracres,sep,
     .                       ndays,nloads,loadname,dSEPload)
          call writeDATdaily(rscen,l2r(ns),rseg,outfil,sdate,
     .                       doatdep,wateracres,atdep,
     .                       ndays,nloads,loadname,dATDEPload)
        end if

        if (monthly) then
          call writeDATmonthly(rscen,l2r(ns),rseg,outfil,sdate,
     .                         dops,wateracres,ps,
     .                         ndays,nloads,loadname,dPSload)
          call writeDATmonthly(rscen,l2r(ns),rseg,outfil,sdate,
     .                         dosep,wateracres,sep,
     .                         ndays,nloads,loadname,dSEPload)
          call writeDATmonthly(rscen,l2r(ns),rseg,outfil,sdate,
     .                         doatdep,wateracres,atdep,
     .                         ndays,nloads,loadname,dATDEPload)
        end if

        if (annual) then
          call writeDATannual(rscen,l2r(ns),rseg,outfil,sdate,
     .                        dops,wateracres,ps,
     .                        ndays,nloads,loadname,dPSload)
          call writeDATannual(rscen,l2r(ns),rseg,outfil,sdate,
     .                        dosep,wateracres,sep,
     .                        ndays,nloads,loadname,dSEPload)
          call writeDATannual(rscen,l2r(ns),rseg,outfil,sdate,
     .                        doatdep,wateracres,atdep,
     .                        ndays,nloads,loadname,dATDEPload)
        end if

        if (aveann) then
          call writeDATaveann(rscen,l2r(ns),rseg,outfil,sdate,
     .                        dops,wateracres,ps,
     .                        ndays,nloads,loadname,dPSload,
     .                        year1,year2)
          call writeDATaveann(rscen,l2r(ns),rseg,outfil,sdate,
     .                        dosep,wateracres,sep,
     .                        ndays,nloads,loadname,dSEPload,
     .                        year1,year2)
          call writeDATaveann(rscen,l2r(ns),rseg,outfil,sdate,
     .                        doatdep,wateracres,atdep,
     .                        ndays,nloads,loadname,dATDEPload,
     .                        year1,year2)
        end if

        print*,' '
      end do          ! end loop over land segs in river segs


      return

************************ ERROR SPACE *************************
990   report(1) = 'problem in wdm '//wdmfnam
      report(2) = 'difference between expected days and read days'
      write(report(3),*)'exp ',ndays,' read ',nvals
      go to 999


995   report(1) = 'Error initializing data postprocessor'
      report(2) = 'mismatch of data types between program expectation'
      report(3) = ' and run_postproc.csh'
      go to 999

996   report(1) = 'Error initializing data postprocessor'
      report(2) = 'not enough input data in run_postproc.csh'
      report(3) = ' '
      go to 999

997   report(1) = 'Error:  closing wdm'
      report(2) = wdmfnam
      report(3) = 'Error = '
      write(report(3)(9:11),'(i3)') err
      go to 999

998   report(1) = 'Error: opening wdm= '
      report(2) = wdmfnam
      if (err.lt.0) then
        report(3) = 'Error = '
        write(report(3)(9:11),'(i3)') err
      else
        report(3) = 'Not a wdm file'
      end if
      go to 999

999   call stopreport(report)

      end


