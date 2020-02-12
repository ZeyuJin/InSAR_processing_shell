#!/usr/bin/csh -f
#
# Align the single slave to master in three subswaths
# Then use master.PRM to compute the topo_ra.grd and trans.dat
# The first line of date file should be the supermaster
# Written by Zeyu Jin in May. 2019 

if ($#argv != 1) then
   echo ""
   echo "Please specify the date file of data acquisition!"
   echo "The first line of date file is the supermaster ..."
   echo ""
   exit 1
endif

set datefile = $1
set master_date = `awk 'NR==1 {print $0}' $datefile`

cd F1/raw
rm -f data.in*
make_data_in.csh $datefile $master_date
rm -f data.in
# preproc_batch_tops.csh data.in.new dem.grd 2  >&  align_F1 

cd ../../F2/raw
rm -f data.in*
make_data_in.csh $datefile $master_date
rm -f data.in
# preproc_batch_tops.csh data.in.new dem.grd 2  >&  align_F2

cd ../../F3/raw
rm -f data.in*
make_data_in.csh $datefile $master_date
rm -f data.in
# preproc_batch_tops.csh data.in.new dem.grd 2  >&  align_F3

cd ../..
rm -f align.cmd

foreach swath (1 2 3)
   echo "S1A_align_single.csh F$swath $master_date >& align_F$swath" >> align.cmd
end
parallel --jobs 3 < align.cmd

mv align_F1 F1/
mv align_F2 F2/
mv align_F3 F3/

echo ""
echo "Finish all alignment & topo_ra jobs..."
echo ""
