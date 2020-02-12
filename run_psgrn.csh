#!/usr/bin/csh -f

alias rm 'rm -f'
unset noclobber
rm parallel_psgrn.cmd

ls -d Green*func > green_dir
foreach dir_name (`cat green_dir`)
   #echo "processing "$dir_name
   set thick = `echo $dir_name | awk -F'_' '{print $2}'`
   set eta_index = `echo $dir_name | awk -F'_' '{print $3}'`
   #echo $thick "  " $eta_index
   set inputfile = "SKFS_"$thick"_"$eta_index".dat"
   set inputpath = "./"$dir_name"/"$inputfile
   #echo $inputpath
   
   echo "fomosto_psgrn2008a "$inputpath" >& ./"$dir_name"/psgrn_log" >> parallel_psgrn.cmd
end

parallel --jobs 16 < parallel_psgrn.cmd

rm green_dir
