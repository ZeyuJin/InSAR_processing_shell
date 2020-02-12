#!/usr/bin/csh -f

if ($#argv < 1) then
   echo ""
   echo "Usage: cut_phase_before_unwrap.csh local_mask_ra ..."
   echo "mask files should be converted to radar coordinates in advance ..."
   echo "cut the frame into half to unwrap"
   echo ""
   exit 1
endif

rm -f gmt.*
set mask_file = $1
# convert the Polygons in kml to ASCII files
# gmt kml2gmt $mask_file -Fp -V | awk 'NR>1 {print $0}' > local_mask.txt

# project the masked polygons from radar to geographical coordinates
# compute from lon/lat/topo to range/azimuth/topo_ra
# if (-f ../dem.grd)   ln -sf ../dem.grd .
# if (-f ../trans.dat) ln -sf ../trans.dat .
# gmt grdtrack local_mask.txt -nl -T -Gdem.grd > llt
# proj_ll2ra_ascii.csh trans.dat llt rat
# awk '{print $1,$2}' rat > local_mask_ra.txt

if (! -f phasefilt.grd || ! -f corr.grd) then
   echo "Lack of phasefilt.grd or corr.grd!"
   exit 1
endif

# cut the phase into half with grdmask
gmt grdmask $mask_file `gmt grdinfo -I- corr.grd` `gmt grdinfo -I corr.grd` -N0/0/1 -Gcorr_mask_left.grd=nb -r -V
gmt grdmask $mask_file `gmt grdinfo -I- corr.grd` `gmt grdinfo -I corr.grd` -N1/0/0 -Gcorr_mask_right.grd=nb -r -V
gmt grdmask $mask_file `gmt grdinfo -I- phasefilt.grd` `gmt grdinfo -I phasefilt.grd` -NNaN/NaN/1 -Gphase_mask_left.grd=nb -r -V
gmt grdmask $mask_file `gmt grdinfo -I- phasefilt.grd` `gmt grdinfo -I phasefilt.grd` -N1/NaN/NaN -Gphase_mask_right.grd=nb -r -V

mv phasefilt.grd phasefilt_non_masked.grd
mv corr.grd corr_non_masked.grd

gmt grdmath phasefilt_non_masked.grd phase_mask_left.grd MUL = phasefilt_left.grd
gmt grdmath phasefilt_non_masked.grd phase_mask_right.grd MUL = phasefilt_right.grd
gmt grdmath corr_non_masked.grd corr_mask_left.grd MUL = corr_left.grd
gmt grdmath corr_non_masked.grd corr_mask_right.grd MUL = corr_right.grd

mkdir -p left right
mv phasefilt_left.grd   left/phasefilt.grd
mv corr_left.grd        left/corr.grd
mv phasefilt_right.grd  right/phasefilt.grd
mv corr_right.grd       right/corr.grd

rm -f  corr_mask_left.grd   corr_mask_right.grd
rm -f  phase_mask_left.grd  phase_mask_right.grd
