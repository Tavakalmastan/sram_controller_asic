# delete existing PG strucure 
deleteAllPowerPreroutes

# Update logically power and ground 
clearGlobalNets
globalNetConnect VSS -type pgpin -pin VSS -instanceBasename * -hierarchicalInstance {} 
globalNetConnect VDD -type pgpin -pin VDD -instanceBasename * -hierarchicalInstance {} 

# Create core Rings 
addRing -nets {VDD VSS} -type core_rings -follow core -layer {top Metal9 bottom Metal9 right Metal8 left Metal8} -width {top 1 bottom 1 left 1 right 1} -spacing {top 1 bottom 1 left 1 right 1} -offset {top 1 bottom 1 left 1 right 1}

# Create Stripes 
 addStripe -nets {VDD VSS} -direction horizontal -layer Metal9 -width 1 -spacing 1 -set_to_set_distance 20 -start_from bottom -start_offset 5 -block_ring_top_layer_limit Metal9 -block_ring_bottom_layer_limit Metal1

addStripe -nets {VDD VSS} -direction vertical  -layer Metal8 -width 1 -spacing 1 -set_to_set_distance 20 -start_from left -start_offset 6 -block_ring_top_layer_limit Metal9 -block_ring_bottom_layer_limit Metal1 

# Create rails 
setSrouteMode -viaConnectToShape {stripe} 

sroute -connect {blockPin corePin floatingStripe} -layerChangeRange {Metal1(1) Metal9(9)} -blockPinTarget nearestTarget -corePinTarget none  -floatingStripeTarget {blockring ring stripe padring ringpin blockpin followpin} -allowJogging 1 -crossoverViaLayerRange {Metal1(1) Metal9(9)} -nets {VDD VSS} -allowlayerChange 1 -blockPin useLef -targetViaLayerRange {Metal1(1) Metal9(9)} 

