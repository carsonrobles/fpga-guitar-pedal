`timescale 1ns / 1ps
`default_nettype none

module mclk_gen (
  input  wire clk,
  input  wire rst,
  output wire mclk
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


endmodule
