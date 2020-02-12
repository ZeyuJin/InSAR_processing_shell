#!/usr/bin/csh -f

if ($#argv < 2) then
   echo ""
   echo "remove_iono.csh dates.pair config_file [ncores]"
   echo ""
   exit 1
endif

if ($#argv == 3) then
   set ncores = $3
else
   set ncores = 4
endif

set intf_file = $1
set config = $2
set iono_filt_rng = `grep iono_filt_rng $config | awk '{print $3}'`
set iono_filt_azi = `grep iono_filt_azi $config | awk '{print $3}'`
set iono_skip_est = `grep iono_skip_est $config | awk '{print $3}'`

mkdir -p iono_correction
cd iono_correction
cp ../$1 .

rm -f estimate_iono.cmd

foreach pair (`cat $intf_file`)
   mkdir -p $pair
   rm -rf $pair/*
   cp ../$pair/boundary.txt $pair/
   cp /nobackupp2/zjin2/Pamir_ALOS2/F1/SLC/params* ../intf_h/$pair/

   if ($iono_skip_est == 0) then
     echo "estimate_ionospheric_phase_new.csh ../../intf_h/$pair ../../intf_l/$pair ../../intf_o/$pair ../../$pair $iono_filt_rng $iono_filt_azi >& iono_$pair.log" >> estimate_iono.cmd
   
     # cd ../../../intf/$pair
     # mv phasefilt.grd phasefilt_non_corrected.grd
     # gmt grdsample ../../iono_phase/iono_correction/$pair/ph_iono_orig.grd -Rphasefilt_non_corrected.grd -Gph_iono.grd
     # gmt grdmath phasefilt_non_corrected.grd ph_iono.grd SUB PI ADD 2 PI MUL MOD PI SUB = phasefilt.grd
     # # gmt makecpt -Crainbow -T-3.15/3.15/0.1 -Z -N > phase.cpt
     # gmt grdimage phasefilt.grd -JX6.5i -Bxaf+lRange -Byaf+lAzimuth -BWSen -Cphase.cpt -X1.3i -Y3i -P -K > phasefilt.ps
     # gmt psscale -Rphasefilt.grd -J -DJTC+w5i/0.2i+h -Cphase.cpt -Bxa1.57+l"Phase" -By+lrad -O >> phasefilt.ps
     # gmt psconvert -Tf -P -Z phasefilt.ps
     # #rm phasefilt.ps
   endif
   # cd ../../iono_phase/iono_correction
   # cd ..
end

parallel --jobs $ncores < estimate_iono.cmd

echo "Remove Ionospheric Noise Finished!"
cd ..
