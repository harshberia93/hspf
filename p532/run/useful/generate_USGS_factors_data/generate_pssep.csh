#!/bin/csh

 cd ../
  set years = ( 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 2000 2001 2002 2003 2004 2005 )

 foreach year ($years)

   run_postproc_pssep_aveann.csh temp804 allFAT $year $year

 end 
