`timescale 1ns / 1ps
`default_nettype none


module sync_fifo #(
  parameter int DATA_WIDTH = 8,
  parameter int FIFO_DEPTH = 8
) (
  input  wire                   clk,
  input  wire                   rst,

  input  wire                   en,
  input  wire                   we,

  input  wire  [DATA_WIDTH-1:0] data_i,

  output logic [DATA_WIDTH-1:0] data_o
);


  logic [        DATA_WIDTH-1:0] mem    [FIFO_DEPTH];
  logic [$clog2(FIFO_DEPTH)-1:0] wr_ptr = '0;


  wire wr = en & we;


  // increment write pointer on valid write
  always_ff @ (posedge clk) begin
    if (rst)     wr_ptr <= 0;
    else if (wr) wr_ptr <= wr_ptr + 1;
  end

  // write on we and en
  always_ff @ (posedge clk) begin
    if (wr) mem[wr_ptr] <= data_i;
  end


  // register output data
  always_ff @ (posedge clk) data_o = mem[wr_ptr];


endmodule
