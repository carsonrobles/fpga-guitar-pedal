`timescale 1ns / 1ps
`default_nettype none

`include "axi.svh"

module i2s_tx #(
  parameter int DATA_WIDTH = 8
) (
  input  wire   clk,
  input  wire   rst,
  
  axis_if.slave axis_tx,  // input tx data -- 24 bit payload

  input  wire   mclk,     // master clock out
  input  wire   lrck,     // word select (left right)
  input  wire   sclk,     // serial clock out
  output logic  sdo       // serial data out
);


  always_comb sdo = 0;


endmodule
