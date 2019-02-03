`timescale 1ns / 1ps
`default_nettype none

`include "sample_pkg.svh"

module i2s_tb;


  logic clk = 1;
  logic rst = 0;

  //axis_if #( .DATA_TYPE (sample_pkg::sample_t) ) axis_rx ();    // input axi stream
  //axis_if #( .DATA_TYPE (sample_pkg::sample_t) ) axis_tx ();    // output axi stream

  // serial interface
  wire  mclk;
  wire  lrck;
  wire  sclk;
  logic sdi = 0;
  wire  sdo;

  
  // run clock with period 5ns (100MHz)
  always_latch clk <= #5 ~clk;

  mclk_gen mclk_gen_i (
    .clk  (clk),
    .rst  (rst),
    .mclk (mclk)
  );


  sample_pkg::sample_t data;
  wire                 vld;

  // instantiate I2S core
  i2s #(
    .DATA_WIDTH (24)      // 24-bit samples
  ) dut (
    .mclk    (mclk),
    .rst     (rst),
    .rx_data (data),
    .rx_vld  (vld),
    .tx_data (data),
    .tx_vld  (vld),
    .lrck    (lrck),
    .sclk    (sclk),
    .sdi     (sdi),
    .sdo     (sdo)
  );


  initial begin
    repeat (100) begin
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
      sdi <= 0;
      @ (negedge sclk);
      sdi <= 1;
      @ (negedge sclk);
    end
  end


endmodule
