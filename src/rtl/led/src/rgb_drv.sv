`timescale 1ns / 1ps
`default_nettype none

module rgb_drv (
  input  wire clk,
  input  wire rst,

  input  wire mode,

  output wire red,
  output wire grn,
  output wire blu
);


  logic [17:0] blu_cnt = '0;

  always_ff @ (posedge clk) begin
    if (rst) blu_cnt <= '0;
    else     blu_cnt <= blu_cnt + 1;
  end

  logic dir = 0;

  always_ff @ (posedge clk) begin
    if (rst | &blu_lvl) begin
      dir <= 0;
    end else if (!blu_lvl) begin
      dir <= 1;
    end
  end

  logic [7:0] blu_lvl = '0;

  always_ff @ (posedge clk) begin
    if (rst) begin
      blu_lvl <= '1;
    end else if (&blu_cnt) begin
      blu_lvl <= blu_lvl + ((dir) ? 1 : -1);
    end
  end


  assign red = 0;
  assign grn = 0;
  assign blu = (blu_cnt[17:10] > blu_lvl);


endmodule
