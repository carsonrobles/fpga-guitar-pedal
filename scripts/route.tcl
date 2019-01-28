set place_checkpoint [lindex $argv 0]
set output           [lindex $argv 1]

open_checkpoint $place_checkpoint

route_design

write_checkpoint -force $output
