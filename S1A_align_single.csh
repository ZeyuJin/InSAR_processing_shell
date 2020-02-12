#!/usr/bin/csh -f
#
# align the single slave to master
# then compute the topo_ra.grd
#
if ($#argv != 2) then
   echo ""
   echo "Usage: S1A_align_single.csh  F1/F2/F3  master_date"
   echo ""
   exit 1
endif

set swath_dir = $1
cd $swath_dir/raw
preproc_batch_tops.csh  data.in.new  dem.grd  2

cd ../topo
set master_date = $2
cp ../raw/"S1_"$master_date"_ALL_"$swath_dir".PRM" master.PRM
cp ../raw/"S1_"$master_date"_ALL_"$swath_dir".LED" .
dem2topo_ra.csh  master.PRM  dem.grd

cd ../..
