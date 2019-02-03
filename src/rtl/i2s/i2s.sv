`timescale 1ns / 1ps
`default_nettype none

`include "sample_pkg.svh"

module i2s (
  input  wire                 mclk,       // assumes 22.579MHz
  input  wire                 rst,

  output sample_pkg::sample_t rx_data = '{default:'0},
  output logic                rx_vld  = 0,

  input  sample_pkg::sample_t tx_data,
  input  wire                 tx_vld,

  output wire                 lrck,
  output wire                 sclk,
  input  wire                 sdi,
  output logic                sdo
);


  //////////////////////////////////////////////////
  // I2S CLOCK GENERATION
  //////////////////////////////////////////////////

  logic [8:0] cnt = '0;

  always_ff @ (posedge mclk) begin
    if (rst) cnt <= '0;
    else     cnt <= cnt + 1;
  end

  assign sclk = cnt[2];
  assign lrck = cnt[8];


  //////////////////////////////////////////////////
  // I2S CLOCK EDGE DETECTS AND DELAYS -- TODO (carson): remove
  //////////////////////////////////////////////////

  wire sclk_pedge = (cnt[2:0] == 3'b011);
  wire sclk_nedge = (cnt[2:0] == 3'b111);
  wire lrck_nedge = (cnt[8:0] == 9'h1ff);

  // 1 sclk period delayed lrck
  logic lrck_z = 0;

  always_ff @ (posedge mclk) begin
    if (rst)             lrck_z <= 0;
    else if (sclk_nedge) lrck_z <= lrck;
  end


  //////////////////////////////////////////////////
  // I2S RX
  //////////////////////////////////////////////////

  // left channel
  logic [31:0] rx_data_lc = '0;

  // shift in data on rising edge of sclk
  always_ff @ (posedge mclk) begin
    if (rst) begin
      rx_data_lc <= '0;
    end else if (sclk_pedge & ~lrck_z) begin
      rx_data_lc <= (rx_data_lc << 1) | sdi;
    end
  end

  // right channel
  logic [31:0] rx_data_rc = '0;

  // shift in data on rising edge of sclk
  always_ff @ (posedge mclk) begin
    if (rst) begin
      rx_data_rc <= '0;
    end else if (sclk_pedge & lrck_z) begin
      rx_data_rc <= (rx_data_rc << 1) | sdi;
    end
  end


  wire rx_vld_c = (!cnt[8:2]) & sclk_pedge;

  always_ff @ (posedge mclk) begin
    if (rst) rx_vld <= 0;
    else     rx_vld <= rx_vld_c;
  end

  // register output data when valid
  //always_ff @ (posedge mclk) begin
  always_comb begin
    if (rst) begin
      rx_data.lc = '0;
      rx_data.rc = '0;
    end else if (rx_vld) begin
      rx_data.lc = rx_data_lc[31:8];
      rx_data.rc = rx_data_rc[31:8];
    end else begin
      rx_data.lc = 'x;
      rx_data.rc = 'x;
    end
  end


  //////////////////////////////////////////////////
  // I2S TX
  //////////////////////////////////////////////////

  // register data when valid, shift out data on falling edge of sclk
  logic [31:0] tx_data_lc = '0;

  always_ff @ (posedge mclk) begin
    if (rst)                        tx_data_lc <= '0;
    else if (tx_vld)                tx_data_lc <= {tx_data.lc, 8'h0};      // TODO (carson): don't accept data during send transaction
    else if (sclk_nedge & ~lrck & cnt[7:3] > 0/*~lrck_z*/)  tx_data_lc <= tx_data_lc << 1;
  end

  logic [31:0] tx_data_rc = '0;

  always_ff @ (posedge mclk) begin
    if (rst)                       tx_data_rc <= '0;
    else if (tx_vld)               tx_data_rc <= {tx_data.rc, 8'h0};
    else if (sclk_nedge & lrck & cnt[7:3] > 0/*lrck_z*/)  tx_data_rc <= tx_data_rc << 1;
  end


  always_comb sdo = (lrck) ? tx_data_rc[31] : tx_data_lc[31];


endmodule
