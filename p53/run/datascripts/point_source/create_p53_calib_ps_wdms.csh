#!/bin/csh

  if (${#argv} != 1) then
    echo ' '
    echo ' running this script creates calibration point source wdms '
    echo '  It may replace wdms already in use. '
    echo '  Check the script to make sure that the variables are correctly'
    echo '  set before continuing'
    echo ' '
    echo ' To make this script run, type: create_phase53_calib_ps_wdms.csh GO'
    echo ' '
    exit
  endif
  if ($argv[1] != 'GO') then
    if ($argv[1] != 'go') then
      echo ' '
      echo ' running this script creates calibration point source wdms '
      echo '  It may replace wdms already in use. '
      echo '  Check the script to make sure that the variables are correctly'
      echo '  set before continuing'
      echo ' '
      echo ' To make this script run, type: create_phase53_calib_ps_wdms.csh GO'
      echo ' '
      exit
    endif
  endif

  source ../../fragments/set_tree
  mkdir -p ../../../tmp/scratch/temp$$/
  cd ../../../tmp/scratch/temp$$/

############ USER DEFINED VARIABLES, SET THESE BELOW APPROPIRATELY
  set code = $tree/code/bin/create_phase53_calib_ps_wdms.exe
  set psscen = p53cal
  set dataversion = calib_p53_2010_03_18
  set nonCSOfnam = PS_CAL_Non_CSO_2010_03_18.txt
  set CSOfnam = PS_CAL_CSO_2010_03_18.txt
############ END OF USER VARIABLES

######## make directories
  mkdir -p $tree/input/scenario/river/ps/$psscen/
  mkdir -p $tree/input/scenario/river/ps/$psscen/bay_models/

####### run the code
  if (-e problem) then
    rm problem
  endif

  echo $psscen $dataversion $nonCSOfnam $CSOfnam | $code

  if (-e problem) then
    cat problem
    exit
  endif

######### self-documentation
  set notefile =  $tree/input/scenario/river/ps/$psscen/AutoNotes
  if (-e $notefile) then
    rm $notefile
  endif
  echo 'This dataset,' ${psscen} > $notefile
  echo ' was created by' $user >> $notefile
  echo ' ' >> $notefile
  echo ' on' >> $notefile
  date >> $notefile
  echo ' ' >> $notefile
  echo 'Using the code' >> $notefile
  echo $code >> $notefile
  echo ' ' >> $notefile
  echo 'and the data in' >> $notefile
  echo '/model/p5_big_dataset_storage/point_source/'${dataversion}/${nonCSOfnam} >> $notefile
  echo 'and ' >> $notefile
  echo '/model/p5_big_dataset_storage/point_source/'${dataversion}/${CSOfnam} >> $notefile

########## get rid of temp directory
  cd ../
  rm -r temp$$
