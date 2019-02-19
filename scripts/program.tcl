set bit_file [lindex $argv 0]

open_hw
connect_hw_server -url localhost:3121
open_hw_target

set device [lindex [get_hw_devices] 0]

current_hw_device $device
refresh_hw_device -update_hw_probes false $device
set_property PROGRAM.FILE $bit_file $device
#set_property PROBES.FILE $ltx_file $device

program_hw_devices $device
refresh_hw_device $device
