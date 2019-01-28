set synth_checkpoint [lindex $argv 0]
set output           [lindex $argv 1]

open_checkpoint $synth_checkpoint

place_design

write_checkpoint -force $output
