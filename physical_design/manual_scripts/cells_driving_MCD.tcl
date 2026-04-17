set count 0

foreach net [dbGet top.nets] {

    set loads [dbGet $net.allTerms { .direction == input }]
    set clock_list {}

    foreach load $loads {
        set clk [dbGet $load.inst.cell.terms { .isClock == true }]
        if {$clk != "0x0"} {
            lappend clock_list [dbGet $clk.net.name]
        }
    }

    set unique_clks [lsort -unique $clock_list]

    if {[llength $unique_clks] > 1} {
        incr count
        puts "Net: [dbGet $net.name] -> Clocks: $unique_clks"
    }
}

puts "Total multi-clock domain nets: $count"
