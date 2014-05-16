#!/bin/csh

  set lu = (iml imh afo)
  foreach landuse ($lu)
    run_IQUAL_optimization.csh p5186 p5186 all $landuse
  end
  
