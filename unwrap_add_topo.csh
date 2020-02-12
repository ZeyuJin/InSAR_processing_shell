#!/usr/bin/csh -f

cd intf_o
foreach pair (`cat dates.run`)
   cd $pair
   gmt grdmath topo_filt.grd unwrap.grd ADD = tmp.grd
   mv unwrap.grd unwrap_dtopo.grd
   mv tmp.grd unwrap.grd
   cd ..
end

cd ../intf_h
foreach pair (`cat dates.run`)
   cd $pair
   gmt grdmath topo_filt.grd unwrap.grd ADD = tmp.grd
   mv unwrap.grd unwrap_dtopo.grd
   mv tmp.grd unwrap.grd
   cd ..
end


cd ../intf_l
foreach pair (`cat dates.run`)
   cd $pair
   gmt grdmath topo_filt.grd unwrap.grd ADD = tmp.grd
   mv unwrap.grd unwrap_dtopo.grd
   mv tmp.grd unwrap.grd
   cd ..
end
cd ..
