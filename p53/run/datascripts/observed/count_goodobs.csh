#!/bin/csh

  
  set type = $argv[1]
  set year1 = $argv[2]
  set year2 = $argv[3]
  set datascen = $argv[4]
  set basin = $argv[5]

  set code = "../code/count/count_goodobs_${year1}_through_${year2}.exe"

  source ../../../run/seglists/${basin}.riv

  foreach seg ($segments)

    echo  ../$datascen/${type}/${seg}.O${type}  | $code

  end
