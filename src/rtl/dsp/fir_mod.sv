`include "defaults.svh"


module fir_mod #(
  parameter int                           ORDER        = 3,
  parameter int                           DATA_WIDTH   = 8,
  parameter int                           COEF_WIDTH   = 8,
  parameter logic signed [COEF_WIDTH-1:0] COEF [ORDER] = '{default:'0},
  parameter                               FILE_NAME    = "/home/carson/poly/fpga-guitar-pedal/fab/data/lut.hex",
  parameter int                           LUT_WIDTH    = 24,
  parameter int                           LUT_DEPTH    = 512
) (
  input  wire                                 clk,
  input  wire                                 rst,

  input  wire         [$clog2(LUT_DEPTH)-1:0] jmp,

  input  wire  signed [       DATA_WIDTH-1:0] data_i,
  input  wire                                 vld_i,

  output logic signed [       DATA_WIDTH-1:0] data_o,
  output logic                                vld_o
);


  localparam int MOD_LUT_WIDTH  = LUT_WIDTH + 1;
  localparam int MOD_COEF_WIDTH = COEF_WIDTH + MOD_LUT_WIDTH;
  localparam int IMD_WIDTH      = DATA_WIDTH + MOD_COEF_WIDTH;


  // load cosine data from data file
  logic [LUT_WIDTH-1:0] cos_lut [LUT_DEPTH];

  initial begin
    $readmemh(FILE_NAME, cos_lut);
  end


  // find index for all positions needed in cosine lut
  logic [$clog2(LUT_DEPTH)-1:0] lut_ind_tmp [ORDER] = '{default:'0};
  logic [$clog2(LUT_DEPTH)-1:0] lut_ind [ORDER];
  logic [$clog2(LUT_DEPTH)-1:0] jmp_r = '0;

  always_ff @ (posedge clk) jmp_r <= jmp;

  //always_ff @ (posedge clk) begin
  /*always_comb begin
    int i;

    lut_ind[0] = '0;

    for (i = 1; i < ORDER; i += 1)
      lut_ind[i] = lut_ind[i-1] + jmp_r;
  end*/
  always_ff @ (posedge clk) begin
    int i;

    lut_ind_tmp[0] <= '0;

    for (i = 1; i < ORDER; i += 1)
      lut_ind_tmp[i] <= lut_ind_tmp[i-1] + jmp_r;
  end

  logic [$clog2(ORDER)-1:0] li_cnt = '0;
  wire                      li_add = ~(&li_cnt);

  always_ff @ (posedge clk) begin
    if (jmp_r != jmp) li_cnt <= '0;
    else              li_cnt <= li_cnt + li_add;
  end


  always_ff @ (posedge clk) begin
    if (!li_cnt) lut_ind <= lut_ind_tmp;
  end


  // values in lut to be applied to coefficients
  logic signed [MOD_LUT_WIDTH-1:0] lut_mod [ORDER];

  always_comb begin
    int i;

    for (i = 0; i < ORDER; i += 1)
      lut_mod[i] = {cos_lut[lut_ind[i]], 1'b0};   // multiply cos data by 2
  end


  // coefficients array
  logic signed [MOD_COEF_WIDTH-1:0] coef [ORDER] = '{default:'0};

  // load initial coefficients
  initial begin
    int i;

    for (i = 0; i < ORDER; i += 1)
      coef[i] = {{LUT_WIDTH{COEF[i][COEF_WIDTH-1]}}, COEF[i]};
  end

  always_ff @ (posedge clk) begin
    int i;

    for (i = 0; i < ORDER; i += 1)
      coef[i] <= {{MOD_COEF_WIDTH-COEF_WIDTH{COEF[i][COEF_WIDTH-1]}}, COEF[i]}
               * {{MOD_COEF_WIDTH-MOD_LUT_WIDTH{lut_mod[i][MOD_LUT_WIDTH-1]}}, lut_mod[i]};
  end


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
      imd[i] = {{IMD_WIDTH-MOD_COEF_WIDTH{coef[i][MOD_COEF_WIDTH-1]}}, coef[i]}
             * {{IMD_WIDTH-DATA_WIDTH{mem[i][DATA_WIDTH-1]}}, mem[i]};
  end

  // sum intermediate values
  logic signed [DATA_WIDTH-1:0] sum;

  always_comb begin
    int i;

    sum = 0;

    for (i = 0; i < ORDER; i += 1)
      sum = sum + (imd[i] >> (MOD_COEF_WIDTH-2));
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
