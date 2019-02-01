`timescale 1ns / 1ps
`default_nettype none

`include "sample_pkg.svh"

module i2s_tx (
  input  wire                 clk,
  input  wire                 rst,
  
  input  sample_pkg::sample_t data,
  input  wire                 vld,

  input  wire                 mclk,     // master clock out
  input  wire                 lrck,     // word select (left right)
  input  wire                 sclk,     // serial clock out
  output logic                sdo       // serial data out
);


  // sclk edge detect
  logic [1:0] sclk_shift = '0;
  wire        sclk_nedge = sclk_shift[1] & ~sclk_shift[0];
  wire        sclk_pedge = ~sclk_shift[1] & sclk_shift[0];

  always_ff @ (posedge mclk) begin
    if (rst) sclk_shift <= '0;
    else     sclk_shift <= (sclk_shift << 1) | sclk;
  end


  // 1 sclk period delayed lrck
  logic lrck_z = 0;

  always_ff @ (posedge mclk) begin
    if (rst)              lrck_z <= 0;
    else if (sclk_pedge) lrck_z <= lrck;
  end


  // register data when valid, shift out data on falling edge of sclk
  logic [31:0] data_l = '0;

  always_ff @ (posedge mclk) begin
    if (rst)                        data_l <= '0;
    else if (vld)                   data_l <= {data.lc, 8'h0};      // TODO (carson): don't accept data during send transaction
    else if (sclk_nedge & ~lrck_z)  data_l <= data_l << 1;
  end

  logic [31:0] data_r = '0;

  always_ff @ (posedge mclk) begin
    if (rst)                       data_r <= '0;
    else if (vld)                  data_r <= {data.rc, 8'h0};
    else if (sclk_nedge & lrck_z)  data_r <= data_r << 1;
  end


  always_comb sdo = (lrck_z) ? data_r[31] : data_l[31];


endmodule
