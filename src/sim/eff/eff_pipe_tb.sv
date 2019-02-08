`timescale 1ns / 1ps
`default_nettype none

`include "sample_pkg.svh"

module eff_pipe_tb;


  logic clk = 1;
  logic rst = 0;

  logic        en  =  0;
  logic [15:0] sel = '1;

  sample_pkg::sample_t data_i = '{default:'0};
  logic                vld_i  =  0;

  sample_pkg::sample_t data_o;
  logic                vld_o;

  eff_pipe dut (
    .clk    (clk),
    .rst    (rst),
    .en     (en),
    .sel    (sel),
    .data_i (data_i),
    .vld_i  (vld_i),
    .data_o (data_o),
    .vld_o  (vld_o)
  );


  always_latch clk <= #5 ~clk;


  logic dir = 1;

  always_ff @ (posedge clk) begin
    if (rst)                         dir <= 1;
    else if (data_i.lc >= 200)  dir <= 0;
    else if (data_i.lc <= -200) dir <= 1;
  end


  always_ff @ (posedge clk) begin
    if (rst) begin
      data_i.lc <= '0;
      //data_i.rc <= '0;
    end else begin
      data_i.lc <= data_i.lc + ((dir) ? 1 : -1);
      //data_i.rc <= ~data_i.lc + 1;
    end
  end

  always_comb data_i.rc = ~data_i.lc + 1;


  initial begin
    repeat (100) begin
      repeat(1000) @ (posedge clk);
      en <= ~en;
    end
  end


endmodule
