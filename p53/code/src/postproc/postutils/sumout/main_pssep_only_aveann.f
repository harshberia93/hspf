************************************************************************
** program to summarize output in the ./sumout/ diretory              **
**  output is initially by lrseg and land use or data type            **
**  this program takes the input of a river basin and summarizes by   **
**  land use type, by data type, by lseg, by river seg, and by basin  **
************************************************************************
      implicit none
      include '../../../lib/inc/standard.inc'
      include '../../../lib/inc/locations.inc'
      include '../../../lib/inc/rsegs.inc'
      include '../../../lib/inc/lsegs.inc'
      include '../../../lib/inc/masslinks.inc'
      include '../../../lib/inc/modules.inc'
      include '../../../lib/inc/land_use.inc'


******** define load variables
      integer nloadmax             !
      parameter (nloadmax = 20)    ! maximum number of loads
      integer nloads               ! number of loads
      character*4 loadname(nloadmax)  ! name of each load (e.g. 'totn')

********* reading variables for loads
      real EOFps(nloadmax) 
      real EOFsep(nloadmax) 

      real EOSps(nloadmax) 
      real EOSsep(nloadmax) 

      real DELps(nloadmax) 
      real DELsep(nloadmax) 

********** accumulations of load
      real allEOFps(nloadmax+1) 
      real allEOFsep(nloadmax+1) 

      real allEOSps(nloadmax+1) 
      real allEOSsep(nloadmax+1) 

      real allDELps(nloadmax+1) 
      real allDELsep(nloadmax+1) 

********** indices and accounting variables
      integer nr,ns,nl,nrseg,nload   ! indices

      integer numsegs ! number of lsegs associated with an rseg

      character*200 basin

      integer lenbasin

      logical found

      character*3 EOF,EOS,DEL
      data EOF,EOS,DEL /'eof','eos','del'/

      integer year1,year2
      character*4 cy1,cy2

      integer iEOF,iEOS,iDEL  ! input flags 
      logical doEOF,doEOS,doDEL  ! logical values
      data doEOF,doEOS,doDEL /.false.,.false.,.false./

      integer fnAllLoads   ! all data file
      parameter (fnAllLoads=14)

************ several different schemes for calculating Delivery
******** user specifies which one to use
      character*3 DFmethod  ! possible values 'seg','bas','res'

************ END DECLARATIONS ******************************************

      read(*,*,err=997,end=998) rscen,basin,year1,year2,
     .                          iEOF,iEOS,iDEL,DFmethod

      call lowercase(DFmethod)  ! check for correct DFmethod
      if (DFmethod.ne.'seg'.and.DFmethod.ne.'bas'
     .                     .and.DFmethod.ne.'res') go to 992

      write(cy1,'(i4)') year1
      write(cy2,'(i4)') year2

      if (iEOF.ne.0) doEOF = .true.
      if (iEOS.ne.0) doEOS = .true.
      if (iDEL.ne.0) doDEL = .true.
      call lencl(basin,lenbasin)
      call lencl(rscen,lenrscen) 

      print*,'summarizing average annual data output for scenario ',
     .       rscen(:lenrscen),' river basin ',basin(:lenbasin)

*********** open all data files to feed scenario builder postprocessor
      fnam = sumoutdir//'aveann/'//rscen(:lenrscen)//
     .     '/AllPSsep_'//basin(:lenbasin)//'_'//cy1//'_'//cy2//'_'//
     .     rscen(:lenrscen)//'_'//DFmethod//'.csv'
      open(fnAllLoads,file=fnam,status='unknown',iostat=err)
      if (err.ne.0) go to 991

************* read in river segments
      call readRiverSeglist(
     I                      basin,
     O                      rsegs,nrsegs)

******* POPULATE nRvar, Rdsn, nLvar, Ldsn, Lname, Lfactor
      call readcontrol_modules(rscen,lenrscen,
     O                         modules,nmod)

      call masslinksmall(rscen,lenrscen,modules,nmod,
     O                   nRvar,Rname)

      call loadinfosmall(rscen,lenrscen,nRvar,Rname,
     O                   nloads,loadname)


************ initialize variables
************ initialize variables
      do nl = 1,nloadmax+1
        allEOFps(nl) = 0.0
        allEOFsep(nl) = 0.0
        allEOSps(nl) = 0.0
        allEOSsep(nl) = 0.0
        allDELps(nl) = 0.0
        allDELsep(nl) = 0.0

      end do

