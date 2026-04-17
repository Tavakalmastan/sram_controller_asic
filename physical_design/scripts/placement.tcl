
# Pre placement settings
setPlaceMode -place_global_max_density 0.6 
setPlaceMode -place_global_uniform_density true

# Set max routing layers 
setDesignMode -topRoutingLayer 7
setDesignMode -bottomRoutingLayer 1

# Read scan_def 
defIn ./inputs/memory_scanDEF.scandef

# Placement + inplacement_opt + post Placement optimization
place_opt_design 

######################################### Timing Check ########################
timeDesign -preCTS -outDir ./reports/placement -prefix prects

# Upsizing or downsizing or Vt swapping 
ecoChangeCell -inst Top_I18 -cell BUFX20
ecoChangeCell -inst  ch3/sub_chip3_Multiplier/FE_OFC15680_n_408 -cell BUFX8

saveDesign ./design/placement_new.enc

