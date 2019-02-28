`timescale 1ns / 1ps
`default_nettype none


module eff_tremolo #(
  parameter int DATA_WIDTH = 8
) (
  input  wire                   clk,
  input  wire                   rst,

  input  wire                   en,

  input  wire  [DATA_WIDTH-1:0] data_i,
  input  wire                   vld_i,

  output logic [DATA_WIDTH-1:0] data_o,
  output logic                  vld_o
);


  localparam WAVE_WIDTH = DATA_WIDTH - 3;
  localparam STAGES     = 3;


  logic signed [  DATA_WIDTH-1:0] data_r   = '0;
  logic signed [2*DATA_WIDTH-1:0] data_m   = '0;
  logic signed [  DATA_WIDTH-1:0] data_eff = '0;
  logic        [      STAGES-1:0] vld_eff  = '0;


  logic [0:0] cnt = '0;

  always_ff @ (posedge clk) begin
    if (rst) cnt <= '0;
    else     cnt <= cnt + 1;
  end


  wire nxt = &cnt;


  wire [WAVE_WIDTH-1:0] wav;

  // instantiate triangle wave generator
  nco_tri #(
    .N (WAVE_WIDTH)
  ) nco_tri (
    .clk (clk),
    .rst (rst),
    .en  (en),
    .nxt (nxt),
    .wav (wav)
  );


  wire [DATA_WIDTH-1:0] mult = (en) ? wav : 1;


  always_ff @ (posedge clk) begin
    if (rst) begin
      data_r   <= '0;
      data_m   <= '0;
      data_eff <= '0;
    end else begin
      data_r   <= data_i;
      data_m   <= {{WAVE_WIDTH{data_r[DATA_WIDTH-1]}}, data_r} * {{WAVE_WIDTH{mult[DATA_WIDTH-1]}}, mult};
      data_eff <= (en) ? data_m >> WAVE_WIDTH : data_m;
    end
  end


  always_ff @ (posedge clk) begin
    if (rst) vld_eff <= '0;
    else     vld_eff <= (vld_eff << 1) | vld_i;
  end


  always_comb data_o = data_eff;
  always_comb vld_o  = vld_eff [STAGES-1];


endmodule
