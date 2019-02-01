`timescale 1ns / 1ps
`default_nettype none

`include "sample_pkg.svh"

module eff_clip #(
  parameter int DATA_WIDTH = 8
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

  always_ff @ (posedge clk) begin
    data_eff[0] <= data_i;
    data_eff[1] <= data_eff[0] << 1;      // apply gain of 2

    if (data_eff[1] > 200)//1048576)
      data_eff[2] <= 200;//1048576;
    else if (data_eff[1] < -200)//-1048576)
      data_eff[2] <= -200;//-1048576;
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
