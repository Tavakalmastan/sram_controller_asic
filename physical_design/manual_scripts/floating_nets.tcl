puts "Floating Nets (No Driver):"

set count 0

foreach net [dbGet top.nets] {

    # Get driver pins (output direction)
    set drivers [dbGet $net.allTerms { .direction == output }]

    # If no driver ? floating net
    if {$drivers == "0x0"} {
        incr count
        puts "Floating Net: [dbGet $net.name]"
    }
}

puts "Total Floating Nets: $count"
