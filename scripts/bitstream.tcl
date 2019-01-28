set route_checkpoint [lindex $argv 0]
set output           [lindex $argv 1]

open_checkpoint $route_checkpoint

write_bitstream -force $output
