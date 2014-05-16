#!/bin/csh

 if (${#argv} != 4) then
   echo '' 
   echo 'usage:  sum_otherDF_all_basins.csh scenario DFscen year1 year2 '
   echo ' '
   exit
 endif

 set scen = $argv[1]
 set DFscen = $argv[2]
 set year1 = $argv[3]
 set year2 = $argv[4]
# set basins = (ET3p1 ET5p2 LE1p1 LE2p2 RET2p2 RET5p2 TF1p5 TF1p7 TF2p3 TF5p5)
# set basins = (S P Y D E R J W G X N T O M B K allBay all)
# set basins = (S P Y D E R J W G X watershed RIMP)
# set basins = (S P Y E R J W X watershed RIMP)
# set basins = (uMDB mMDB lMDB EshVA)
 set basins = (watershed RIMP S P Y E R J W X X_AFL X_BFL P_AFL P_BFL R_AFL R_BFL Y_AFL Y_BFL R_AFL R_BFL J_AFL J_BFL UpES MidES LowES VaES VAcapes)


 foreach basin ($basins)
   sbatch -pdebug summarize_otherDF_aveann.csh $scen $DFscen $basin $year1 $year2
 end