#!/bin/csh -f

if ($#argv != 3) then
  echo ""
  echo "Usage: Green_each_dataset.csh  slip_model_mat  data.list  Ncores"
  echo ""
  exit 1
endif

rm -f layer_green.cmd
set MATLAB = /nasa/matlab/2017b
set slip_model_mat = $1
set data_mat = "los_samp_detrend_mask.mat"
set data_list = $2
set ncores = $3

foreach dataset (`cat $data_list`)
   echo "run_create_edcmp_input.sh $MATLAB $slip_model_mat $data_mat $dataset >& log.$dataset" >> layer_green.cmd 
end

parallel --jobs $ncores < layer_green.cmd

echo ""
echo "Finished all EDCMP jobs..."
echo ""
