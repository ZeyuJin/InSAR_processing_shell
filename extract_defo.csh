#!/usr/bin/csh -f

ls -d Green*func > green_dir
foreach dir_name (`cat green_dir`)
   set filepath = $dir_name'/fault_integ/'
   cd $filepath
   awk 'FNR>=2 {print $1,$2,$3,$4,$5}' coseis-gps.dat > coseis_defo.dat
   awk 'FNR>=2 {print $1,$2,$3,$4,$5}' snapshot_2.5_year.dat > postseis_defo.dat
   # compiled by MATLAB mcc, compute the difference between coseismic/postseismic
   # generate post_response.txt in local directory
   run_diff_cos_post.sh $MATLAB
  
   # gather all results together and rename with thickness and viscosity 
   set thick = `echo $dir_name | awk -F'_' '{print $2}'`
   set eta_index = `echo $dir_name | awk -F'_' '{print $3}'`
   set outfile = "post_"$thick"_"$eta_index"_response.txt"
   cp post_response.txt "../../post_displacement/"$outfile
   
   cd ../..
end
rm -f green_dir
