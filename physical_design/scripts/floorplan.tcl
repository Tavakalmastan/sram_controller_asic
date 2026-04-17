# Import design 
source ./inputs/Default.globals
init_design 

# Sanity checks (Optional) 
# Check on physical libraries
checkDesign -physicalLibrary  -outfile ./reports/chek_lef.txt  -noHtml

# Check timing libraries 
checkDesign -timingLibrary

# Check netlist
checkDesign -netlist -outfile ./reports/netlist_check.txt -nohtml

# Check Timing 
check_timing -view func_worst

# Create core and Die area 
# floorPlan -r {AR UTI L R T B} -coreMarginsBy io
floorPlan -site CoreSite -r {1 0.55 5 5 5 5} -coreMarginsBy io

# 1 : Aspect ratio
# 0.55 : Utilization 
# 5 5 5 5 : Distance between core and IO boundry 

# Few dbGet commands 
# Objects : top : Points to all objects top of the cell 
	# select : Points to object selected 
	# head : Points to objects of libraries 

# Get Core area bbox 
dbGet top.fPlan.coreBox

# Get io box bbox 
dbGet top.fPlan.ioBox 

# Get area of core area 
dbGet top.fPlan.coreBox_area

# Get total cell count in the design 
llength [dbGet top.insts.name ]

# To get explanation required attribute 
dbGet top.insts.cell.?h *base*class* 

# To get all macro names 
dbGet [dbGet top.insts.cell.baseClass block -p2].name
llength  [dbGet [dbGet top.insts.cell.baseClass block -p2].name]

# To Get all sequential cells in design 
 llength [dbGet [dbGet top.insts.cell.isSequential 1 -p2].name]

# To get all std_cell count except macros
llength  [dbGet [dbGet top.insts.cell.baseClass core -p2].name] 

