#!/bin/csh

#  this script runs a calibration of the river parameters for water quality
# in the specified basin.  Calibration sensitivities are calculated at all 
# stations in the basin simultaneously for the best overall calibration rather
# than a strict nesting strategy

#   GET SCENARIO AND BASIN (SEGMENT LISTS)
  if (${#argv} != 5) then
    if (${#argv} != 6) then
      echo ' '
      echo 'usage:  run_WQ_stream_optimization.csh scenario calscen basin year1 year2'
      echo ' or     run_WQ_stream_optimization.csh scenario calscen basin year1 year2 tree'
      echo ' '
      exit
    endif
  endif

  set scenario = $argv[1]
  set calscen = $argv[2]
  set basin = $argv[3]
  set year1 = $argv[4]
  set year2 = $argv[5]
  if (${#argv} == 6) then
    set tree = $argv[6]
  else
    source ../../fragments/set_tree
    mkdir -p ../../../tmp/scratch/temp$$/
    cd ../../../tmp/scratch/temp$$/
  endif
#################### FINISHED WITH INPUT

   $tree/run/calibration/WQ/run_postproc_daily.csh $scenario $basin $year1 $year2 $tree

   if (-e problem) then
     echo ' '
     echo ' PROBLEM in run_postproc_daily.csh '
     cat problem
     exit
   endif

   $tree/run/useful/read_dot_out.csh $scenario $basin $year1 $year2 $tree

   if (-e problem) then
     echo ' '
     echo ' PROBLEM in read_dot_out.csh '
     cat problem
     exit
   endif

   grep 'total' $tree/output/river/summary/$scenario/sumout_${basin}.csv >> $tree/output/river/summary/$scenario/sumout_iter_${basin}.csv

  if (${#argv} == 5) then
    cd ../
    rm -r temp$$
  endif