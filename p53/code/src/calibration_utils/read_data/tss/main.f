***************************************************************************
**  The purpose of this program is to prepare the observed TSS file      **
**    for any calibration stations.                                      **
**   Stored in /model/p5_observed/tssx/$rseg.otssx                       **
***************************************************************************
      program main
      implicit none

      integer:: dfile
      parameter (dfile=12)                      ! file number 
      character(24):: tree
      parameter (tree='/model/p5_observed/TSSX/')

      character(300):: cline, dline
      character(100):: gagenam                   ! gage file name
      character(100):: obfnam                    ! DATA file name
      character(100):: fnam                      ! TSS file name
      character(100):: infnam                    ! Instantous flow file name

      character(13):: rseg, catnam               ! reiver segment
      character(8):: catid, temid                ! river segmeent ID   
      character(64):: report(3)
      
      integer:: year, month, day
      integer:: hour,minute
      integer:: i, last
      integer:: stat, err 
      
      real:: insflow, dailyflow
      real:: ssc, tss, fss, vss                  ! different forms of sediment
      real:: vtss                                ! found TSS value

      logical:: found

************************* END DECLARATIONS ***********************************

************ open gage file
      gagenam = tree//'gage_riverseg_notes.csv'
      open (unit=dfile,file=gagenam,status='old',iostat=err)
      if (err.ne.0) go to 991

      do 
        read(dfile,100, end=111) cline                ! read header line

***********loop over all river segments
        call findcomma(cline,i)              
        catnam = cline(:i-1)                 ! get the name of river segment
        call trims(catnam,i)
        rseg=catnam(:i)
        call shift(cline)
        call findcomma(cline,last)           ! get the segment ID
        catid = cline(:last-1)

************open data file
	obfnam = tree//'wqflat_jeffQ'
        open (unit=dfile+1,file=obfnam,status='old',iostat=err)
        if (err.ne.0) go to 992

        read (dfile+1,100) dline                             ! skip table header
       
        do
          read(dfile+1,100, end =222) dline                ! read file

************loop over all records for the segment
          temid=dline(:8)
          found=.false.
          if (catid.eq.temid) then
            found = .true.
            if (found) then
            
***********open TSS file to write data
             fnam=tree//rseg//'.OTSSX'
             open (unit=dfile+2,file=fnam,status='unknown',iostat=err)
             if (err.ne.0) go to 993

***********open instantous flow file to write data
             infnam=tree//rseg//'.INFLOW'
             open (unit=dfile+3,file=infnam,status='unknown',iostat=err)
             if (err.ne.0) go to 993
              
              backspace dfile+1
              vtss=-9.0
              read(dfile+1,200,iostat=err) year,month,day,hour,minute,
     .                          insflow,dailyflow,tss,ssc,fss,vss
              if (err.ne.0) go to 994    
              if (ssc .ne. -999.000) then
                vtss=ssc
              else if (tss .ne. -999.000) then
                vtss=tss
              else if (fss .ne. -999.000 .and. vss .ne. -999.000) then
                vtss=fss+vss
              end if
              if (vtss .ne. -9.0) then               ! write TSS data into file
                write(dfile+2,300,err=951) year,month,day,hour,minute,
     .                                      vtss,insflow  
                write(dfile+3,300,err=951) year,month,day,hour,minute,
     .                                insflow, dailyflow
              if (err.ne.0) go to 995
             end if
            end if
          end if  
        end do                                !loop over records for a segment
        close(unit=dfile+3)
        close(unit=dfile+2)
222     close(unit=dfile+1)
     
      end do                                 !loop over segments
 
111   close(dfile)

100   format(a200)
200   format(17x,i4,i2,i2,2x,i2,i2,4x,f10.3,3(5x,f10.3),
     .       15x,f10.3,5x,f10.3)
300   format(i4,',',i2,',',i2,',',i2,',',i2,2(',',f10.3))
      
      return 

************************ ERROR SPACE
951   report(1) = 'error writing to file'
      report(2) = fnam
      report(3) = 'possible permission problem'
      go to 999

991   report(1) = 'Problem with opening gage file'//gagenam
      report(2) = '  Error =    '
      write(report(2)(11:13),'(i3)') err
      report(3) = ' '
      go to 999

992   report(1) = 'Problem opening data file'//obfnam
      report(2) = '  Error =    '
      write(report(2)(11:13),'(i3)') err
      report(3) = ' '
      go to 999

993   report(1) = 'Problem opening TSS file for river segment '//
     .             rseg
      report(2) = '  Error = '
      write(report(2)(11:13),'(i3)') err
      report(3) = ' '
      go to 999

994   report(1) = 'Problem reading data from opened data file '
      report(2) = obfnam
      report(3) = ' '
      go to 999

995   report(1) = ' Could not write data to TSS file'
      report(2) = '  for segment '//rseg
      report(3) = fnam
      go to 999

999   call stopreport(report)

      end program
