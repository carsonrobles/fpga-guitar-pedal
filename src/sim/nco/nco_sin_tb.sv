`include "defaults.svh"


module nco_sin_tb;


  logic        clk  = 0;
  logic        rst  = 0;

  logic        en   = 0;

  logic [ 7:0] freq = 0;

  wire  [23:0] wav;

  nco_sin #(
    .FILE_NAME  ("/home/carson/poly/fpga-guitar-pedal/fab/data/lut.hex"),
    .WIDTH      (24),
    .DEPTH      (256),
    .FREQ_WIDTH (8)
  ) dut (
    .clk  (clk),
    .rst  (rst),
    .en   (en),
    .freq (freq),
    .wav  (wav)
  );


  always_latch clk <= #5 ~clk;


  logic [11:0] cnt = '0;

  always_ff @ (posedge clk) begin
    if (rst) cnt <= '0;
    else     cnt <= cnt + 1;
  end


  always_ff @ (posedge clk) begin
    if (rst)       freq <= '0;
    else if (&cnt) freq <= freq + 1;
  end


endmodule
