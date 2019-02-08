`timescale 1ns / 1ps
`default_nettype none

module rgb_drv_tb;


  logic clk  = 1;
  logic rst  = 1;

  logic mode = 0;

  wire  red;
  wire  grn;
  wire  blu;

  rgb_drv dut (
    .clk  (clk),
    .rst  (rst),
    .mode (mode),
    .red  (red),
    .grn  (grn),
    .blu  (blu)
  );


  always_latch clk <= #5 ~clk;


  initial begin
    repeat (5) @ (posedge clk);
    rst <= 0;
    repeat (2) @ (posedge clk);
    mode <= 1;
    repeat (100) @ (posedge clk);
  end


endmodule
