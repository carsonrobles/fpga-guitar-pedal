`timescale 1ns / 1ps
`default_nettype none


module tri_wave_gen #(
  parameter int N = 8
) (
  input  wire          clk,
  input  wire          rst,

  input  wire          en,
  input  wire          nxt,         // pulse for output wave to advance to next value

  output logic [N-1:0] wav = '0     // output triange wave
);


  logic dir = 0;

  always_ff @ (posedge clk) begin
    if (rst | ~en)                 dir <= 0;
    else if (wav == {N{1'b1}} - 1) dir <= 1;
    else if (wav == 1)             dir <= 0;
  end


  always_ff @ (posedge clk) begin
    if (rst | ~en) wav <= '0;
    else           wav <= (dir) ? wav - nxt : wav + nxt;
  end


endmodule
