`timescale 1ns / 1ps
`default_nettype none

`include "sample_pkg.svh"

module i2s (
  input  wire                 clk,
  input  wire                 rst,

  output sample_pkg::sample_t rx_data,
  output wire                 rx_vld,

  input  sample_pkg::sample_t tx_data,
  input  wire                 tx_vld,

  input  wire                 mclk,
  input  wire                 lrck,
  input  wire                 sclk,
  input  wire                 sdi,
  output wire                 sdo
);

  
  // i2s receive
  i2s_rx i2s_rx_i (
    .clk  (clk),
    .rst  (rst),
    .data (rx_data),
    .vld  (rx_vld),
    .mclk (mclk),
    .lrck (lrck),
    .sclk (sclk),
    .sdi  (sdi)
  );

  // i2s transmit
  i2s_tx i2s_tx_i (
    .clk  (clk),
    .rst  (rst),
    .data (tx_data),
    .vld  (tx_vld),
    .mclk (mclk),
    .lrck (lrck),
    .sclk (sclk),
    .sdo  (sdo)
  );


endmodule
