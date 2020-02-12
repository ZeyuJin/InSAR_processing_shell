#!/bin/csh -f

rm -f gmt.* *.ps compare_filt.pdf
unset noclobber
gmt gmtset IO_SEGMENT_MARKER '370'
gmt gmtset FONT_ANNOT_PRIMARY 9p
gmt gmtset PS_MEDIA A3

# set tmp = `gmt grdinfo -C -L2 azi_ll.grd`
# set limitU = `echo $tmp | awk '{printf("%.6f", $12+$13*2)}'`
# set limitL = `echo $tmp | awk '{printf("%.6f", $12-$13*2)}'`
# set std = `echo $tmp | awk '{printf("%.6f", $13)}'`
gmt makecpt -Cjet -I -Z -T-1/1/0.5 -D > shift.cpt

gmt grdsample dem.grd -R72.97/73.49/38.18/38.73  `gmt grdinfo -I rng_offset_ll.grd` -r -Gdem_use.grd
set west = `gmt grdinfo dem_use.grd -C | awk '{print $2}'`
set east = `gmt grdinfo dem_use.grd -C | awk '{print $3}'`
set south = `gmt grdinfo dem_use.grd -C | awk '{print $4}'`
set north = `gmt grdinfo dem_use.grd -C | awk '{print $5}'`

gmt grdgradient dem_use.grd -Gtmp.grd -A325 -Nt.5
gmt grdmath tmp.grd .5 ADD = dem_grd.grd
# set r_topo = `gmt grdinfo dem_use.grd -T100`
gmt makecpt -Cgray -T-1/1/.1 -Z > topo.cpt
rm -f tmp.grd

gmt psbasemap -JM5i -R$west/$east/$south/$north -Ba0.25:"Longitude":/a0.25:"Latitude":WSen:."azimuth shift without filter": -X0.5i -Y9.2i -P -K > compare_filt.ps
gmt grdimage -O dem_grd.grd -JM -R -Ctopo.cpt -Q -K >> compare_filt.ps
gmt grdimage -O azi_offset_ll.grd -Cshift.cpt -JM -R -Q -K >> compare_filt.ps
gmt psscale -O -D5.8/-1.2/8/0.2h -Cshift.cpt -Bxaf -By+lm -K -E >> compare_filt.ps
gmt psxy -O epicenter -JM -R -Sa0.25i -Gdarkblue -K >> compare_filt.ps
# rm shift.cpt

# set tmp = `gmt grdinfo -C -L2 azi_ll_filt.grd`
# set limitU = `echo $tmp | awk '{printf("%.6f", $12+$13*2)}'`
# set limitL = `echo $tmp | awk '{printf("%.6f", $12-$13*2)}'`
# set std = `echo $tmp | awk '{printf("%.6f", $13)}'`
# gmt makecpt -Cseis -I -Z -T"$limitL"/"$limitU"/1 -D > shift.cpt

gmt psbasemap -O -JM5i -R$west/$east/$south/$north -Ba0.25:"Longitude":/a0.25:"":WSen:."azimuth shift with filter": -X5.8i -Y0i -P -K >> compare_filt.ps
gmt grdimage -O dem_grd.grd -JM -R -Ctopo.cpt -Q -K >> compare_filt.ps
gmt grdimage -O azi_off_filt_ll.grd -Cshift.cpt -JM -R -Q -K >> compare_filt.ps
gmt psscale -O -D5.8/-1.2/8/0.2h -Cshift.cpt -Bxaf -By+lm -K -E >> compare_filt.ps
gmt psxy -O epicenter -JM -R -Sa0.25i -Gdarkblue -K >> compare_filt.ps

gmt psbasemap -O -JM5i -R$west/$east/$south/$north -Ba0.25:"Longitude":/a0.25:"Latitude":WSen:."range shift without filter": -X-5.8i -Y-8.0i -P -K >> compare_filt.ps
gmt grdimage -O dem_grd.grd -JM -R -Ctopo.cpt -Q -K >> compare_filt.ps
gmt grdimage -O rng_offset_ll.grd -Cshift.cpt -JM -R -Q -K >> compare_filt.ps
gmt psscale -O -D5.8/-1.2/8/0.2h -Cshift.cpt -Bxaf -By+lm -K -E >> compare_filt.ps
gmt psxy -O epicenter -JM -R -Sa0.25i -Gdarkblue -K >> compare_filt.ps 

gmt psbasemap -O -JM5i -R$west/$east/$south/$north -Ba0.25:"Longitude":/a0.25:"":WSen:."range shift with filter": -X5.8i -Y0i -P -K >> compare_filt.ps
gmt grdimage -O dem_grd.grd -JM -R -Ctopo.cpt -Q -K >> compare_filt.ps
gmt grdimage -O rng_off_filt_ll.grd -Cshift.cpt -JM -R -Q -K >> compare_filt.ps
gmt psscale -O -D5.8/-1.2/8/0.2h -Cshift.cpt -Bxaf -By+lm -K -E >> compare_filt.ps
gmt psxy -O epicenter -JM -R -Sa0.25i -Gdarkblue >> compare_filt.ps

rm -f shift.cpt dem_grd.grd dem_use.grd
gmt psconvert -Tf -P -Z compare_filt.ps
