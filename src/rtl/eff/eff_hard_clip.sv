`timescale 1ns / 1ps
`default_nettype none

`include "sample_pkg.svh"

module eff_hard_clip #(
  parameter int DATA_WIDTH = 8,
  parameter int THRESHOLD  = 1000
) (
  input  wire                   clk,
  input  wire                   rst,

  input  wire                   en,
  input wire [5:0] tmp,

  input  wire  [DATA_WIDTH-1:0] data_i,
  input  wire                   vld_i,

  output logic [DATA_WIDTH-1:0] data_o,
  output logic                  vld_o
);


  localparam STAGES = 3;


  logic signed [DATA_WIDTH-1:0] data_eff [STAGES] = '{default:'0};
  logic        [    STAGES-1:0] vld_eff           = '0;


  wire [7:0] gain = (en) ? tmp : 1;


  // shift data and valid through pipe
  always_ff @ (posedge clk) begin
    if (rst) begin
      data_eff <= '{default:'0};
    end else begin
      data_eff[0] <= data_i;
      data_eff[1] <= data_eff[0] * gain;

      if (~en)
        data_eff[2] <= data_eff[1];
      else if (data_eff[1] > THRESHOLD)
        data_eff[2] <= THRESHOLD;
      else if (data_eff[1] < -1*THRESHOLD)
        data_eff[2] <= -1*THRESHOLD;
      else
        data_eff[2] <= data_eff[1];
    end
  end

  always_ff @ (posedge clk) begin
    if (rst) vld_eff <= '0;
    else     vld_eff <= (vld_eff << 1) | vld_i;
  end


  always_comb data_o = data_eff[STAGES-1];
  always_comb vld_o  = vld_eff [STAGES-1];


endmodule
