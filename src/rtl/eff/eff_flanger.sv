`include "defaults.svh"


module eff_flanger #(
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


  wire [23:0] wav;

  nco_cos #(
    .FREQ_WIDTH (16)
  ) nco_cos_i (
    .clk (clk),
    .rst (rst),
    .en  (1),
    .freq (16'h8aef),
    .wav (wav)
  );


  wire signed [           7:0] wav_msb = wav[23-:8];
  wire        [           7:0] del     = wav_msb + 128;
  wire        [DATA_WIDTH-1:0] data_z;

  var_del #(
    .DATA_WIDTH (DATA_WIDTH),
    .BUFR_DEPTH (512)
  ) var_del_i (
    .clk    (clk),
    .rst    (rst),
    .del    ({1'b0, del}),
    .data_i (data_i),
    .vld_i  (vld_i),
    .data_o (data_z)
  );


  always_ff @ (posedge clk)
    if (en & vld_i)
      data_o <= {data_z[23], data_z[23:1]} + {data_i[23], data_i[23:1]};      // 50/50 wet/dry signal mix
    else if (~en)
      data_o <= data_i;

  always_ff @ (posedge clk)
    vld_o <= vld_i;


endmodule
