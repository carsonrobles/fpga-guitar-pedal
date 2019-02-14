`timescale 1ns / 1ps
`default_nettype none

module eff_delay #(
  parameter int DATA_WIDTH = 8,
  parameter int FIFO_DEPTH = 8
) (
  input  wire                   clk,
  input  wire                   rst,

  input  wire                   en,

  input  wire  [DATA_WIDTH-1:0] data_i,
  input  wire                   vld_i,

  output logic [DATA_WIDTH-1:0] data_o,
  output logic                  vld_o
);



  localparam STAGES = 2;


  logic signed [DATA_WIDTH-1:0] data_eff [STAGES] = '{default:'0};
  logic        [    STAGES-1:0] vld_eff           = '0;


  // delayed data
  wire  signed [DATA_WIDTH-1:0] data_z;

  // instantiate delay fifo
  del_fifo #(
    .DATA_WIDTH (DATA_WIDTH),
    .FIFO_DEPTH (FIFO_DEPTH)
  ) del_fifo_i (
    .clk    (clk),
    .rst    (rst),
    .en     (1),
    .data_i (data_o),
    .vld_i  (vld_o),
    .data_o (data_z)
  );


  // if not enabled want to sum 0 for no delay
  wire [DATA_WIDTH-1:0] data_add = (en) ? data_z : '0;

  // shift data and add in delayed data
  always_ff @ (posedge clk) begin
    if (rst) begin
      data_eff <= '{default:'0};
    end else begin
      data_eff[0] <= data_i;
      data_eff[1] <= data_eff[0] + {data_add[DATA_WIDTH-1], data_add[DATA_WIDTH-1:1]};
    end
  end


  always_ff @ (posedge clk) begin
    if (rst) vld_eff <= '0;
    else     vld_eff <= (vld_eff << 1) | vld_i;
  end


  always_comb data_o = data_eff[STAGES-1];
  always_comb vld_o  = vld_eff [STAGES-1];


endmodule
