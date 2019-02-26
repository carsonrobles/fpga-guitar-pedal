`include "defaults.svh"


module sin_lut #(
  parameter string FILE_NAME = "/home/carson/poly/fpga-guitar-pedal/data/lut.hex",
  parameter int    WIDTH     = 24,
  parameter int    DEPTH     = 256
) (
  input  wire                      clk,
  input  wire                      rst,

  input  wire  [$clog2(DEPTH)-1:0] phi,

  output logic [        WIDTH-1:0] wav
);


  logic [WIDTH-1:0] lut [DEPTH];

  initial begin
    // read sinusoid data file into lut
    $readmemh(FILE_NAME, lut);
  end


  always_comb
    wav = lut[phi];


endmodule
