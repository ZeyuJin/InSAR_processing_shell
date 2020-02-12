#!/usr/bin/csh -f
#	$Id$
#
# Zeyu Jin, April, 30th, 2019
# 
# Cut the SLC in radar coordinates, and change the input file in PRM
#
if ($#argv != 4 && $#argv != 5) then
   echo ""
   echo "cut_slc_frame.csh  master.PRM  slave.PRM  cut_master_stem  cut_slave_stem  [range]"
   echo "cut_slc  master.PRM  cut_master_stem  [range]"
   echo "cut_slc  slave.PRM  cut_slave_stem  [range]"
   echo ""
   echo "(old .LED file can still be used)"
   echo ""
   exit 1
endif

set master_prm = $1
set slave_prm = $2
set cut_master_stem = $3
set cut_slave_stem = $4

rm -f $cut_master_stem".PRM" $cut_master_stem".SLC"
rm -f $cut_slave_stem".PRM" $cut_slave_stem".SLC"

if ($#argv == 4) then  # does not change the size of SLC
   mv  $master_prm  $cut_master_stem".PRM"
   mv  $slave_prm  $cut_slave_stem".PRM"
endif

if ($#argv == 5) then
   set range = $5
   cut_slc  $master_prm  $cut_master_stem  $range
   cut_slc  $slave_prm  $cut_slave_stem  $range
 
   # replace the input_file and SLC_file in PRMs
   # in order to compute the right transformation matrix
   sed "s/.*input_file.*/input_file	= $cut_master_stem.SLC/g" $cut_master_stem".PRM" > tmp
   mv tmp $cut_master_stem".PRM"
   sed "s/.*input_file.*/input_file     = $cut_slave_stem.SLC/g" $cut_slave_stem".PRM" > tmp
   mv tmp $cut_slave_stem".PRM"

   sed "s/.*SLC_file.*/SLC_file     = $cut_master_stem.SLC/g" $cut_master_stem".PRM" > tmp2
   mv tmp2 $cut_master_stem".PRM"
   sed "s/.*SLC_file.*/SLC_file     = $cut_slave_stem.SLC/g" $cut_slave_stem".PRM" > tmp2
   mv tmp2 $cut_slave_stem".PRM"
endif
