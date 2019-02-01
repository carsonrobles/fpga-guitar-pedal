`timescale 1ns / 1ps
`default_nettype none

`include "sample_pkg.svh"

module i2s_rx (
  input  wire                 clk,
  input  wire                 rst,
  
  output sample_pkg::sample_t data = '{default:'0},
  output logic                vld  = 0,

  input  wire                 mclk,      // master clock out
  input  wire                 lrck,      // word select (left right)
  input  wire                 sclk,      // serial clock out
  input  wire                 sdi        // serial data in
);


  // sclk edge detect
  logic [1:0] sclk_shift = '0;
  wire        sclk_pedge = ~sclk_shift[1] & sclk_shift[0];

  always_ff @ (posedge mclk) begin
    if (rst) sclk_shift <= '0;
    else     sclk_shift <= (sclk_shift << 1) | sclk;
  end


  // lrck edge detect
  logic [1:0] lrck_shift = '0;
  wire        lrck_nedge = (lrck_shift[1] & ~lrck_shift[0]);

  always_ff @ (posedge mclk) begin
    if (rst) lrck_shift <= '0;
    else     lrck_shift <= (lrck_shift << 1) | lrck;
  end


  // left channel
  logic [31:0] data_lc = '0;

  // shift in data on rising edge of sclk
  always_ff @ (posedge mclk) begin
    if (rst)                     data_lc <= '0;
    else if (sclk_pedge & ~lrck) data_lc <= (data_lc << 1) | sdi;
  end

  // right channel
  logic [31:0] data_rc = '0;

  // shift in data on rising edge of sclk
  always_ff @ (posedge mclk) begin
    if (rst)                    data_rc <= '0;
    else if (sclk_pedge & lrck) data_rc <= (data_rc << 1) | sdi;
  end


  // valid when left and right data gathered
  logic [5:0] bcnt = '0;

  // TODO (carson): this is high before any data is brought in since bcnt starts at 0
  wire data_vld = (sclk_pedge & !bcnt);

  always_ff @ (posedge mclk) begin
    if (rst | lrck_nedge) bcnt <= '0;
    else                  bcnt <= bcnt + sclk_pedge;
  end

  always_ff @ (posedge mclk) begin
    if (rst) vld <= 0;
    else     vld <= data_vld;
  end


  // register output data when valid
  always_ff @ (posedge mclk) begin
    if (rst) begin
      data.lc <= '0;
      data.rc <= '0;
    end else if (data_vld) begin
      data.lc <= data_lc[31:8];
      data.rc <= data_rc[31:8];
    end
  end


endmodule
