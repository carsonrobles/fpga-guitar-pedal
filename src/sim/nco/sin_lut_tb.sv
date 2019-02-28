`include "defaults.svh"


module sin_lut_tb;


  logic        clk = 0;
  logic        rst = 0;

  logic [ 7:0] phi = 0;

  wire  [23:0] wav;


  sin_lut dut (
    .clk (clk),
    .rst (rst),
    .phi (phi),
    .wav (wav)
  );


  always_latch clk <= #5 ~clk;


  always_ff @ (posedge clk) begin
    if (rst) phi <= 0;
    else     phi <= phi + 1;
  end


endmodule
