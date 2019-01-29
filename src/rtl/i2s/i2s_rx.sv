`timescale 1ns / 1ps
`default_nettype none

`include "axi.svh"
`include "sample_pkg.svh"

module i2s_rx #(
  parameter int DATA_WIDTH = 8
) (
  input  wire    clk,
  input  wire    rst,
  
  axis_if.master axis_rx,   // input tx data -- 24 bit payload

  input  wire    mclk,      // master clock out
  input  wire    lrck,      // word select (left right)
  input  wire    sclk,      // serial clock out
  input  wire    sdi        // serial data in
);


  // sclk edge detect
  logic [1:0] sclk_shift = '0;
  wire        sclk_edge  = ~sclk_shift[1] & sclk_shift[0];

  always_ff @ (posedge mclk) begin
    if (rst) sclk_shift <= '0;
    else     sclk_shift <= (sclk_shift << 1) | sclk;
  end


  // left channel
  logic [31:0] data_lc = '0;

  // shift in data on rising edge of sclk
  always_ff @ (posedge mclk) begin
    if (rst)                    data_lc <= '0;
    else if (sclk_edge & ~lrck) data_lc <= (data_lc << 1) | sdi;
  end

  // right channel
  logic [31:0] data_rc = '0;

  // shift in data on rising edge of sclk
  always_ff @ (posedge mclk) begin
    if (rst)                   data_rc <= '0;
    else if (sclk_edge & lrck) data_rc <= (data_rc << 1) | sdi;
  end


  // valid when left and right data gathered
  logic [5:0] bcnt = '0;

  wire data_vld = (sclk_edge & !bcnt);

  always_ff @ (posedge mclk) begin
    if (rst) bcnt <= '0;
    else     bcnt <= bcnt + sclk_edge;
  end

  always_ff @ (posedge mclk) begin
    if (rst | axis_rx.ok)
      axis_rx.vld <= 0;
    else if (data_vld)
      axis_rx.vld <= 1;
  end


  // register output data when valid
  always_ff @ (posedge mclk) begin
    if (rst) begin
      axis_rx.data.lc <= '0;
      axis_rx.data.rc <= '0;
    end else if (data_vld) begin
      axis_rx.data.lc <= data_lc >> 8;
      axis_rx.data.rc <= data_rc >> 8;
    end
  end


endmodule
