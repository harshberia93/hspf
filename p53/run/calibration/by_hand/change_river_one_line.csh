#!/bin/csh

 if (-e problem) then
   rm problem
 endif

 set paramscen = Sconow
 set basin = SLres

# echo $basin,$paramscen,HTRCH,"HEAT-PARM",KATRAD,r,e,11 |../../../code/bin/Rchange_params_one_line.exe

# echo $basin,$paramscen,OXRX,"OX-GENPARM",$paramscenPSAT,r,m,1.0 |../../../code/bin/Rchange_params_one_line.exe
# echo $basin,$paramscen,OXRX,"OX-BENPARM",BENOD,r,m,1. |../../../code/bin/Rchange_params_one_line.exe
# echo $basin,$paramscen,OXRX,"OX-CFOREA",CFOREA,r,m,1. |../../../code/bin/Rchange_params_one_line.exe

# echo $basin,$paramscen,sedtrn,"silt-clay-pm#1",sw,r,e,0.02 |../../../code/bin/Rchange_params_one_line.exe
 echo $basin,$paramscen,sedtrn,"silt-clay-pm#2",cw,r,e,0.0008 |../../../code/bin/Rchange_params_one_line.exe
# echo $basin,$paramscen,sedtrn,"silt-clay-pm#1",staucs,r,p,98 |../../../code/bin/Rchange_params_one_line.exe
# echo $basin,$paramscen,sedtrn,"silt-clay-pm#1",staucd,r,p,100 |../../../code/bin/Rchange_params_one_line.exe
# echo $basin,$paramscen,sedtrn,"silt-clay-pm#2",ctaucs,r,p,96 |../../../code/bin/Rchange_params_one_line.exe
# echo $basin,$paramscen,sedtrn,"silt-clay-pm#2",ctaucd,r,p,100 |../../../code/bin/Rchange_params_one_line.exe
# echo $basin,$paramscen,sedtrn,"silt-clay-pm#1",sm,r,e,.01 |../../../code/bin/Rchange_params_one_line.exe
# echo $basin,$paramscen,sedtrn,"silt-clay-pm#2",cm,r,e,.01 |../../../code/bin/Rchange_params_one_line.exe

 echo $basin,$paramscen,PLANK,"PHYTO-PARM",REFSET,r,e,0.08 |../../../code/bin/Rchange_params_one_line.exe
# echo $basin,$paramscen,NUTRX,"NUT-NITDENIT",KNO320,r,m,1. |../../../code/bin/Rchange_params_one_line.exe
# echo $basin,$paramscen,NUTRX,"NUT-NITDENIT",KTAM20,r,m,1. |../../../code/bin/Rchange_params_one_line.exe
# echo $basin,$paramscen,NUTRX,"NUT-BENPARM",BRTAM1,r,e,8. |../../../code/bin/Rchange_params_one_line.exe
# echo $basin,$paramscen,NUTRX,"NUT-BENPARM",BRTAM2,r,e,8. |../../../code/bin/Rchange_params_one_line.exe
# echo $basin,$paramscen,NUTRX,"NUT-BEDCONC",NH4-sand,r,e,20. |../../../code/bin/Rchange_params_one_line.exe
# echo $basin,$paramscen,NUTRX,"NUT-BEDCONC",NH4-silt,r,e,200. |../../../code/bin/Rchange_params_one_line.exe
# echo $basin,$paramscen,NUTRX,"NUT-BEDCONC",NH4-clay,r,e,500. |../../../code/bin/Rchange_params_one_line.exe
# echo $basin,$paramscen,NUTRX,"NUT-BENPARM",BRPO41,r,m,1. |../../../code/bin/Rchange_params_one_line.exe
# echo $basin,$paramscen,NUTRX,"NUT-BEDCONC",PO4-clay,r,m,1. |../../../code/bin/Rchange_params_one_line.exe
# echo $basin,$paramscen,NUTRX,"NUT-ADSPARM",PO4-clay,r,m,1. |../../../code/bin/Rchange_params_one_line.exe
# echo $basin,$paramscen,NUTRX,"NUT-ADSPARM",NH4-sand,r,e,15. |../../../code/bin/Rchange_params_one_line.exe
# echo $basin,$paramscen,NUTRX,"NUT-ADSPARM",NH4-silt,r,e,150. |../../../code/bin/Rchange_params_one_line.exe
# echo $basin,$paramscen,NUTRX,"NUT-ADSPARM",NH4-clay,r,e,1500. |../../../code/bin/Rchange_params_one_line.exe
# echo $basin,$paramscen,PLANK,"PLNK-PARM1",MALGR,r,m,0.5  |../../../code/bin/Rchange_params_one_line.exe

 if (-e problem) then
   cat problem
   rm problem
 endif
