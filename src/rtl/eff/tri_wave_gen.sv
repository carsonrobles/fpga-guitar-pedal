`timescale 1ns / 1ps
`default_nettype none

module tri_wave_gen #(
  parameter int N = 8
) (
  input  wire          clk,
  input  wire          rst,

  input  wire          en,
  input  wire          nxt,     // pulse for output wave to advance to next value

  output logic [N-1:0] wav      // output triange wave
);


  // edge detect nxt pulse
  logic [1:0] nxt_shift = '0;
  wire        nxt_pedge = ~nxt_shift[1] & nxt_shift[0];

  always_ff @ (posedge clk) begin
    if (rst) nxt_shift <= '0;
    else     nxt_shift <= (nxt_shift << 1) | nxt;
  end


  logic dir = 0;

  always_ff @ (posedge clk) begin
    if (rst | (wav <= 1)) dir <= 0;
    else if (&(wav | 1))  dir <= 1;
  end

  always_ff @ (posedge clk) begin
    if (rst) wav <= '0;
    else     wav <= (dir) ? wav - nxt_pedge : wav + nxt_pedge;
  end


endmodule
