#!/bin/csh

  if (${#argv} != 4 ) then
    echo 'usage: run_nps_and_ps_to_JianShen.csh RIVER_SCENARIO POINT_SOURCE_METHOD YEAR1 YEAR2'
    echo '   will look for files in '
    echo '   ../../tmp/wdm/RIVER_SCENARIO/stream'
    echo '   POINT_SOURCE_METHOD must be hcell wcell or lrseg'
    exit
  endif

  set rscen = $argv[1]
  set psmethod = $argv[2]  
  set year1 = $argv[3]
  set year2 = $argv[4]

  source ../fragments/abs_tree
  mkdir -p ../../tmp/scratch/temp$$/
  cd ../../tmp/scratch/temp$$/

      #  hotstart flag: zero for no hotstart, 1 for write, 2 for read
  set hotstart = 0   

  if (!(-e $tree/tmp/wdm/river/$rscen)) then
    echo 'could not find ' $tree/wdm/$rscen
    echo ' check input parameters'
    exit
  endif

  echo 'writing date include file'
  set codedir = ${tree}'/code/src/wqm_load/p5_and_ps_to_JianShen/'
  set fnam = ${codedir}'date.inc'
  echo "       parameter ( year1 = $year1 )" > $fnam
  echo "       parameter ( year2 = $year2 )" >> $fnam
  echo 'compiling'

  cd $codedir
  compile
  cd $tree/tmp/scratch/temp$$/

  mkdir -p $tree/output/wqm_input/$rscen/

  echo 'running'

  if (-e problem) then
    rm problem
  endif

  echo $rscen $psmethod $hotstart | $tree/code/bin/p5_nps_and_ps_to_JianShen.exe

  if (-e problem) then
    cat problem
    rm problem
    exit
  endif

  cd ../
  rm -r temp$$

