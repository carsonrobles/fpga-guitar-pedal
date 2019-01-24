`timescale 1ns / 1ps
`default_nettype none

`include "axi.svh"

module i2s_rx #(
  parameter int DATA_WIDTH = 8
) (
  input  wire    clk,
  input  wire    rst,
  
  axis_if.master axis_rx,   // input tx data -- 24 bit payload

  input  logic   mclk,      // master clock out
  input  logic   lrck,      // word select (left right)
  input  logic   sclk,      // serial clock out
  input  logic   sdi        // serial data in
);




endmodule
