      include '../../lib/inc/standard.inc'
      include '../../lib/inc/locations.inc'
      include '../../lib/inc/land_use.inc'
      include '../../lib/inc/wdm.inc'
      include '../../lib/inc/masslinks.inc'
      include '../../lib/inc/modules.inc'


      integer sdate(ndate), edate(ndate)  ! start and end dates 

************** load variables, made of Rvars
      integer maxcons
      parameter (maxcons = 10)     ! max constituents in a load
      integer nloadmax             !
      parameter (nloadmax = 20)    ! maximum number of loads
      integer nloads               ! number of loads
      character*4 loadname(nloadmax)  ! name of each load (e.g. 'totn')
      character*4 unit(nloadmax)      ! units for load (e.g. mg/l cfs )
      integer ncons(nloadmax)     ! number of constituents to each load
      character*4 con(nloadmax,maxcons) ! concentration variable to load
      real confactor(nloadmax,maxcons)  ! factor for the variable


      integer maxDat2Rv     ! number of data types for each river var
      parameter (maxDat2Rv = 10)

************ ps vars
      integer nPSvar(maxRvar)           ! number of PSvars for each Rvar
      integer PSdsn(maxRvar,maxDat2Rv)  ! dsns of PSvars
      character*4 PSname(maxRvar,maxDat2Rv) ! name of PSvars
      real PSfac(maxRvar,maxDat2Rv)      ! conversion factor

************ sep vars
      integer nSEPvar(maxRvar)        ! number of SEPvars for each Rvar
      integer SEPdsn(maxRvar,maxDat2Rv)  ! dsns of SEPvars
      character*4 SEPname(maxRvar,maxDat2Rv) ! name of SEPvars
      real SEPfac(maxRvar,maxDat2Rv)      ! conversion factor

************ atdep vars
      integer nATDEPvar(maxRvar)  ! number of ATDEPvars for each Rvar
      integer ATDEPdsn(maxRvar,maxDat2Rv)  ! dsns of ATDEPvars
      character*4 ATDEPname(maxRvar,maxDat2Rv) ! name of ATDEPvars
      real ATDEPfac(maxRvar,maxDat2Rv)      ! conversion factor



