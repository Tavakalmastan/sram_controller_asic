
set buffers [dbGet top.insts.cell.isBuffer 1 -p]

puts "Total Buffers: [llength $buffers]"

foreach inst $buffers {
    puts [dbGet $inst.name]

}


if 0 {
set Inverter [dbGet top.insts.cell.isInverter 1 -p]

puts "Total Inverter: [llength $Inverter]"

foreach inst $Inverter {
    puts [dbGet $inst.name]
}
}
