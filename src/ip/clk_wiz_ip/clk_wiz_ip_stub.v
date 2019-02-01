// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (lin64) Build 2405991 Thu Dec  6 23:36:41 MST 2018
// Date        : Thu Jan 31 20:26:53 2019
// Host        : ubuntu running 64-bit Ubuntu 18.04.1 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/carson/poly/senior_project/fpga-guitar-pedal/src/ip/clk_wiz_ip/clk_wiz_ip_stub.v
// Design      : clk_wiz_ip
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_wiz_ip(clk_o, reset, locked, clk_i)
/* synthesis syn_black_box black_box_pad_pin="clk_o,reset,locked,clk_i" */;
  output clk_o;
  input reset;
  output locked;
  input clk_i;
endmodule
