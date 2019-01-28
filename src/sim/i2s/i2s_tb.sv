`timescale 1ns / 1ps
`default_nettype none

module i2s_tb;


  logic clk = 1;
  logic rst = 0;

  axis_if #( .DATA_TYPE (logic [23:0]) ) axis_rx ();    // input axi stream
  axis_if #( .DATA_TYPE (logic [23:0]) ) axis_tx ();    // output axi stream

  // serial interface
  wire  mclk;
  wire  lrck;
  wire  sclk;
  logic sdi = 0;
  wire  sdo;

  
  // run clock with period 5ns (100MHz)
  always_latch clk <= #5 ~clk;


  // instantiate I2S clock generator module
  i2s_clks i2s_clks_i (
    .clk  (clk),
    .rst  (rst),
    .mclk (mclk),
    .lrck (lrck),
    .sclk (sclk)
  );

  // instantiate I2S core
  i2s #(
    .DATA_WIDTH (24)      // 24-bit samples
  ) dut (
    .clk     (clk),
    .rst     (rst),
    .axis_rx (axis_rx),
    .axis_tx (axis_tx),
    .mclk    (mclk),
    .lrck    (lrck),
    .sclk    (sclk),
    .sdi     (sdi),
    .sdo     (sdo)
  );


  // rx
  always_comb axis_rx.rdy = 1;

  always_ff @ (negedge sclk) begin
    sdi <= ~sdi;
  end

  // tx
  always_comb axis_tx.vld = 1;

  always_ff @ (posedge clk) begin
    if (axis_tx.ok)
      axis_tx.data = $random();
  end


endmodule
