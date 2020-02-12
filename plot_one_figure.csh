#!/bin/csh -f

# if ($#argv != 1) then
#   echo ""
#   echo "plot_one_figure.csh dates.pair"
#   echo ""
# endif

# set pair = $1
# cd $pair

rm -f gmt.* *.ps ASC64_unwrap.pdf
unset noclobber
gmt gmtset IO_SEGMENT_MARKER '370'
gmt gmtset FONT_ANNOT_PRIMARY 14p
gmt gmtset FONT_TITLE 15p
gmt gmtset PS_MEDIA A3

set west = `gmt grdinfo unwrap.grd -C | awk '{print $2}'`
set east = `gmt grdinfo unwrap.grd -C | awk '{print $3}'`
set south = `gmt grdinfo unwrap.grd -C | awk '{print $4}'`
set north = `gmt grdinfo unwrap.grd -C | awk '{print $5}'`

# set tmp = `gmt grdinfo -C -L2 ASC64_unwrap.grd`
# set limitU = `echo $tmp | awk '{printf("%5.1f", $12+$13*2)}'`
# set limitL = `echo $tmp | awk '{printf("%5.1f", $12-$13*2)}'`
# set std = `echo $tmp | awk '{printf("%5.1f", $13)}'`
# gmt makecpt -Cseis -I -Z -T"$limitL"/"$limitU"/5 -D > unwrap.cpt

set SIZE = 8i
# set XSHIFT = -6.7i

gmt psbasemap -JX$SIZE -R$west/$east/$south/$north -Ba8000:"Range":/a2000:"Azimuth":WSen:."Unwrapped Phase": -X2i -Y4i -P -K > ASC64_unwrap.ps
# gmt makecpt -Crainbow -T-3.15/3.15/0.1 -Z -N > unwrap.cpt
gmt grdimage -O -JX -R unwrap.grd -Cunwrap.cpt -P -Q -K >> ASC64_unwrap.ps
gmt psxy -O fault_ll -JX -R -W1.2p -K >> ASC64_unwrap.ps
# gmt psxy -O fault_ra.txt -JX -R -W1.2p,green -K >> ASC64_unwrap.ps
gmt psscale -O -D5/-2/8/0.2h -Cunwrap.cpt -Bxaf+l"Phase" -By+lrad >> ASC64_unwrap.ps

# gmt psbasemap -O -JX$SIZE -R$west/$east/$south/$north -Ba4000:"Range":/a50000:"":wSen:."Iono Phase": -X$SIZE -Y0i -P -K >> ASC64_unwrap.ps
# gmt grdimage -O -JX -R ph_iono.grd -Cunwrap.cpt -P -Q -K >> ASC64_unwrap.ps
# gmt psscale -O -D4/-1.8/6/0.2h -Cunwrap.cpt -Bxa1.57+l"Phase" -By+lrad -K >> ASC64_unwrap.ps
# 
# gmt psbasemap -O -JX$SIZE -R$west/$east/$south/$north -Ba4000:"Range":/a50000:"":wSEn:."Corrected": -X$SIZE -Y0i -P -K >> ASC64_unwrap.ps
# gmt grdimage -O -JX -R ph_corrected.grd -Cunwrap.cpt -P -Q -K >> ASC64_unwrap.ps
# gmt psscale -O -D4/-1.8/6/0.2h -Cunwrap.cpt -Bxa1.57+l"Phase" -By+lrad >> ASC64_unwrap.ps

gmt psconvert -Tf -P -Z ASC64_unwrap.ps

# cd ..
