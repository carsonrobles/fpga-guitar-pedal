`timescale 1ns / 1ps
`default_nettype none

module i2s_clks (
  input  wire clk,
  input  wire rst,

  output wire  mclk,
  output logic lrck = 0,
  output logic sclk = 0
);


  wire mclk_pll;
  wire mclk_locked;

  // generate mclk
  clk_wiz_ip clk_wiz_ip_i (
    .clk_o  (mclk_pll),     // 22.579MHz i2s master clock out
    .reset  (rst),
    .locked (mclk_locked),
    .clk_i  (clk)           // 100MHz system clock in
  );

  // keep mclk low until pll is locked
  assign mclk = (mclk_locked) ? mclk_pll : 0;


  // counter for creating sclk
  logic [1:0] sclk_cnt = '0;

  // increment sclk_cnt every cycle of mclk
  always_ff @ (posedge mclk) begin
    sclk_cnt <= (rst | ~mclk_locked) ? '0 : sclk_cnt + 1;
  end

  // toggle sclk whenever sclk_cnt is full
  always_ff @ (posedge mclk) begin
    if (&sclk_cnt) sclk <= ~sclk;
  end


  // counter for creating lrck (44.1kHz)
  logic [7:0] lrck_cnt = '0;

  // increment lrck_cnt every cycle of mclk
  always_ff @ (posedge mclk) begin
    lrck_cnt <= (rst | ~mclk_locked) ? '0 : lrck_cnt + 1;
  end

  // toggle lrck whenever lrck_cnt is full
  always_ff @ (posedge mclk) begin
    if (&lrck_cnt) lrck <= ~lrck;
  end


endmodule
