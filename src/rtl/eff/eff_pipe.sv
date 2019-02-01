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


  sample_pkg::sample_t data_eff;
  wire                 vld_eff;

  always_comb begin
    data_o = (en) ? data_eff : data_i;
    vld_o  = (en) ? vld_eff  : vld_i;
  end


  eff_clip #(
    .DATA_WIDTH ($bits(data_i.lc))
  ) eff_clip_i (
    .clk    (clk),
    .rst    (rst),
    .en     (sel[0]),
    .data_i (data_i.lc),
    .vld_i  (vld_i),
    .data_o (data_eff.lc),
    .vld_o  (vld_eff)
  );


endmodule
