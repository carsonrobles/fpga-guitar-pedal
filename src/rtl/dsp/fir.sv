`include "defaults.svh"


module fir #(
  parameter int                           ORDER        = 3,
  parameter int                           DATA_WIDTH   = 8,
  parameter int                           COEF_WIDTH   = 8,
  parameter logic signed [COEF_WIDTH-1:0] COEF [ORDER] = '{default:'0}
) (
  input  wire                          clk,
  input  wire                          rst,

  input  wire  signed [DATA_WIDTH-1:0] data_i,
  input  wire                          vld_i,

  output logic signed [DATA_WIDTH-1:0] data_o,
  output logic                         vld_o
);


  localparam int IMD_WIDTH = DATA_WIDTH + COEF_WIDTH;


  // buffer for past samples
  logic signed [DATA_WIDTH-1:0] mem [ORDER] = '{default:'0};
  logic        [     ORDER-1:0] vld         = '0;

  always_ff @ (posedge clk) begin
    int i;

    if (rst) begin
      mem <= '{default:'0};
    end else if (vld_i) begin
      mem[0] <= data_i;

      for (i = ORDER - 1; i > 0; i -= 1)
        mem[i] <= mem[i-1];
    end
  end

  always_ff @ (posedge clk) begin
    if (rst)        vld <= '0;
    else if (vld_i) vld <= (vld << 1) | vld_i;
  end


  // compute intermediate values
  logic signed [IMD_WIDTH-1:0] imd [ORDER];

  always_comb begin
    int i;

    for (i = 0; i < ORDER; i += 1)
      imd[i] = {{IMD_WIDTH-COEF_WIDTH{COEF[i][COEF_WIDTH-1]}}, COEF[i]}
             * {{IMD_WIDTH-DATA_WIDTH{mem[i][DATA_WIDTH-1]}}, mem[i]};
  end

  // sum intermediate values
  logic signed [DATA_WIDTH-1:0] sum;

  always_comb begin
    int i;

    sum = 0;

    for (i = 0; i < ORDER; i += 1)
      sum = sum + (imd[i] >> (COEF_WIDTH-1));
  end


  // register output data and valid flag
  always_ff @ (posedge clk) begin
    if (rst) data_o <= '0;
    else     data_o <= sum;
  end

  always_ff @ (posedge clk) begin
    if (rst) vld_o <= 0;
    else     vld_o <= vld[ORDER-1];
  end


endmodule
