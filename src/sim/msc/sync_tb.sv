`timescale 1ns / 1ps
`default_nettype none

module sync_tb;


  logic clk = 1;
  logic rst = 0;

  logic sig_i = 0;
  wire  sig_o;


  sync #(
    .NUM_FF     (2),
    .INIT_VALUE (0)
  ) dut (
    .clk   (clk),
    .rst   (rst),
    .sig_i (sig_i),
    .sig_o (sig_o)
  );


  always_latch clk <= #5 ~clk;


  initial begin
    #01 sig_i = 1;
    #01 sig_i = 0;
    #01 sig_i = 1;
    #01 sig_i = 0;
    #25 sig_i = 1;
    #10 sig_i = 0;
    #10 sig_i = 1;

    @ (posedge clk);
    #50 rst   = 1;
    #50 rst   = 0;
  end


endmodule
