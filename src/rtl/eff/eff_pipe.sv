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


  localparam int DATA_WIDTH = $bits(data_i.lc);


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


  wire [DATA_WIDTH-1:0] data_del;
  wire                  vld_del;

  // TODO (carson): only works with power of 2 depth
  eff_delay #(
    .DATA_WIDTH (DATA_WIDTH),
    .FIFO_DEPTH (16384)         // half second delay
  ) eff_delay_i (
    .clk    (clk),
    .rst    (rst),
    //.en     (eff_sel[0]),
    .en     (1),
    .data_i (data_i.lc),
    .vld_i  (vld_i),
    .data_o (data_del),
    .vld_o  (vld_del)
  );


  wire [DATA_WIDTH-1:0] data_hc;
  wire                  vld_hc;

  eff_hard_clip #(
    .DATA_WIDTH (DATA_WIDTH),
    .THRESHOLD  (300000)
  ) eff_clip_i (
    .clk    (clk),
    .rst    (rst),
    //.en     (eff_sel[1]),
    .en     (0),
    //.tmp(sel[15:10]),
    .tmp('0),
    .data_i (data_del),
    .vld_i  (vld_del),
    .data_o (data_hc),
    .vld_o  (vld_hc)
  );


  wire [DATA_WIDTH-1:0] data_fl;
  wire                  vld_fl;

  eff_flanger #(
    .DATA_WIDTH (DATA_WIDTH)
  ) eff_flanger_i (
    .clk    (clk),
    .rst    (rst),
    //.en     (eff_sel[2]),
    .en     (1),
    .data_i (data_hc),
    .vld_i  (vld_hc),
    .data_o (data_fl),
    .vld_o  (vld_fl)
  );


  wire [DATA_WIDTH-1:0] data_trem;
  wire                  vld_trem;

  eff_tremolo #(
    .DATA_WIDTH (DATA_WIDTH)
  ) eff_tremolo_i (
    .clk    (clk),
    .rst    (rst),
    //.en     (eff_sel[3]),
    .en     (0),
    .data_i (data_fl),
    .vld_i  (vld_fl),
    .data_o (data_trem),
    .vld_o  (vld_trem)
  );


  // assign output data and vld
  always_comb data_o.lc = data_trem;
  always_comb data_o.rc = data_o.lc;
  always_comb vld_o     = vld_trem;


endmodule
