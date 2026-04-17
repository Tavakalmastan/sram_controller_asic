if 0 {
puts "-------------------------------------------------------------"
puts "Instance_Name\tX\tY\tCell_Type"
puts "-------------------------------------------------------------"

set count 0

foreach inst [dbGet top.insts] {
    set name [dbGet $inst.name]
    set x    [dbGet $inst.pt_x]
    set y    [dbGet $inst.pt_y]
    set cell [dbGet $inst.cell.name]

    puts "$name\t$x\t$y\t$cell"
    incr count
}

puts "-------------------------------------------------------------"
puts "Total Instances: $count"

}

set count 0

foreach inst [dbGet top.insts] {
    set name [dbGet $inst.name]
    set loc  [dbGet $inst.pt]
    set cell [dbGet $inst.cell.name]

    puts "$name\t$loc\t$cell"
    incr count
}

puts "-------------------------------------------------------------"
puts "Total Instances: $count"

