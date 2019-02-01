`timescale 1ns / 1ps
`default_nettype none

`include "sample_pkg.svh"

module eff_pipe (
  input  wire                 clk,
  input  wire                 rst,

  input  wire                 en,
  input  wire [15:0]          sel,

  input  sample_pkg::sample_t data_i,         // input sample
  input  wire                 vld_i,          // input sample valid

  output sample_pkg::sample_t data_o,         // output sample
  output logic                vld_o           // output sample valid
);


  always_comb begin
    data_o = data_i;
    vld_o  = vld_i;
  end


endmodule
