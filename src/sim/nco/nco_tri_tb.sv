`timescale 1ns / 1ps
`default_nettype none

module nco_tri_tb;


  logic clk = 0;
  logic rst = 0;

  logic en  = 0;
  logic nxt = 0;

  wire [2:0] wav;


  // instantiate dut
  nco_tri #(
    .N (3)
  ) dut (
    .clk (clk),
    .rst (rst),
    .en  (en),
    .nxt (nxt),
    .wav (wav)
  );


  always_latch clk <= #5 ~clk;


  initial begin
    repeat (10) @ (posedge clk);
    en  <= 1;
    nxt <= 1;
  end


endmodule
