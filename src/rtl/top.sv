`timescale 1ns / 1ps
`default_nettype none

module top (
  input  wire        FPGA_CLK_100,
  input  wire        FPGA_RST_N,

  output wire        JA_MCLK_TX,          // PMOD I2S ports
  output wire        JA_LRCK_TX,
  output wire        JA_SCLK_TX,
  output wire        JA_SDO_TX,
  output wire        JA_MCLK_RX,
  output wire        JA_LRCK_RX,
  output wire        JA_SCLK_RX,
  input  wire        JA_SDI_RX,

  input  wire [15:0] SW,
  output wire [15:0] LED
);


  // i2s signals
  wire mclk;
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

  axis_if #( .DATA_TYPE (logic [23:0]) ) axis_rx ();    // input axi stream
  axis_if #( .DATA_TYPE (logic [23:0]) ) axis_tx ();    // output axi stream

  // i2s communication
  i2s #(
    .DATA_WIDTH (24)    // 24 bit audio samples
  ) i2s_i (
    .clk     (FPGA_CLK_100),
    .rst     (~FPGA_RST_N),
    .axis_rx (axis_rx),
    .axis_tx (axis_tx),
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


endmodule
