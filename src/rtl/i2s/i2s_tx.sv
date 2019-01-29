`timescale 1ns / 1ps
`default_nettype none

`include "axi.svh"
`include "sample_pkg.svh"

module i2s_tx #(
  parameter int DATA_WIDTH = 8
) (
  input  wire   clk,
  input  wire   rst,
  
  axis_if.slave axis_tx,  // input tx data -- 24 bit payload

  input  wire   mclk,     // master clock out
  input  wire   lrck,     // word select (left right)
  input  wire   sclk,     // serial clock out
  output logic  sdo       // serial data out
);


  // register data when valid
  always_comb axis_tx.rdy = 1;






  // send left and right data 

  // sclk edge detect
  logic [1:0] sclk_shift = '0;
  wire        sclk_edge_n  = sclk_shift[1] & ~sclk_shift[0];
  wire        sclk_edge_p  = ~sclk_shift[1] & sclk_shift[0];

  always_ff @ (posedge mclk) begin
    if (rst) sclk_shift <= '0;
    else     sclk_shift <= (sclk_shift << 1) | sclk;
  end


  // 1 sclk period delayed lrck
  logic lrck_z = 0;

  always_ff @ (posedge mclk) begin
    if (rst)            lrck_z <= 0;
    else if (sclk_edge_p) lrck_z <= lrck;
  end


  // shift out data on falling edge of sclk
  //logic [31:0] data_l = '0;
  logic [31:0] data_l = '0;

  always_ff @ (posedge mclk) begin
    if (rst)                     data_l <= '0;
    else if (axis_tx.ok)         data_l <= {axis_tx.data.lc, 8'h0};
    else if (sclk_edge_n & ~lrck_z)  data_l <= data_l << 1;
  end

  logic [31:0] data_r = '0;

  always_ff @ (posedge mclk) begin
    if (rst)                    data_r <= '0;
    else if (axis_tx.ok)        data_r <= {axis_tx.data.rc, 8'h0};
    else if (sclk_edge_n & lrck_z)  data_r <= data_r << 1;
  end


  //always_comb sdo = data_l[31];
  always_comb sdo = (lrck_z) ? data_r[31] : data_l[31];


endmodule
