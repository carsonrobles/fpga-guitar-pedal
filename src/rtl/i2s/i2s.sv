`timescale 1ns / 1ps
`default_nettype none

`include "axi.svh"

module i2s #(
  parameter int DATA_WIDTH = 8
) (
  input  wire    clk,
  input  wire    rst,

  axis_if.master axis_rx,
  axis_if.slave  axis_tx,

  input  wire    mclk,
  input  wire    lrck,
  input  wire    sclk,
  input  wire    sdi,
  output wire    sdo
);

  
  // TEMP (carson): using this to test pass through
  //assign sdo = (lrck) ? sdi : 0;


  // i2s receive
  i2s_rx #(
    .DATA_WIDTH (DATA_WIDTH)
  ) i2s_rx_i (
    .clk     (clk),
    .rst     (rst),
    .axis_rx (axis_rx),
    .mclk    (mclk),
    .lrck    (lrck),
    .sclk    (sclk),
    .sdi     (sdi)
  );

  // i2s transmit
  i2s_tx #(
    .DATA_WIDTH (DATA_WIDTH)
  ) i2s_tx_i (
    .clk     (clk),
    .rst     (rst),
    .axis_tx (axis_tx),
    .mclk    (mclk),
    .lrck    (lrck),
    .sclk    (sclk),
    .sdo     (sdo)
  );


endmodule
