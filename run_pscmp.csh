#!/usr/bin/csh -f

unset noclobber
ls -d Green*func > green_dir
rm -f parallel_pscmp.cmd

foreach dir_name (`cat green_dir`)
   # change the input and output directory
   cp SKFS_pscmp_template.dat tmp.dat
   set outdir_name = '.\/'$dir_name'\/fault_integ\/'
   sed -i "s/out_dir/$outdir_name/g" tmp.dat
   set indir_name = '.\/'$dir_name'\/'
   sed -i "s/in_dir/$indir_name/g" tmp.dat
    
   mkdir -p './'$dir_name'/fault_integ'
   set inputfile = './'$dir_name'/fault_integ/SKFS_pscmp.dat'
   cp tmp.dat $inputfile
   echo "fomosto_pscmp2008a "$inputfile" >& ./"$dir_name'/fault_integ/pscmp.log' >> parallel_pscmp.cmd
   rm tmp.dat
end

parallel --jobs 16 < parallel_pscmp.cmd

rm -f green_dir
