foreach nets [dbGet top.nets.name] {
    set fo [dbGet [dbGet top.nets.name $nets -p].numTerms]
    if {$fo > 10} {
        puts "$nets --> $fo"
    }
}
