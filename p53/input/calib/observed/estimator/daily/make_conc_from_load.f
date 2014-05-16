      implicit none
      character*50 fnam

      integer year,month,day,zero
      real flow(1980:2005,12,31)  ! (cfs)
      real load  ! (kg/day)
      real conc  ! (mg/l)

      real convert
      parameter (convert=1000000.0/3600.0/24.0/28.317)

      read*,fnam 
      open(11,file=fnam,status='old')
      fnam(20:) = 'CONC.csv'
      open(12,file=fnam,status='unknown')
      fnam = '../../FLOW/'//fnam(:13)//'.OFLOW'
      open(13,file=fnam,status='old')

      do year = 1980,2005
        do month = 1,12
          do day = 1,31
            flow(year,month,day) = -9.0
          end do
        end do
      end do

      do
        read(13,*,end=111) year,month,day,zero,zero,flow(year,month,day)
      end do
111   close(13)

      do 
        read(11,*,end=222) year,month,day,zero,zero,load
        if (flow(year,month,day).le.0.0) then
          conc = -9.0
        else
          conc = load/flow(year,month,day)*convert
        end if
        write(12,*)year,',',month,',',day,',',zero,',',zero,',',conc
      end do
222   close(11)
      close(12)
      end

