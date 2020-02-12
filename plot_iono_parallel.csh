#!/bin/csh -f
# 
# By Xiaohua XU, 03/12/2018
#
# Unwrap interferograms parallelly using GNU parallel
#
# IMPORTANT: put a script called unwrap_intf.csh in the current folder
# e.g. 
#   cd $1
#   snaphu[_interp].csh 0.1 0 
#   cd ..
#

if ($#argv != 2) then
  echo ""
  echo "Usage: plot_iono_parallel.csh intflist Ncores"
  echo ""
  echo "    Run jobs parallelly. Need to install GNU parallel first."
  echo "    Note, run this in the intf_all folder where all the interferograms are stored. "
  echo ""
  exit
endif

set ncores = $2

rm -f plot.cmd

foreach line (`awk '{print $0}' $1`)
   echo "plot_iono.csh $line" >> plot.cmd
end

parallel --jobs $ncores < plot.cmd

