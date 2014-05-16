#!/bin/csh

  if (${#argv} != 1) then
    echo ' '
    echo ' generates atmopsheric loads for the estuarine model'
    echo ' '
    echo ' To make this script run, type: run_atdep12_to_wqm57k_CMAQ_scenario.csh GO'
    echo ' make sure all internal script variables are set correctly'
    echo ' '
    exit
  endif
  if ($argv[1] != 'GO') then
    if ($argv[1] != 'go') then
      echo ' '
      echo ' generates atmopsheric loads for the estuarine model'
      echo ' '
      echo ' To make this script run, type: run_atdep12_to_wqm57k_CMAQ_scenario.csh GO'
      echo ' make sure all internal script variables are set correctly'
      echo ' '
      exit
    endif
  endif

  source ../fragments/set_tree
  mkdir -p ../../tmp/scratch/temp$$/
  cd ../../tmp/scratch/temp$$/

############ USER DEFINED VARIABLES, SET THESE BELOW APPROPIRATELY
###### years are the output years for the water quality model
###### atdepscen is the name of the directory for output
###### CMAQbase is the directory above input/unformatted/atdep/CMAQ/
###### CbaseDir2 is the directory above that
###### CbaseSuperLong is the name of the files without the $cell.csv
###### CMAQscen etc., are the same for the scenario to run
###### linkdirectory contains the wqm to cmaq linkage
  set code = $tree/code/bin/atdep12_to_wqm57k_CMAQ_scenario.exe
  set year1 = 1985
  set year2 = 2005
  set atdepscen = 2009_prjct
  set CMAQbase = dry_2009_02_09
  set CbaseDir2 = Chesapeake.base2002.12km
  set CbaseSuperLong = agg.CCTM_M2b_v32soa_v3.4beta3_oceancl2_12km.dep.monthly.colrow
  set CMAQscen = 2009_902
  set CscenDir2 = Chesapeake.pct2009.12km
  set CscenSuperLong = CCTM_N1a_2009cc_med_CL2_v3.4beta3_12km.monthlysum.dep.monthly.colrow
  set linkdirectory = GIS_overlay_2008_06
############ END OF USER VARIABLES


######## make output directory
  mkdir -p $tree/output/wqm_input/atdep/$atdepscen/

######## make date file and compile
  echo 'writing date include file'
  set fnam = $tree/code/src/wqm_load/atdep_to_wqm57k/date.inc
  echo "       parameter ( year1 = $year1 )" > $fnam
  echo "       parameter ( year2 = $year2 )" >> $fnam
  echo 'compiling'

  cd $tree/code/src/wqm_load/atdep_to_wqm57k/
  compile
  cd ../../../../tmp/scratch/temp$$/

####### run the code
  if (-e problem) then
    rm problem
  endif

  echo $atdepscen $linkdirectory $CMAQbase $CbaseDir2 $CbaseSuperLong $CMAQscen $CscenDir2 $CscenSuperLong | $code

  if (-e problem) then
    cat problem
    exit
  endif

######### self-documentation
  set notefile =  $tree/output/wqm_input/atdep/$atdepscen/AutoWqmAtdepNotes
  if (-e $notefile) then
    rm $notefile
  endif
  echo 'This dataset,' ${atdepscen} > $notefile
  echo ' was created by' $user 'on' >> $notefile
  date >> $notefile
  echo ' ' >> $notefile
  echo 'Using the code' >> $notefile
  echo $code >> $notefile
  echo ' ' >> $notefile
  echo ' The base CMAQ dry deposition is from '$CMAQbase >> $notefile
  echo ' The CMAQ scenario is from '$CMAQscen >> $notefile
  echo ' and the cell sizes in ' $linkdirectory >> $notefile
  echo ' ' >> $notefile

########## get rid of temp directory
  cd ../
  rm -r temp$$



