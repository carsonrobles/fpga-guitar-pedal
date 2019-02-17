`timescale 1ns / 1ps
`default_nettype none


module eff_tremolo_tb;


  logic        clk    = 0;
  logic        rst    = 0;

  logic        en     = 0;

  logic [11:0] data_i = '0;
  logic        vld_i  =  1;

  wire  [11:0] data_o;
  wire         vld_o;


  // instantiate dut
  eff_tremolo #(
    .DATA_WIDTH (12)
  ) dut (
    .clk    (clk),
    .rst    (rst),
    .en     (en),
    .data_i (data_i),
    .vld_i  (vld_i),
    .data_o (data_o),
    .vld_o  (vld_o)
  );


  always_latch clk <= #5 ~clk;


  always_ff @ (posedge clk)
    data_i <= data_i + 1;


  initial begin
    repeat (100) @ (posedge clk);
    en <= 1;
  end


endmodule
