#reading the libraries
#set search path
set_db init_lib_search_path ../libs/timing_lib/slow/

#target and link libraries
set_db target_library {slow_vdd1v0_basicCells_hvt.lib slow_vdd1v0_basicCells.lib slow_vdd1v0_basicCells_lvt.lib}
set_db link_library {slow_vdd1v0_basicCells_hvt.lib slow_vdd1v0_basicCells.lib slow_vdd1v0_basicCells_lvt.lib}


#read hdl
read_hdl ./inputs/memory_rtl.v

#elaboration
elaborate memory

#Source sdc
source ./inputs/memory.sdc


#Generic sythesis
syn_generic

#mapping
syn_map

#final optimization
syn_opt

#Report Generation

report_gates > ./memory_gates.rpt
report_qor > ./memory_qor.rpt
report_power > ./memory_power.rpt
report_area > ./memory_area.rpt
report_timing > ./memory_time.rpt

#Write netlist
write_hdl > ./outputs/memory_netlist.v

#Write sdc
write_sdc > ./inputs/memory_memory.sdc

gui_show

puts "Synthesis completed"



