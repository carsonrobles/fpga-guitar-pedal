`timescale 1ns / 1ps
`default_nettype none

// shift in data on vld_i
// output data is last register in mem

module del_fifo #(
  parameter int DATA_WIDTH = 8,
  parameter int FIFO_DEPTH = 8
) (
  input  wire                   clk,
  input  wire                   rst,

  input  wire                   en,

  input  wire  [DATA_WIDTH-1:0] data_i,
  input  wire                   vld_i,

  output logic [DATA_WIDTH-1:0] data_o
);


  logic [        DATA_WIDTH-1:0] mem    [FIFO_DEPTH];
  logic [$clog2(FIFO_DEPTH)-1:0] rd_ptr;
  logic [$clog2(FIFO_DEPTH)-1:0] wr_ptr = '0;


  wire wr = en & vld_i;


  // increment write pointer on valid write
  always_ff @ (posedge clk) begin
    if (rst)     wr_ptr <= 0;
    else if (wr) wr_ptr <= wr_ptr + 1;
  end

  // read pointer should always lead write pointer by address
  always_comb rd_ptr = wr_ptr + 1;


  // write on vld and en
  always_ff @ (posedge clk) begin
    if (wr) mem[wr_ptr] <= data_i;
  end


  // register output data
  always_ff @ (posedge clk) data_o = mem[wr_ptr];


endmodule
