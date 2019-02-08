`timescale 1ns / 1ps
`default_nettype none

module sync #(
  parameter int NUM_FF     = 2,
  parameter bit INIT_VALUE = 0
) (
  input  wire clk,
  input  wire rst,

  input  wire sig_i,
  output wire sig_o
);


  // internal signal shift register
  logic [NUM_FF-1:0] sft = '{default:INIT_VALUE};

  // shift in async sig_i at every clock
  always_ff @ (posedge clk) begin
    if (rst) sft <= '{default:INIT_VALUE};
    else     sft <= (sft << 1) | sig_i;
  end

  // synchronized signal sig_o is the last flop in the shift register
  assign sig_o = sft[NUM_FF-1];


endmodule
