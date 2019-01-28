# command line args
set part      [lindex $argv 0]
set module    [lindex $argv 1]
set constr    [lindex $argv 2]
set vsrc      [lindex $argv 3]
set output    [lindex $argv 4]

create_project $module -in_memory -part $part
add_files $vsrc
read_xdc $constr

synth_design -name $module -top $module -part $part
write_checkpoint -force $output
