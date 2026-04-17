# Set layers
setDesignMode -bottomRoutingLayer 1
setDesignMode -topRoutingLayer 7 

# Enable fixing (layer hopping or Antenna diode) 
setNanoRouteMode -route_detail_fix_antenna true
# setNanoRouteMode -route_antenna_diode_insertion true
#  setNanoRouteMode -route_antenna_cell_name ANTENNA

## Run Routing 
routeDesign -globalDetail

# Check opens or unconnected nets 
verifyConnectivity 
# To fix open nets 
ecoRoute 

# Check DRC 
 verify_drc -limit 0

# Fix DRC and Antenna 
setNanoRouteMode -route_with_eco true
setNanoRouteMode -route_antenna_diode_insertion true
setNanoRouteMode -route_antenna_cell_name ANTENNA
editDelete -regular_wire_with_drc
# setDesignMode -topRoutingLayer 8
ecoRoute

# Report Timing 
setAnalysisMode -analysisType onChipVariation
timeDesign -postRoute
timeDesign -postRoute  -hold

saveDesign ./design/route.enc

# Generating GDS 
streamOut -merge {/home/amog/memory_example/libs/gds/gsclib045.gds /home/amog/memory_example/libs/gds/gsclib045_hvt.gds /home/amog/memory_example/libs/gds/gsclib045_lvt.gds} ./outputs/final.gds 




