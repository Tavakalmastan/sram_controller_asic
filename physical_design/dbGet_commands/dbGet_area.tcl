set threshold 5
set count 0

foreach inst [dbGet top.insts] {
    set area [dbGet $inst.area]

    if {$area > $threshold} {
        puts "[dbGet $inst.name] -> $area"
        incr count
    }
}

puts "Total cells with area > $threshold : $count"
