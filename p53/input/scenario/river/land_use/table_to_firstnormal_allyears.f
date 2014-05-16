************************************************************************
** program to convert 2-D table formatted bmps to first normal 1-D    **
**   format for watershed model.  ignores zero implementation lines   **
************************************************************************
      implicit none
      character*2000 line
      integer maxfields,nfields,nf
      parameter (maxfields=200)

      character*15 BmpName(maxfields)  ! abbreviation for each bmp
      character*3 clu(maxfields)  !  lu abbreviation

      character*13 rseg
      character*6 lseg

      real acres(maxfields)

      character*100 fnam,newfnam

      character*4 cy  ! character year
      integer year

      integer ic  ! comma placment

***************** end of declarations **********************************
      newfnam = 'land_use_p52_fn.csv'
      open(12,file=newfnam,status='unknown')
      print*,newfnam

      do year = 1985,2005

************ open files
        write(cy,'(i4)') year
        fnam = 'land_use_p52_'//cy//'.csv'
        open(11,file=fnam,status='old')
        print*,fnam

        write(12,*) 'SampleYear,ShortName,LandRiverSegment,Acres' ! header

********** read and process first line, saving BMPname
        read(11,'(a2000)') line
        if (line(2000-4:2000).ne.'     ') go to 991
        call shift(line)  ! get rid of rseg header
        call shift(line)  ! get rid of lseg header
        nfields = 0
        do
          call findcomma(line,ic)
          if (ic.eq.0) exit
          nfields = nfields + 1
          read(line,*) clu(nfields)
          call shift(line)
        end do

        print*,'last land use = ',clu(nfields)

************ loop over lines and write all to new file
        do 
          read(11,'(a2000)',end=111) line
          if (line(2000-4:2000).ne.'     ') go to 991
          read(line,*) rseg,lseg,(acres(nf),nf=1,nfields)
          do nf = 1,nfields
            write(12,*) cy,',',clu(nf),',',lseg,rseg,',',acres(nf)
          end do
        end do
111     close(11)
      end do  ! end loop over years

      close(12)
      stop

991   print*,'problem with program'
      print*,' lines to long for variable'
      print*,fnam
      print*,line(:100)

      end

************************************************************************
** subroutine findcomma returns the place number of the next comma    **
**   or one more than the last column occupied by a character if no   **
**   comma found.  if no comma and no data, 'last' is returned as '0' **
************************************************************************
      subroutine findcomma(line,last)
      implicit none
      character*(*) line
      integer i,last
      integer eol
      parameter (eol=13)

      do i = 1,len(line)
        if (line(i:i).eq.',') then
          last = i
          return
        end if
      end do

      last = -1
      do i = 1,len(line)  ! only reaches if comma not found
        if (line(i:i).eq.char(eol)) line(i:i) = ' '
        if (line(i:i).ne.' ') last = i
      end do
      last = last + 1

      end

************************************************************************
** subroutine shift deletes the first character in a character string **
**  and shifts the remaining characters left one place, placing a     **
**  blank in the last place, until a comma is reached                 **
**  useful for reading comma delimited files                          **
************************************************************************
      subroutine shift(line)
      implicit none
      character*(*) line
      integer lenline,comma

      call findcomma(line,comma)
      lenline = len(line)
      line(1:lenline-comma)=line(comma+1:lenline)
      line(lenline-comma+1:lenline) = ' '
      end