*********** populate variables by reading ASCII output
************ loop over river segs
      do nrseg = 1,nrsegs
        call ttyput(rsegs(nrseg)//' ')
        call getl2r(
     I              rsegs(nrseg),rscen,lenrscen,
     O              numsegs,l2r)

************** loop over land segs in river seg
        do ns = 1,numsegs

          if (doEOF) then
            call readPSSEPaveann(
     I                         rscen,l2r(ns),rsegs(nrseg),
     I                         EOF,year1,year2,
     I                         nloads,loadname,nloadmax,DFmethod,
     O                         EOFps,EOFsep)
            do nload = 1,nloads
              allEOFps(nload) = allEOFps(nload) + EOFps(nload)
              allEOFsep(nload) = allEOFsep(nload) + EOFsep(nload)
            end do
          end if

          if (doEOS) then
            call readPSSEPaveann(
     I                         rscen,l2r(ns),rsegs(nrseg),
     I                         EOS,year1,year2,
     I                         nloads,loadname,nloadmax,DFmethod,
     O                         EOSps,EOSsep)
            do nload = 1,nloads
              allEOSps(nload) = allEOSps(nload) + EOSps(nload)
              allEOSsep(nload) = allEOSsep(nload) + EOSsep(nload)
            end do
          end if

          if (doDEL) then
            call readPSSEPaveann(
     I                         rscen,l2r(ns),rsegs(nrseg),
     I                         DEL,year1,year2,
     I                         nloads,loadname,nloadmax,DFmethod,
     O                         DELps,DELsep)
            do nload = 1,nloads
              allDELps(nload) = allDELps(nload) + DELps(nload)
              allDELsep(nload) = allDELsep(nload) + DELsep(nload)
            end do
          end if

        end do   ! loop over lsegs in rseg
      end do   ! loop over rsegs in basin
      print*,' '
      close (fnAllLoads)
           
************ write output
      if (doEOF) then
        fnam = sumoutdir//'aveann/'//rscen(:lenrscen)//
     .       '/'//basin(:lenbasin)//'_'//cy1//'_'//cy2//'_pssep_EOF.csv'
        print*,fnam(:78)
        open(11,file=fnam,status='unknown',iostat=err)
        if (err.ne.0) go to 991

        write(11,1233,err=951)'specifier',
     .                        (',',loadname(nload),nload=1,nloads)
        write(11,1234,err=951)'pointsource',
     .                        (',',allEOFps(nload),nload=1,nloads)
        write(11,1234,err=951) 'septic',
     .                        (',',allEOFsep(nload),nload=1,nloads)
  
        close(11)

      end if

      if (doEOS) then
        fnam = sumoutdir//'aveann/'//rscen(:lenrscen)//
     .       '/'//basin(:lenbasin)//'_'//cy1//'_'//cy2//'_pssep_EOS.csv'
        print*,fnam(:78)
        open(11,file=fnam,status='unknown',iostat=err)
        if (err.ne.0) go to 991

        write(11,1233,err=951)'specifier',
     .                        (',',loadname(nload),nload=1,nloads)
        write(11,1234,err=951)'pointsource',
     .                        (',',allEOSps(nload),nload=1,nloads)
        write(11,1234,err=951) 'septic',
     .                        (',',allEOSsep(nload),nload=1,nloads)

        close(11)

      end if

      if (doDEL) then
        fnam = sumoutdir//'aveann/'//rscen(:lenrscen)//
     .       '/'//basin(:lenbasin)//'_'//cy1//'_'//cy2//'_pssep_DEL_'//
     .       DFmethod//'.csv'
        print*,fnam(:78)
        open(11,file=fnam,status='unknown',iostat=err)
        if (err.ne.0) go to 991

        write(11,1233,err=951)'specifier',
     .                        (',',loadname(nload),nload=1,nloads)
        write(11,1234,err=951)'pointsource',
     .                        (',',allDELps(nload),nload=1,nloads)
        write(11,1234,err=951) 'septic',
     .                        (',',allDELsep(nload),nload=1,nloads)

        close(11)

      end if

      stop

1234  format(a,20(a1,e14.7))
1233  format(a,20(a1,a4))

************* ERROR SPACE ****************
951   report(1) = 'error writing to file'
      report(2) = fnam
      report(3) = 'possible permission problem'
      go to 999

991   report(1) = 'Problem opening file:'
      report(2) = fnam
      report(3) = 'error = '
      write(report(3)(9:11),'(i3)')err
      go to 999

992   report(1) = 'Delivery Factor method must be'
      report(2) = 'res - reservoir, seg - segment, bas - basin'
      report(3) = 'method read was '//DFmethod
      go to 999

997   report(1) = 'Error initializing sumout program'
      report(2) = 'mismatch of data types between program expectation'
      report(3) = ' and calling script'
      go to 999

998   report(1) = 'Error initializing land postprocessor'
      report(2) = 'not enough input data in calling script'
      report(3) = ' '
      go to 999

999   call stopreport(report)

      end


