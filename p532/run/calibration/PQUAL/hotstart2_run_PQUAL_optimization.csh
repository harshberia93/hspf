#!/bin/csh
#   GET SCENARIO AND BASIN (SEGMENT LISTS)

  if (${#argv} != 4) then
    if (${#argv} != 5) then
      echo ' '
      echo 'usage:  run_PQUAL_optimization.csh scenario calib_scen basin landuse'
      echo ' or     run_PQUAL_optimization.csh scenario calib_scen basin landuse tree'
      echo ' '
      exit
    endif
  endif

  set scenario = $argv[1]
  set calscen = $argv[2]
  set basin = $argv[3]
  set lu = $argv[4]
  if (${#argv} == 5) then
    set tree = $argv[5]
  else
    source ../../fragments/set_tree
    mkdir -p ../../../tmp/scratch/temp$$
    cd ../../../tmp/scratch/temp$$
  endif

  set nums = (1 2 3 4 5 6 7 8 9 10)

  cp $tree/config/seglists/${basin}.land $tree/config/seglists/${basin}_${lu}_PQUAL.land

     $tree/run/calibration/PQUAL/compile_PQUAL_opt.csh $calscen $tree
     echo $calscen, $scenario ${basin}_${lu}_PQUAL $lu | $tree/code/bin/calib_iter_PQUAL_params_${calscen}.exe
     if (-e problem) then
       echo $scenario $basin $lu 1985 2005 | $tree/code/bin/pltgen_annave_summary.exe
       echo 'message from parameter change program, run number: ',$num
       cat problem
       rm problem
       exit
     endif

  foreach num ($nums)
    
    $tree/run/calibration/PQUAL/run_PQUAL_iter.csh $scenario ${basin}_${lu}_PQUAL $lu $tree

     if (-e problem) then
       echo 'problem in run number: ',$num
       cat problem
       rm problem
       exit
     endif

     $tree/run/calibration/PQUAL/compile_PQUAL_opt.csh $calscen $tree
     echo $calscen, $scenario ${basin}_${lu}_PQUAL $lu | $tree/code/bin/calib_iter_PQUAL_params_${calscen}.exe
     if (-e problem) then
       echo $scenario $basin $lu 1985 2005 | $tree/code/bin/pltgen_annave_summary.exe
       echo 'message from parameter change program, run number: ',$num
       cat problem
       rm problem
       exit
     endif

  end

  $tree/run/calibration/PQUAL/run_PQUAL_iter.csh $scenario ${basin}_${lu}_PQUAL $lu $tree

  if (-e problem) then
    echo 'problem in run number: ',$num
    cat problem
    rm problem
    exit
  endif
