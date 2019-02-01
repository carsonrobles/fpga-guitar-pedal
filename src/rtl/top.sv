`timescale 1ns / 1ps
`default_nettype none

`include "sample_pkg.svh"

module top (
  input  wire        FPGA_CLK_100,
  input  wire        FPGA_RST_N,

  input  wire [15:0] SW,                  // switches
  output wire [15:0] LED,                 // LEDs
  output wire [ 2:0] RGB_L,               // RGB LEDs
  output wire [ 2:0] RGB_R,

  output wire        JA_MCLK_TX,          // PMOD I2S ports
  output wire        JA_LRCK_TX,
  output wire        JA_SCLK_TX,
  output wire        JA_SDO_TX,
  output wire        JA_MCLK_RX,
  output wire        JA_LRCK_RX,
  output wire        JA_SCLK_RX,
  input  wire        JA_SDI_RX
);


  wire mclk;

  // synchronize reset
  logic [1:0] rst_sync;

  always_ff @ (posedge mclk) begin
    rst_sync <= (rst_sync << 1) | ~FPGA_RST_N;
  end

  wire rst = rst_sync[1];


  wire lrck;
  wire sclk;

  // i2s clock generator
  i2s_clks i2s_clks_i (
    .clk  (FPGA_CLK_100),
    .rst  (~FPGA_RST_N),
    .mclk (mclk),
    .lrck (lrck),
    .sclk (sclk)
  );

  //axis_if #( .DATA_TYPE (sample_pkg::sample_t) ) axis_pt ();    // pass through stream

  sample_pkg::sample_t data;
  wire                 vld;

  // i2s communication
  i2s i2s_i (
    .clk     (FPGA_CLK_100),
    .rst     (~FPGA_RST_N),
    //.axis_rx (axis_pt),
    //.axis_tx (axis_pt),
    .rx_data (data),
    .rx_vld  (vld),
    .tx_data (data),
    .tx_vld  (vld),
    .mclk    (mclk),
    .lrck    (lrck),
    .sclk    (sclk),
    .sdi     (JA_SDI_RX),
    .sdo     (JA_SDO_TX)
  );

  // assign PMOD clock outputs
  assign JA_MCLK_TX = mclk;
  assign JA_LRCK_TX = lrck;
  assign JA_SCLK_TX = sclk;
  assign JA_MCLK_RX = mclk;
  assign JA_LRCK_RX = lrck;
  assign JA_SCLK_RX = sclk;


  // leds follow switches
  assign LED = SW;

  // heartbeat LEDs
  rgb_drv rgb_drv_l_i (
    .clk  (FPGA_CLK_100),
    .rst  (~FPGA_RST_N),
    .mode (1),
    .red  (RGB_L[0]),
    .grn  (RGB_L[1]),
    .blu  (RGB_L[2])
  );

  assign RGB_R[0] = 0;
  assign RGB_R[1] = 0;
  assign RGB_R[2] = ~RGB_L[2];


endmodule
