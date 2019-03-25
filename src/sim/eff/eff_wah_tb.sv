`include "defaults.svh"


module eff_wah_tb;


  logic        clk    =  0;
  logic        rst    =  0;

  logic        en     =  1;

  logic [23:0] data_i = '0;
  wire         vld_i;

  wire  [23:0] data_o;
  wire         vld_o;

  eff_wah #(
    .DATA_WIDTH (24)
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


  logic [2:0] cnt = '0;

  always_ff @ (posedge clk) begin
    cnt <= cnt + 1;
  end


  // increment incoming data every 8 clocks and make valid
  /*always_ff @ (posedge clk) begin
    if (data_i < 8'hff)
      data_i <= data_i + 1;//&cnt;
    else data_i <= 0;
  end*/

  assign vld_i = &cnt;


  nco_cos #(
    .FILE_NAME  ("/home/carson/poly/fpga-guitar-pedal/fab/data/lut.hex"),
    .WIDTH      (24),
    .DEPTH      (512),
    .FREQ_WIDTH (16)
  ) nco_cos_i (
    .clk (clk),
    .rst (rst),
    .en  (1),
    .freq (16'hffff),
    .wav  (data_i)
  );


  initial begin
    // initial setup: /rst, en
    /*@ (posedge clk);
    rst <= 0;
    en  <= 1;

    // test dropping en, keeping valid and data running
    repeat (150) @ (posedge clk);
    en <= 0;
    repeat (70) @ (posedge clk);
    en <= 1;

    // test reset
    repeat (70) @ (posedge clk);
    rst <= 1;
    repeat (10) @ (posedge clk);
    rst <= 0;*/
  end


endmodule
