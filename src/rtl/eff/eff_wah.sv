`include "defaults.svh"


module eff_wah #(
  parameter int DATA_WIDTH = 8
) (
  input  wire                   clk,
  input  wire                   rst,

  input  wire                   en,

  input  wire  [DATA_WIDTH-1:0] data_i,
  input  wire                   vld_i,

  output logic [DATA_WIDTH-1:0] data_o,
  output logic                  vld_o
);


  wire [DATA_WIDTH-1:0] data_fir;
  wire                  vld_fir;


  fir #(
    .ORDER (61),
    .DATA_WIDTH (DATA_WIDTH),
    .COEF_WIDTH (8),
    .COEF       ({8'h02, 8'h02, 8'h02, 8'h02, 8'h02,
                  8'h02, 8'h02, 8'h02, 8'h02, 8'h02,
                  8'h02, 8'h02, 8'h02, 8'h02, 8'h02,
                  8'h02, 8'h02, 8'h02, 8'h02, 8'h02,
                  8'h02, 8'h02, 8'h02, 8'h02, 8'h02,
                  8'h02, 8'h02, 8'h02, 8'h02, 8'h02,
                  8'h02, 8'h02, 8'h02, 8'h02, 8'h02,
                  8'h02, 8'h02, 8'h02, 8'h02, 8'h02,
                  8'h02, 8'h02, 8'h02, 8'h02, 8'h02,
                  8'h02, 8'h02, 8'h02, 8'h02, 8'h02,
                  8'h02, 8'h02, 8'h02, 8'h02, 8'h02,
                  8'h02, 8'h02, 8'h02, 8'h02, 8'h02,
                  8'h02})
  ) fir_i (
    .clk    (clk),
    .rst    (rst),
    .data_i (data_i),
    .vld_i  (vld_i),
    .data_o (data_fir),
    .vld_o  (vld_fir)
  );


  assign data_o = (en) ? data_fir : data_i;
  assign vld_o  = (en) ? vld_fir  : vld_i;


endmodule
