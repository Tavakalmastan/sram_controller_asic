# TCL Script for getting the Utilization of Core

set a 0

# To get total cell area
foreach b [dbGet top.insts.area] {
    set a [expr ($a + $b)]
}

# To get total core area
set TA [dbGet top.fPlan.CoreBox_area]

# To get utilization
set U [expr ($a / $TA) * 100]

puts "Utilization :$U"
