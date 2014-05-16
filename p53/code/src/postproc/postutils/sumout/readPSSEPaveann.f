************************************************************************
**  writes out the edge-of-stream loads by year                       **
************************************************************************
      subroutine  readPSSEPaveann
     I                         (rscen,onelseg,rseg,
     I                          type,year1,year2,
     I                          nloads,loadname,nloadmax,
     O                          ps,sep)
     
      implicit none
      include '../../../lib/inc/standard.inc'
      include '../../../lib/inc/locations.inc'

      integer nloadmax

      character*(*) onelseg    ! land use segment
      character*(*) type  ! eos,eof,del
      character*4 loadname(nloadmax)
      integer nloads

      integer year1,year2,y1,y2
      character*4 cyear1,cyear2

      real ps(nloadmax),sep(nloadmax)

      integer nl   ! index

************** END DECLARATION **************************************


      call lencl(rscen,lenrscen)
      call lencl(rseg,lenrseg)
      call lencl(onelseg,lenlseg)
      write(cyear1,'(i4)') year1
      write(cyear2,'(i4)') year2

************* eof = eos for these constituents

************ pointsource
      fnam = outdir//'eos/aveann/'//rscen(:lenrscen)//
     .           '/'//onelseg(:lenlseg)//'_to_'//rseg(:lenrseg)//
     .           '_pointsource_'//cyear1//'-'//cyear2//'.ave'
      if (type.eq.'del') then
        fnam = outdir//'del/lseg/aveann/'//rscen(:lenrscen)//
     .           '/'//onelseg(:lenlseg)//'_to_'//rseg(:lenrseg)//
     .           '_pointsource_'//cyear1//'-'//cyear2//'.ave'
      end if
      open(11,file=fnam,status='old',iostat=err)
      if (err.ne.0) go to 991

      read(11,'(a8)') line
      if (line(:8).eq.'NO LOADS') then
        do nl = 1,nloads
          ps(nl) = 0.0
        end do
      else      
        read(11,1234,err=992) y1,y2,(ps(nl),nl=1,nloads)
      end if
      close (11)

************ septic
      fnam = outdir//'eos/aveann/'//rscen(:lenrscen)//
     .           '/'//onelseg(:lenlseg)//'_to_'//rseg(:lenrseg)//
     .           '_septic_'//cyear1//'-'//cyear2//'.ave'
      if (type.eq.'del') then
        fnam = outdir//'del/lseg/aveann/'//rscen(:lenrscen)//
     .           '/'//onelseg(:lenlseg)//'_to_'//rseg(:lenrseg)//
     .           '_septic_'//cyear1//'-'//cyear2//'.ave'
      end if
      open(11,file=fnam,status='old',iostat=err)
      if (err.ne.0) go to 991

      read(11,'(a8)') line
      if (line(:8).eq.'NO LOADS') then
        do nl = 1,nloads
          sep(nl) = 0.0
        end do
      else 
        read(11,1234,err=992) y1,y2,(sep(nl),nl=1,nloads)
      end if
      close (11)

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