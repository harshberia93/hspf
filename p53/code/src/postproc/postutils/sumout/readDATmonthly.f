************************************************************************
**  writes out the edge-of-stream loads by year                       **
************************************************************************
      subroutine  readDATmonthly
     I                         (rscen,onelseg,rseg,
     I                          type,year1,year2,
     I                          nloads,loadname,nloadmax,
     O                          ps,sep,atdep)
     
      implicit none
      include '../../../lib/inc/standard.inc'
      include '../../../lib/inc/locations.inc'

      integer nloadmax

      character*(*) onelseg    ! land use segment
      character*(*) type  ! eos,eof,del
      character*4 loadname(nloadmax)
      integer nloads

      integer year1,year2,nm,ny
      character*4 cyear1,cyear2

      real ps(nloadmax,year1:year2,12)
      real sep(nloadmax,year1:year2,12)
      real atdep(nloadmax,year1:year2,12)

      integer nl   ! index

************** END DECLARATION **************************************


      call lencl(rscen,lenrscen)
      call lencl(rseg,lenrseg)
      call lencl(onelseg,lenlseg)
      write(cyear1,'(i4)') year1
      write(cyear2,'(i4)') year2

************* eof = eos for these constituents

************ pointsource
      fnam = outdir//'eos/monthly/'//rscen(:lenrscen)//
     .           '/'//onelseg(:lenlseg)//'_to_'//rseg(:lenrseg)//
     .           '_pointsource.mon'
      if (type.eq.'del') then
        fnam = outdir//'del/lseg/monthly/'//rscen(:lenrscen)//
     .           '/'//onelseg(:lenlseg)//'_to_'//rseg(:lenrseg)//
     .           '_pointsource.mon'
      end if
      open(11,file=fnam,status='old',iostat=err)
      if (err.ne.0) go to 991

      do nm = 1,12
        do ny = year1,year2
          do nl = 1,nloads
            ps(nl,ny,nm) = 0.0
          end do
        end do
      end do
      read(11,'(a8)') line
      if (line(:8).ne.'NO LOADS') then
        do
          read(11,*,err=992,end=111) ny
          if (ny.ge.year1.and.ny.le.year2) then
            backspace 11
            read(11,*,err=992) ny,nm,(ps(nl,ny,nm),nl=1,nloads)
          end if
        end do
      end if
111   close (11)

************ septic
      fnam = outdir//'eos/monthly/'//rscen(:lenrscen)//
     .           '/'//onelseg(:lenlseg)//'_to_'//rseg(:lenrseg)//
     .           '_septic.mon'
      if (type.eq.'del') then
        fnam = outdir//'del/lseg/monthly/'//rscen(:lenrscen)//
     .           '/'//onelseg(:lenlseg)//'_to_'//rseg(:lenrseg)//
     .           '_septic.mon'
      end if
      open(11,file=fnam,status='old',iostat=err)
      if (err.ne.0) go to 991

      do nm = 1,12
        do ny = year1,year2
          do nl = 1,nloads
            sep(nl,ny,nm) = 0.0
          end do
        end do
      end do
      read(11,'(a8)') line
      if (line(:8).ne.'NO LOADS') then
        do
          read(11,*,err=992,end=222) ny
          if (ny.ge.year1.and.ny.le.year2) then
            backspace 11
            read(11,*,err=992) ny,nm,(sep(nl,ny,nm),nl=1,nloads)
          end if
        end do
      end if
222   close (11)

************ atdep
      fnam = outdir//'eos/monthly/'//rscen(:lenrscen)//
     .           '/'//onelseg(:lenlseg)//'_to_'//rseg(:lenrseg)//
     .           '_atdep.mon'
      if (type.eq.'del') then
        fnam = outdir//'del/lseg/monthly/'//rscen(:lenrscen)//
     .           '/'//onelseg(:lenlseg)//'_to_'//rseg(:lenrseg)//
     .           '_atdep.mon'
      end if
      open(11,file=fnam,status='old',iostat=err)
      if (err.ne.0) go to 991

      do nm = 1,12
        do ny = year1,year2
          do nl = 1,nloads
            atdep(nl,ny,nm) = 0.0
          end do
        end do
      end do
      read(11,'(a8)') line
      if (line(:8).ne.'NO LOADS') then
        do
          read(11,*,err=992,end=333) ny
          if (ny.ge.year1.and.ny.le.year2) then
            backspace 11
            read(11,*,err=992) ny,nm,(atdep(nl,ny,nm),nl=1,nloads)
          end if
        end do
      end if
333   close (11)

      return

1001  format(a15,',',60(5x,a4,','))
1234  format(i5,1x,i4,60(1x,e14.7))

**************ERROR SPACE ******************************************
991   report(1) = 'Problem opening following file'
      report(2) = fnam
      report(3) = ' '
      go to 999

992   report(1) = 'Problem reading following file'
      report(2) = fnam
      report(3) = ' problem with reading load line' 
      go to 999

999   call stopreport(report)

      end
