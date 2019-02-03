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


  wire [$bits(data_i.lc)-1:0] data_eff;
  wire                        vld_eff;


  always_comb data_o.lc = data_eff;
  always_comb data_o.rc = data_o.lc;
  always_comb vld_o     = vld_eff;


  logic [15:0] eff_sel = '0;

  always_ff @ (posedge clk) begin
    int i;

    if (rst) begin
      eff_sel <= '0;
    end else begin
      for (i = 0; i < $bits(eff_sel); i += 1)
        eff_sel[i] <= en & sel[i];
    end
  end


  eff_clip #(
    .DATA_WIDTH ($bits(data_i.lc))
  ) eff_clip_i (
    .clk    (clk),
    .rst    (rst),
    .en     (eff_sel[0]),
    .data_i (data_i.lc),
    .vld_i  (vld_i),
    .data_o (data_eff),
    .vld_o  (vld_eff)
  );


endmodule
