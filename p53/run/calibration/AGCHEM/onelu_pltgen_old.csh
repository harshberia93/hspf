#!/bin/csh

#   GET SCENARIO AND BASIN

  set scenario = $argv[1]
  set basin = $argv[2]
  set lu = $argv[3]

  if (${#argv} == 4) then
    set tree = $argv[4]
  else
    source ../../fragments/set_tree
    mkdir -p ../../../tmp/scratch/temp$$
    cd ../../../tmp/scratch/temp$$
  endif

  source $tree/config/seglists/${basin}.land

  foreach seg ($segments)

      if (-e problem) then
        rm problem
      endif

    echo summarizing pltgens for $lu for segment $seg land scenario $scenario

      echo $seg,$lu,$scenario | $tree/code/bin/pltgen.exe

      if (-e problem) then
        echo ' '
        cat problem
        exit
      endif

  end


# summary land sediment results

# grep 'nh4'           $tree/output/pltgen/land/${scenario}/${lu}*sums                > $tree/output/pltgen/summary/${scenario}/${lu}_NH4_sum.csv
# grep 'no3'           $tree/output/pltgen/land/${scenario}/${lu}*sums                > $tree/output/pltgen/summary/${scenario}/${lu}_NO3_sum.csv
# grep 'orgn'           $tree/output/pltgen/land/${scenario}/${lu}*sums                > $tree/output/pltgen/summary/${scenario}/${lu}_ORGN_sum.csv
# grep 'totn'           $tree/output/pltgen/land/${scenario}/${lu}*sums                > $tree/output/pltgen/summary/${scenario}/${lu}_TOTN_sum.csv
# grep 'potp'           $tree/output/pltgen/land/${scenario}/${lu}*sums                > $tree/output/pltgen/summary/${scenario}/${lu}_POTP_sum.csv
# grep 'totp'           $tree/output/pltgen/land/${scenario}/${lu}*sums                > $tree/output/pltgen/summary/${scenario}/${lu}_TOTP_sum.csv

 grep 'SNH4'           $tree/output/pltgen/land/${scenario}/${lu}*sums                > $tree/output/pltgen/summary/${scenario}/${lu}_SNH4_sum.csv
 grep 'INH4'           $tree/output/pltgen/land/${scenario}/${lu}*sums                > $tree/output/pltgen/summary/${scenario}/${lu}_INH4_sum.csv
 grep 'DNH4'           $tree/output/pltgen/land/${scenario}/${lu}*sums                > $tree/output/pltgen/summary/${scenario}/${lu}_DNH4_sum.csv
 grep 'BNH4'           $tree/output/pltgen/land/${scenario}/${lu}*sums                > $tree/output/pltgen/summary/${scenario}/${lu}_BNH4_sum.csv
 grep 'SNO3'           $tree/output/pltgen/land/${scenario}/${lu}*sums                > $tree/output/pltgen/summary/${scenario}/${lu}_SNO3_sum.csv
 grep 'INO3'           $tree/output/pltgen/land/${scenario}/${lu}*sums                > $tree/output/pltgen/summary/${scenario}/${lu}_INO3_sum.csv
 grep 'BNO3'           $tree/output/pltgen/land/${scenario}/${lu}*sums                > $tree/output/pltgen/summary/${scenario}/${lu}_BNO3_sum.csv
 grep 'SLON'           $tree/output/pltgen/land/${scenario}/${lu}*sums                > $tree/output/pltgen/summary/${scenario}/${lu}_SLON_sum.csv
 grep 'ILON'           $tree/output/pltgen/land/${scenario}/${lu}*sums                > $tree/output/pltgen/summary/${scenario}/${lu}_ILON_sum.csv
 grep 'DLON'           $tree/output/pltgen/land/${scenario}/${lu}*sums                > $tree/output/pltgen/summary/${scenario}/${lu}_DLON_sum.csv
 grep 'BLON'           $tree/output/pltgen/land/${scenario}/${lu}*sums                > $tree/output/pltgen/summary/${scenario}/${lu}_BLON_sum.csv
 grep 'SRON'           $tree/output/pltgen/land/${scenario}/${lu}*sums                > $tree/output/pltgen/summary/${scenario}/${lu}_SRON_sum.csv
 grep 'IRON'           $tree/output/pltgen/land/${scenario}/${lu}*sums                > $tree/output/pltgen/summary/${scenario}/${lu}_IRON_sum.csv
 grep 'BRON'           $tree/output/pltgen/land/${scenario}/${lu}*sums                > $tree/output/pltgen/summary/${scenario}/${lu}_BRON_sum.csv
 grep 'DRON'           $tree/output/pltgen/land/${scenario}/${lu}*sums                > $tree/output/pltgen/summary/${scenario}/${lu}_DRON_sum.csv
# grep 'TOTN'           $tree/output/pltgen/land/${scenario}/${lu}*sums                > $tree/output/pltgen/summary/${scenario}/${lu}_TOTN_sum.csv

 grep 'SPO4'           $tree/output/pltgen/land/${scenario}/${lu}*sums                > $tree/output/pltgen/summary/${scenario}/${lu}_SPO4_sum.csv
 grep 'IPO4'           $tree/output/pltgen/land/${scenario}/${lu}*sums                > $tree/output/pltgen/summary/${scenario}/${lu}_IPO4_sum.csv
 grep 'DPO4'           $tree/output/pltgen/land/${scenario}/${lu}*sums                > $tree/output/pltgen/summary/${scenario}/${lu}_DPO4_sum.csv
 grep 'BPO4'           $tree/output/pltgen/land/${scenario}/${lu}*sums                > $tree/output/pltgen/summary/${scenario}/${lu}_BPO4_sum.csv
# grep 'SROP'           $tree/output/pltgen/land/${scenario}/${lu}*sums                > $tree/output/pltgen/summary/${scenario}/${lu}_SROP_sum.csv
# grep 'TOTP'           $tree/output/pltgen/land/${scenario}/${lu}*sums                > $tree/output/pltgen/summary/${scenario}/${lu}_TOTP_sum.csv

  if (-e problem) then
   cat problem
   rm problem
  endif

 

