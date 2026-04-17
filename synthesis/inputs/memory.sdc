set_units -time ns -capacitance fF
create_clock -name "mclk" -period 1.5 [get_ports clk_i]

create_clock -period 1.5 -name vclk 

#Define input_transition driving/ driving cell 
 set_driving_cell -lib_cell BUFX12 [all_inputs]

#Define Load
set_load 8 [all_outputs] 

set po [remove_from_collection [all_inputs] [get_ports clk_i]]

# set input delay
 set_input_delay 0.7 $po -clock vclk 

#set output delay 
 set_output_delay 0.7 [all_outputs] -clock vclk

# Define clock uncertainity
set_clock_uncertainty 0.3 [get_clock *]
