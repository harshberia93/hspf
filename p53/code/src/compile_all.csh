#!/bin/csh

####### section added by York Prado 10/2009
if( ! (-e /usr/bin/f77 || -e /bin/f77 || -e /usr/local/bin/f77) ) then 
  echo "f77 command is not found"
  echo "Please make sure you have the fortran 77 compiler installed"
  exit 1
endif 

# section below moved to compile_hspf_libs.csh
#cd hspf/lib3.2/src/util
#make clean 
#make 
#make install 
#cd ../ 
#cd wdm/
#make clean
#make 
#make install
#cd ../
#cd adwdm/
#make clean
##make
#make install
#echo "Compiled all the lib3.2 files needed to compile the CBWM"
#cd ../../../../ 

######### end York Prado section

cd lib/dsn/
f77 -c dsn_utils.f

cd ../util
rm ../util_lib.a
./compile
cd ../get
rm ../get_lib.a
./compile
cd ../tty/
gcc -c -o ../ttyux.o ttyux.c

cd ../../lug
./compile
cd ../rug
./compile

cd ../etm/etm_and_postproc/
./compile
cd ../make_binary_transfer_coeffs/
./compile
cd ../stream_wdm/
./compile
cd ../check_river/
./compile
cd ../combine_ps_sep_div_ams_from_landsegs/
./compile

cd ../../calibration_utils/basingen/
./compile
cd ../riverinfo/
./compile
cd ../split_seglists/
./compile
cd ../EOF_to_EOS_factors/sumout/
rm sumout.a
./compile
cd ../
./compile
cd ../reverse_seglist/
./compile
cd ../read_dot_out_file/
./compile
cd ../make_calib_site_list/
./compile
cd ../make_calib_seglist/
./compile
cd ../make_incremental_calib_list/
./compile
cd ../make_WQ_incremental_calib_list/
./compile
cd ../change_param/land/
./compile
cd ../river/
./compile
cd ../calib_iter/IQUAL
./compile
cd ../NITR_crop
./compile
cd ../NITR_forest
./compile
cd ../NITR_noncrop
./compile
cd ../NITR_pasture
./compile
cd ../NITR_alf
./compile
cd ../NITR_hyw
./compile
cd ../PHOS_crop
./compile
cd ../PHOS_noncrop
./compile
cd ../PQUAL
./compile
cd ../PSTEMP
./compile
cd ../PSTEMP_river
./compile
cd ../PWATER
./compile
cd ../SOLIDS
./compile
cd ../SEDMNT
./compile
cd ../WQ_sensitivity
./compile
cd ../../../get1parameter/
./compile
cd ../get_total_watershed_size_for_part/
./compile
cd ../read_data/tss
./compile
cd ../../get_pltgen_percentiles/
./compile

cd ../../postproc/river/
rm postriverlib.a
./compile
cd part
./compile
cd ../aveann
./compile
cd ../monthly
./compile
cd ../annual
./compile
cd ../daily
./compile
cd ../stats
./compile
cd ../rating
./compile

cd ../../data
./compile

cd ../postutils/sumstats
./compile
cd progress_sumstats
./compile
cd ../../pltgen2cal/
./compile
cd ../sumplt/
./compile
cd ../sumout/
./compile
cd ../sumin/
./compile
cd getAtdep
./compile
cd ../../sumWTMP/
./compile
cd sum_PSTEMP_progress/
./compile

cd ../../../pltgen/land
./compile
cd pltgen_PIQUAL/
./compile
cd ../../river
./compile

cd ../../del/tfs
./compile
cd ../dfs
./compile
cd ../delload
./compile

cd ../../scenario_compare/
./compile

cd ../../wqm_load/wqmlib/
./compile
cd ../atdep_to_wqm57k/
./compile
cd ../check_loads
./compile
cd ../factor_scenario_p5_and_ps_to_wqm57k
./compile
cd ../p5_and_ps_to_wqm57k
./compile

cd ../../data_import/diversions/
./compile
cd ../precip/
./compile
cd ../point_source/
./compile
cd ../septic/
./compile
cd ../add_atdep_to_precip/
./compile
cd ../met/
./compile
cd ../quick_wdm/
./compile


cd ../../
  
