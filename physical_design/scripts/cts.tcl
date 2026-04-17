# Cell to used in clock path
set_ccopt_property buffer_cells {CLKBUFX2LVT CLKBUFX4LVT CLKBUFX8LVT CLKBUFX12LVT CLKBUFX16LVT}
set_ccopt_property inverter_cells {CLKBUFX2LVT CLKINVX4LVT CLKINVX8LVT CLKINVX12LVT}
set_ccopt_property update_io_latency  false

# target skew and max_trans
set_interactive_constraint_modes func 
set_ccopt_property max_fanout 8 
set_clock_uncertainty -setup 0.1 [all_clocks]
set_clock_uncertainty -hold 0.1 [all_clocks]
set_ccopt_property target_max_trans 0.2
set_ccopt_property target_skew 0.1
set_ccopt_property target_insertion_delay 0.2


# Routing Settings 
setDesignMode -topRoutingLayer 7
setDesignMode -bottomRoutingLayer 1

# Run CTS 
clock_opt_design 

##################### Check Latency skew #################
 report_clock_timing -type latency -verbose
 report_clock_timing -type skew -verbose 


############# Timing Summary ##################################
timeDesign -postCTS
timeDesign  -hold -postCTS

############### Time report #################################
setAnalysisMode -checkType hold
report_timing 

## Post CTS optimization if violation exists
setOptMode -opt_skew_ccopt extreme  
optDesign -postCTS 
optDesign -postCTS  -hold

saveDesign ./design/cts.enc

