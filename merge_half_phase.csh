#!/usr/bin/csh -f
#	$Id$
#
# post merging half of interferograms
# find multiple 2pi phase shift at the boundary
# then merge two pieces with DENAN
#
# written by Zeyu Jin on July 2nd, 2019
#

if ($#argv < 3) then
   echo ""
   echo "merge_half_phase.csh  boundary.points  unwrap_left.grd  unwrap_right.grd"
   echo "the format of boundary.points is that: (2 points you select in lon/lat)"
   echo "                           lonA  latA"
   echo "                           lonB  latB"
   echo ""
   exit 1
endif

if (! -f trans.dat || ! -f dem.grd) then
   echo "Lack of trans.dat or dem.grd"
   exit 1
endif

set point_file_ll = $1
set left_grd = $2
set right_grd = $3

# transfer the points from lon/lat to r/a
echo "370.0000 0" >> $point_file_ll
proj_fault_ll2ra.csh  trans.dat  $point_file_ll  points.ra
awk 'NR<3 {print $0}' points.ra > tmp.ra
mv tmp.ra points.ra
awk 'NR<3 {print $0}' $point_file_ll > tmp.ll  # restore the original points file
mv tmp.ll $point_file_ll

set phase_left = `gmt grdtrack points.ra -nl -T -Z -G$left_grd`
set phase_right = `gmt grdtrack points.ra -nl -T -Z -G$right_grd`
set phA_diff = `echo $phase_left[1] $phase_right[1] | awk '{print $1-$2}'`
set phB_diff = `echo $phase_left[2] $phase_right[2] | awk '{print $1-$2}'`
echo $phA_diff $phB_diff
set A_cycle = `echo $phA_diff 6.28318530718 | awk '{printf "%.0f\n",$1/$2}'`
set B_cycle = `echo $phB_diff 6.28318530718 | awk '{printf "%.0f\n",$1/$2}'`

if ($A_cycle == $B_cycle) then
   gmt grdmath $left_grd 2 PI MUL $A_cycle MUL SUB = tmp_left.grd
   echo "There are $A_cycle * 2PI phase jump at the boundary!"
else
   echo "The unwrapped phase boundary is not consistent with each other!"
   exit 1
endif

mv tmp_left.grd unwrap_left.grd
# merge two grids with DENAN function
gmt grdmath unwrap_left.grd $right_grd DENAN = merge_unwrap.grd

rm -f  tmp.ra  points.ra
