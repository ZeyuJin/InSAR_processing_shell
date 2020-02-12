#!/usr/bin/tcsh -f

if ($#argv < 2) then
   echo ""
   echo "Usage: unwrap_iono_residual.csh  good_dates  unwrap_threshold  [ncores]"
   echo ""
   exit 1
endif

set threshold = $2 
if ($#argv == 3) then
   set ncores = $3
else
   set ncores = 8
endif

foreach good_pair (`awk '{print $0}' $1`)
   cd $good_pair

   if (-f phasefilt_non_corrected.grd) then
      mv phasefilt_non_corrected.grd phasefilt.grd
   endif

   mv phasefilt.grd phasefilt_non_corrected.grd
   cp ../iono_correction/$good_pair/ph_corrected.grd phasefilt.grd
#   snaphu_interp.csh  $threshold  0
   cd ..
end

# unwrap parallelly for each interferogram
unwrap_parallel_new.csh  $1  $threshold  $ncores
