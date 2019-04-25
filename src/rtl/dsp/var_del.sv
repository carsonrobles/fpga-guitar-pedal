`include "defaults.svh"


module var_del #(
  parameter int DATA_WIDTH = 8,
  parameter int BUFR_DEPTH = 512
) (
  input  wire                           clk,
  input  wire                           rst,

  input  wire  [$clog2(BUFR_DEPTH)-1:0] del,

  input  wire  [        DATA_WIDTH-1:0] data_i,
  input  wire                           vld_i,

  output logic [        DATA_WIDTH-1:0] data_o
);


  logic [        DATA_WIDTH-1:0] mem    [BUFR_DEPTH] = '{default:'0};   // past data samples
  logic [$clog2(BUFR_DEPTH)-1:0] nd_ptr              = '0;              // new data pointer
  logic [$clog2(BUFR_DEPTH)-1:0] dd_ptr              = '0;              // delayed data pointer

  // increment new data pointer when valid data enters
  always_ff @ (posedge clk) begin
    if (rst) nd_ptr <= '0;
    else     nd_ptr <= nd_ptr + vld_i;
  end

  // write new data when valid data enters
  always_ff @ (posedge clk) begin
    if (vld_i) mem[nd_ptr] <= data_i;
  end


  // delays must be at least 1
  wire [$bits(del)-1:0] del_r = (del < 1) ? 1 : del;


  always_ff @ (posedge clk) dd_ptr <= nd_ptr - del - 1;
  always_ff @ (posedge clk) data_o <= mem[dd_ptr];


endmodule
