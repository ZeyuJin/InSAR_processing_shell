#!/usr/bin/csh -f
#	$Id$
# written by Zeyu Jin in Feb. 2019 

if ($#argv < 2) then
   echo ""
   echo "Usage: dem2topo_ra_swath.csh subswath config.txt "
   echo ""
   exit 1
endif

set subswath = $1
set conf = $2
set topo_phase = `grep topo_phase $conf | awk '{print $3}'`
set shift_topo = `grep shift_topo $conf | awk '{print $3}'`
set master_date = `grep master_date $conf | awk '{print $3}' | awk '{print substr($0,3)}'`

cd F$subswath
mkdir -p topo
cleanup.csh topo

# make topo_ra if there is dem.grd
if ($topo_phase == 1) then
   echo ""
   echo "DEM2TOPO_RA.CSH - START"
   echo "USER SHOULD PROVIDE DEM FILE"
   cd topo
   cp ../SLC/"IMG"*$master_date*"-F$subswath.PRM" master.PRM
   ln -sf ../../raw/"IMG"*$master_date*"-F$subswath.LED" .
   ln -sf ../../topo/dem.grd .
   if (-f dem.grd) then
      dem2topo_ra.csh master.PRM dem.grd >& topo_ra.log
   else
      echo "no DEM file found: " dem.grd
      exit 1
   endif
   cd .. 
   echo "DEM2TOPO_RA.CSH - END"
#
# shift topo_ra
#
   if ($shift_topo == 1) then
      echo ""
      echo "OFFSET_TOPO - START"
      cd SLC
      set master = `ls "IMG"*$master_date*"-F$subswath.PRM" | awk '{print substr($0,1,length($0)-4)}'`
      set rng_samp_rate = `grep rng_samp_rate $master.PRM | awk 'NR == 1 {printf("%d",$3)}'`
      set rng = `gmt grdinfo ../topo/topo_ra.grd | grep x_inc | awk '{print $7}'`
      slc2amp.csh $master.PRM $rng amp-$master.grd
      cd ../topo
      ln -s ../SLC/amp-$master.grd .
      offset_topo amp-$master.grd topo_ra.grd 0 0 7 topo_shift.grd
      cd ..
      echo "OFFSET_TOPO - END"
   else if ($shift_topo == 0) then
      echo "NO TOPO_RA SHIFT "
   else
      echo "Wrong paramter: shift_topo "$shift_topo
      exit 1
   endif

else if ($topo_phase == 0) then
   echo "NO TOPO_RA IS SUBSTRACTED"
else
   echo "Wrong paramter: topo_phase "$topo_phase
   exit 1
endif

cd ..

