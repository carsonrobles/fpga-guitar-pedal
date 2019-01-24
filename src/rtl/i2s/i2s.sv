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

  output wire    mclk,
  output wire    lrck,
  output wire    sclk,
  input  wire    sdi,
  output wire    sdo
);


  // TODO (carson): generate mclk
  assign mclk = clk;


  // counter for creating sclk
  logic [2:0] sclk_cnt = '0;

  // increment sclk_cnt every cycle of mclk
  always_ff @ (posedge mclk) begin
    sclk_cnt <= (rst) ? '0 : sclk_cnt + 1;
  end

  // toggle sclk whenever sclk_cnt is full
  always_ff @ (posedge mclk) begin
    if (&sclk_cnt) sclk <= ~sclk;
  end


  // increment lrck_cnt every cycle of mclk
  always_ff @ (posedge mclk) begin
    lrck_cnt <= (rst) ? '0 : lrck_cnt + 1;
  end

  // toggle lrck whenever lrck_cnt is full
  always_ff @ (posedge mclk) begin
    if (&lrck_cnt) lrck <= ~lrck;
  end


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
