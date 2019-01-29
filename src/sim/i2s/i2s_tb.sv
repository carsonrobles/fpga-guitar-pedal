`timescale 1ns / 1ps
`default_nettype none

`include "sample_pkg.svh"

module i2s_tb;


  logic clk = 1;
  logic rst = 0;

  axis_if #( .DATA_TYPE (sample_pkg::sample_t) ) axis_rx ();    // input axi stream
  axis_if #( .DATA_TYPE (sample_pkg::sample_t) ) axis_tx ();    // output axi stream

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
    .axis_tx (axis_rx),
    .mclk    (mclk),
    .lrck    (lrck),
    .sclk    (sclk),
    .sdi     (sdi),
    .sdo     (sdo)
  );


  // rx
  //always_comb axis_rx.rdy = 1;

  initial begin
    repeat (10) begin
    @ (negedge sclk);
    sdi <= 0;
    @ (negedge sclk);
    sdi <= 0;
    @ (negedge sclk);
    sdi <= 0;
    @ (negedge sclk);
    sdi <= 1;

    @ (negedge sclk);
    sdi <= 0;
    @ (negedge sclk);
    sdi <= 0;
    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 0;

    @ (negedge sclk);
    sdi <= 0;
    @ (negedge sclk);
    sdi <= 0;
    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 1;

    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 0;
    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 0;

    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 0;
    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 1;

    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 0;
    @ (negedge sclk);
    sdi <= 0;

    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 1;

    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 1;


    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 0;
    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 1;

    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 0;

    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 0;

    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 1;

    @ (negedge sclk);
    sdi <= 0;
    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 0;

    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 0;
    @ (negedge sclk);
    sdi <= 0;
    @ (negedge sclk);
    sdi <= 1;

    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 1;

    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 1;
    end




    @ (negedge sclk);
    sdi <= 0;
    @ (negedge sclk);
    sdi <= 0;
    @ (negedge sclk);
    sdi <= 0;
    @ (negedge sclk);
    sdi <= 1;

    @ (negedge sclk);
    sdi <= 0;
    @ (negedge sclk);
    sdi <= 0;
    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 0;

    @ (negedge sclk);
    sdi <= 0;
    @ (negedge sclk);
    sdi <= 0;
    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 1;

    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 0;
    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 0;

    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 0;
    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 1;

    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 0;
    @ (negedge sclk);
    sdi <= 0;

    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 1;

    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 1;


    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 0;
    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 1;

    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 0;

    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 0;

    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 1;

    @ (negedge sclk);
    sdi <= 0;
    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 0;

    @ (negedge sclk);
    sdi <= 1;
    @ (negedge sclk);
    sdi <= 0;
    @ (negedge sclk);
    sdi <= 0;
    @ (negedge sclk);
    sdi <= 1;
  end

  /*
  // tx
  initial     axis_tx.data = $random();

  logic [4:0] vcnt = '0;

  always_ff @ (posedge sclk) begin
    vcnt <= vcnt + 1;
  end

  logic [1:0] sft = '0;
  always_ff @ (posedge mclk)
    sft <= (sft << 1) | sclk;

  always_ff @ (posedge mclk) begin
    if (&vcnt && (~sft[1] & sft[0]))
      axis_tx.vld <= 1;
    else
      axis_tx.vld <= 0;
  end

  always_ff @ (posedge clk) begin
    if (axis_tx.ok)
      axis_tx.data = $random();
  end*/


endmodule