# Select all macros in design belonging to family ch1 
select_obj [dbGet [dbGet top.insts.cell.baseClass block -p2].name ch1/*]

# To get all power domain names 
dbGet top.FPlan.groups.name

# Get all cells present in particular power domain VDD_ARB4 
dbGet [dbGet top.FPlan.groups.name VDD_ARB4 -p].members.insts.name

# dbGet command using Select. 
dbGet selected.name 

# Get height and Widht of site rows by selecting site 
# First select site row 
 dbGet selected.StepX
 dbGet selected.StepY

# To get all AND gates in the library 
dbGet head.libCells.name *AND* 

# To get buffers cells in library 
 dbGet [dbGet head.libCells.isBuffer 1 -p1].name 

# To get Power switch in library 
dbGet [dbGet head.libCells.isPowerSwitch 1 -p1].name

# Get all routing layer names 
dbGet [dbGet head.layers.type routing -p1].name

# Get pitch of M1 
 dbGet [dbGet head.layers.name Metal1 -p1].pitchX

# To Print all metal layer name pitch min_spacing and min_width in table form 
	# PitchX and PitchY 
	# For odd metal layer find Pitch X and for even metal layers find pitch Y 
	foreach m [dbGet [dbGet head.layers.type routing -p1].name] {
		regexp -nocase {metal([1-9]+)} $m temp n
		if {[expr $n % 2] == 0} {
			set pi [dbGet  [dbGet head.layers.name $m -p1].pitchX]
		} else {
			set pi [dbGet  [dbGet head.layers.name $m -p1].pitchY]
		} 
		set ms [dbGet  [dbGet head.layers.name $m -p1].minSpacing]
		set mw [dbGet  [dbGet head.layers.name $m -p1].minWidth] 
		puts "$m\t$pi\t$ms\t$mw"	
	} 
	
# Write TCl to utilization value uti = {tolal area of cells including macros} / core_area
	set b 0
	foreach a [dbGet top.insts.area] {
		set b [expr $b + $a] 
	}
	  
	set ca [dbGet top.FPlan.coreBox_area ]
	set uti [expr ($b/$ca)*100] 

# Get all cells which has dont touch and dont use attributes in library 
dbGet [dbGet head.libCells.dontTouch 1 -p1].name
dbGet [dbGet head.libCells.dontUse 1 -p1].name

# Get physical status of macros 
dbGet [dbGet top.insts.cell.baseClass block -p2].pStatus

saveDesign ./design/import_design.enc 
restoreDesign ./design/import_design.enc.dat chip_top

# To get Utilization of the design 
checkFPlan -reportUtil

# dbSet:  Set attribute values for certain attributes of an object 
dbSet [dbGet top.insts.cell.baseClass block -p2].pStatus fixed 

# Port Placement All input ports :  {0 900} {0 1400} 
# 		All ouput ports : {2217 900} {2217 1400} 
set a [dbGet [dbGet top.terms.direction input -p1].name]
editPin -fixoverlap 1 -spreadDirection clockwise -side left -layer 5 -spreadType RANGE -start {0 900} -end {0 1400} -pin $a -snap TRACK

set b [dbGet [dbGet top.terms.direction output -p1].name]
editPin -fixOverlap 1 -spreadDirection counterclockwise -side right -layer 5 -spreadType RANGE -start {2217 900} -end {2217 1400} -pin $b -snap TRACK

# Check Port Placement 
checkPinAssignment -report_violating_pin -outFile ./reports/pin_check.txt
legalizePin
saveDesign ./design/port_placement.enc
restoreDesign ./design/port_placement.enc.dat chip_top 


# Macro Placement 
# How to do manual macro placement 
 	# Colour macros based on families 
 	# Analyse fly lines 
 	# shft + R is a short cut to move macro  
# Align and distribute 
# Post macro place placement settings 
	# Fix Macros 
		dbSet [dbGet top.insts.cell.baseClass block -p2].Pstatus fixed

	# Apply Keepout margin/Halo 
		# To deleta Halo 
		deleteHaloFromBlock -allMacro

		# To add Halo 
		addHaloToBlock -allMacro -snapToSite 1 1 1 1

	# Cut Site rows : Done after fixing macro placement 
 
	# Apply Placement blockages in macro channel 
		deletePlaceBlockage -all
		finishFloorplan -fillPlaceBlockage soft 15

# Place Physical Only Cells 
	# delete End Cap cells 
	deleteFiller -prefix END
 
	# Place End Cap Cells 
	setEndCapMode -leftEdge FILL4 -rightEdge FILL4
	addEndCap -prefix ENDCAP

	# Verify EndCap 
	 verifyEndCap -error 200000

	# ADD TAP cells 
	addWellTap -checkerBoard -cell FILL4 -prefix TAP -fixedGap -cellInterval 30 

	# Verify TAP cells 
	 verifyWellTap -cell FILL4 -rule 30

saveDesign ./design/physicalcells_placed.enc

############# Power_plan ###########################
source ./scripts/power_plan.tcl 

# Checks after Power Planning 
verify_PG_short 

# Check DRC
verify_drc

# Verify PG connectivity 
verify_connectivity -allPGPinPort -net {VDD VSS} -error 200000


########################################################### To Fix power planning Issues #########################################################################
deleteAllPowerPreroutes
deleteFiller -prefix END
deleteFiller -prefix TAP
deletePlaceBlockage -all

# Increasing spacing between macros to 25
dbSet [dbGet top.insts.cell.baseClass block -p2].Pstatus fixed
deleteHaloFromBlock -allMacro 
addHaloToBlock -allMacro -snapToSite 1 1 1 1
finishFloorplan -fillPlaceBlockage soft 25
# finishFloorplan -fillPlaceBlockage partial 25
# dbset [dbget -p1 top.fplan.pBlkgs.type partial].density 40

# Add TAP and END CAP cells 
	setEndCapMode -leftEdge FILL4 -rightEdge FILL4
	addEndCap -prefix ENDCAP

	# ADD TAP cells 
	addWellTap -checkerBoard -cell FILL4 -prefix TAP -fixedGap -cellInterval 30 

# Source power and check all issues 
source ./scripts/power_plan.tcl 

# Checks after Power Planning 
verify_PG_short 

# Check DRC
verify_drc

# Verify PG connectivity 
verify_connectivity -allPGPinPort -net {VDD VSS} -error 200000

saveDesign ./design/power_planning_done.enc

finishFloorplan -fillPlaceBlockage soft 30
 dbset [dbget -p1 top.fplan.pBlkgs.type partial].density 20

