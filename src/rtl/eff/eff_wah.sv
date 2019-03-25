`include "defaults.svh"


module eff_wah #(
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


  wire [           4:0] jmp;
  wire [DATA_WIDTH-1:0] data_fir;
  wire                  vld_fir;

  fir_mod #(
    .ORDER (61),
    .DATA_WIDTH (DATA_WIDTH),
    .COEF_WIDTH (8),
    .COEF       ({8'h02, 8'h02, 8'h02, 8'h02, 8'h02,
                  8'h02, 8'h02, 8'h02, 8'h02, 8'h02,
                  8'h02, 8'h02, 8'h02, 8'h02, 8'h02,
                  8'h02, 8'h02, 8'h02, 8'h02, 8'h02,
                  8'h02, 8'h02, 8'h02, 8'h02, 8'h02,
                  8'h02, 8'h02, 8'h02, 8'h02, 8'h02,
                  8'h02, 8'h02, 8'h02, 8'h02, 8'h02,
                  8'h02, 8'h02, 8'h02, 8'h02, 8'h02,
                  8'h02, 8'h02, 8'h02, 8'h02, 8'h02,
                  8'h02, 8'h02, 8'h02, 8'h02, 8'h02,
                  8'h02, 8'h02, 8'h02, 8'h02, 8'h02,
                  8'h02, 8'h02, 8'h02, 8'h02, 8'h02,
                  8'h02})
  ) fir_mod (
    .clk    (clk),
    .rst    (rst),
    .jmp    ({4'h0, jmp}),
    .data_i (data_i),
    .vld_i  (vld_i),
    .data_o (data_fir),
    .vld_o  (vld_fir)
  );

  // TODO (carson): remove
  wire [ DATA_WIDTH-1:0] data_fir_dbg;
  wire                   vld_fir_dbg;

  fir #(
    .ORDER (61),
    .DATA_WIDTH (DATA_WIDTH),
    .COEF_WIDTH (8),
    .COEF       ({8'h02, 8'h02, 8'h02, 8'h02, 8'h02,
                  8'h02, 8'h02, 8'h02, 8'h02, 8'h02,
                  8'h02, 8'h02, 8'h02, 8'h02, 8'h02,
                  8'h02, 8'h02, 8'h02, 8'h02, 8'h02,
                  8'h02, 8'h02, 8'h02, 8'h02, 8'h02,
                  8'h02, 8'h02, 8'h02, 8'h02, 8'h02,
                  8'h02, 8'h02, 8'h02, 8'h02, 8'h02,
                  8'h02, 8'h02, 8'h02, 8'h02, 8'h02,
                  8'h02, 8'h02, 8'h02, 8'h02, 8'h02,
                  8'h02, 8'h02, 8'h02, 8'h02, 8'h02,
                  8'h02, 8'h02, 8'h02, 8'h02, 8'h02,
                  8'h02, 8'h02, 8'h02, 8'h02, 8'h02,
                  8'h02})
  ) fir_dbg (
    .clk    (clk),
    .rst    (rst),
    .data_i (data_i),
    .vld_i  (vld_i),
    .data_o (data_fir_dbg),
    .vld_o  (vld_fir_dbg)
  );


  logic [17:0] cnt = '0;
  //logic [7:0] cnt = 0;

  always_ff @ (posedge clk) begin
    if (rst) cnt <= '0;
    else     cnt <= cnt + 1;
  end


  wire nxt = &cnt;


  // instantiate triangle wave generator
  nco_tri #(
    .N (5)
  ) nco_tri (
    .clk (clk),
    .rst (rst),
    .en  (en),
    .nxt (nxt),
    .wav (jmp)
  );

  wire [DATA_WIDTH-1:0] data_fir_fir;
  wire                  vld_fir_fir;
  fir #(
    .ORDER (61),
    .DATA_WIDTH (DATA_WIDTH),
    .COEF_WIDTH (8),
    .COEF       ({8'h02, 8'h02, 8'h02, 8'h02, 8'h02,
                  8'h02, 8'h02, 8'h02, 8'h02, 8'h02,
                  8'h02, 8'h02, 8'h02, 8'h02, 8'h02,
                  8'h02, 8'h02, 8'h02, 8'h02, 8'h02,
                  8'h02, 8'h02, 8'h02, 8'h02, 8'h02,
                  8'h02, 8'h02, 8'h02, 8'h02, 8'h02,
                  8'h02, 8'h02, 8'h02, 8'h02, 8'h02,
                  8'h02, 8'h02, 8'h02, 8'h02, 8'h02,
                  8'h02, 8'h02, 8'h02, 8'h02, 8'h02,
                  8'h02, 8'h02, 8'h02, 8'h02, 8'h02,
                  8'h02, 8'h02, 8'h02, 8'h02, 8'h02,
                  8'h02, 8'h02, 8'h02, 8'h02, 8'h02,
                  8'h02})
  ) fir_lp (
    .clk    (clk),
    .rst    (rst),
    .data_i (data_fir),
    .vld_i  (vld_fir),
    .data_o (data_fir_fir),
    .vld_o  (vld_fir_fir)
  );


  //assign data_o = (en) ? data_fir<<1 : data_i;
  //assign vld_o  = (en) ? vld_fir  : vld_i;
  assign data_o = (en) ? data_fir_fir<<1 : data_i;
  assign vld_o  = (en) ? vld_fir_fir  : vld_i;


endmodule
