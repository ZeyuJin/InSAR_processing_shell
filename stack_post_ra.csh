#!/usr/bin/csh -f

if ($#argv < 1) then
   echo ""
   echo "Usage: stack_post_ra.csh  good_dates"
   echo ""
   exit 1
endif

rm -f *_ra.grd

set flag = 0

foreach date (`cat $1`)
   ln -sf ../$date/unwrap.grd .
   gmt grdmath unwrap.grd unwrap.grd MEAN SUB = $date"_ra.grd"
   rm -f unwrap.grd
   @ flag = $flag + 1
   if ($flag == 1) then
      cp $date"_ra.grd" tmp.grd
   else 
      gmt grdmath tmp.grd $date"_ra.grd" ADD = tmp.grd
   endif
end

echo "The total stacking number is $flag ..."
mv tmp.grd stack_ra.grd
