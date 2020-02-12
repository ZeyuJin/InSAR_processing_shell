#!/usr/bin/tcsh -f

if ($#argv != 1) then
   echo ""
   echo "Please specify the orbit datefile!"
   echo ""
   exit 1
endif

set datefile = $1
set url = "https://s1qc.asf.alaska.edu/aux_resorb"
wget $url"/"  # save the index.html file

touch orbit_RES
foreach date (`cat $datefile`)
   cat index.html | grep $date | awk -F'"' '{print $2}' >> orbit_RES
end

mkdir -p download
cd download
cp ../orbit_RES .
foreach file (`cat orbit_RES`)
   wget $url"/"$file   --user=jzy9@mail.ustc.edu.cn --password=949102311Zgr!
end

mv S1A*.EOF ../S1A_RES/
mv S1B*.EOF ../S1B_RES/
rm -f orbit_RES
cd ..
