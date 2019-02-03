`timescale 1ns / 1ps
`default_nettype none

`include "sample_pkg.svh"

module eff_clip #(
  parameter int DATA_WIDTH = 8,
  parameter int THRESHOLD  = 1050000
) (
  input  wire                   clk,
  input  wire                   rst,

  input  wire                   en,

  input  wire  [DATA_WIDTH-1:0] data_i,
  input  wire                   vld_i,

  output logic [DATA_WIDTH-1:0] data_o,
  output logic                  vld_o
);


  logic signed [DATA_WIDTH-1:0] data_eff [3] = '{default:'0};
  logic        [           2:0] vld_eff      = '0;

  logic        [           1:0] gain         = '0;

  always_ff @ (posedge clk) begin
    if (rst | ~en) gain <= '0;
    else           gain <= 2'd2;
  end

  always_ff @ (posedge clk) begin
    data_eff[0] <= data_i;
    data_eff[1] <= data_eff[0] << gain;

    if (data_eff[1] > THRESHOLD)
      data_eff[2] <= THRESHOLD;
    else if (data_eff[1] < -1*THRESHOLD)
      data_eff[2] <= -1*THRESHOLD;
    else
      data_eff[2] <= data_eff[1];
  end

  always_ff @ (posedge clk) begin
    if (rst) vld_eff <= '0;
    else     vld_eff <= (vld_eff << 1) | vld_i;
  end


  always_ff @ (posedge clk) begin
    if (rst) begin
      data_o <= '0;
      vld_o  <=  0;
    end else begin
      data_o <= (en) ? data_eff[2] : data_i;
      vld_o  <= (en) ? vld_eff [2] : vld_i;
    end
  end


endmodule
