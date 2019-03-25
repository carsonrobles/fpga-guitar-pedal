`include "defaults.svh"


module nco_cos #(
  parameter  FILE_NAME  = "/home/carson/poly/fpga-guitar-pedal/fab/data/lut.hex",
  parameter int    WIDTH      = 24,
  parameter int    DEPTH      = 512,
  parameter int    FREQ_WIDTH = 8
) (
  input  wire                   clk,
  input  wire                   rst,

  input  wire                   en,

  input  wire  [FREQ_WIDTH-1:0] freq,

  output logic [     WIDTH-1:0] wav
);


  localparam int PHI_WIDTH = $clog2(DEPTH);


  logic [FREQ_WIDTH-1:0] freq_r = '0;
  logic [FREQ_WIDTH-1:0] cnt    = '0;

  always_ff @ (posedge clk) begin
    if (rst | cnt == freq_r) cnt <= '0;
    else     cnt <= cnt + 1;
  end

  always_ff @ (posedge clk) begin
    if (rst)                freq_r <= 0;
    else if (cnt == freq_r) freq_r <= ~freq;
  end


  logic [PHI_WIDTH-1:0] phi = '0;

  always_ff @ (posedge clk) begin
    if (rst) phi <= '0;
    else     phi <= phi + (cnt == freq_r);
  end


  cos_lut #(
    .FILE_NAME (FILE_NAME),
    .WIDTH     (WIDTH),
    .DEPTH     (DEPTH)
  ) cos_lut_i (
    .clk (clk),
    .rst (rst),
    .phi (phi),
    .wav (wav)
  );


endmodule
