`timescale 1ns / 1ps
`default_nettype none


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


  wire [DATA_WIDTH-1:0] data_z;
  wire [DATA_WIDTH-1:0] data_w;


  logic [15:0] cnt = '0;
  //wire  [ 8:0] del;

  always_ff @ (posedge clk) cnt <= cnt + 1;

  /*nco_tri #(
    .N (9)
  ) nco_tri_i (
    .clk (clk),
    .rst (rst),
    .en  (1),
    .nxt (&cnt),
    .wav (del)
  );*/

  wire  [23:0] wav;
  wire signed [ 7:0] del_tmp = wav[23-:8];
  wire        [ 7:0] del     = (del_tmp == -128) ? 1 : del_tmp + 128;


  nco_cos #(
    .FREQ_WIDTH (16)
  ) nco_cos_i (
    .clk (clk),
    .rst (rst),
    .en  (1),
    .freq (16'h0510),
    .wav (wav)
  );


  var_del #(
    .DATA_WIDTH (DATA_WIDTH),
    .BUFR_DEPTH (512)
  ) var_del_i (
    .clk    (clk),
    .rst    (rst),
    .del    ({1'b0, del}),
    .data_i (data_i),
    .vld_i  (vld_i),
    .data_w (data_w),
    .data_o (data_z)
  );


  always_ff @ (posedge clk)
    if (en & vld_i)
      data_o <= {data_z[23], data_z[23:1]} + {data_i[23], data_i[23:1]};//data_z + data_i;
    else if (~en)
      data_o <= data_i;

  always_ff @ (posedge clk)
    vld_o <= vld_i;


endmodule
