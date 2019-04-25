module var_del_tb;


  logic clk = 0;
  logic rst = 0;

  logic [23:0] data_i = '0;
  logic        vld_i  = 1;

  wire  [23:0] data_o;


  var_del #(
    .DATA_WIDTH (24),
    .BUFR_DEPTH (512),
    .INIT_DELAY (5)
  ) dut (
    .clk    (clk),
    .rst    (rst),
    .data_i (data_i),
    .vld_i  (vld_i),
    .data_o (data_o)
  );


  assert property (@ (posedge clk) data_o == data_i - 4)
  else begin
    $display("[ %t ] ( %m ) data_o != data_i - 4", $time());
    $display("[ %t ] ( %m ) data_i = %x", $time(), data_i);
    $display("[ %t ] ( %m ) data_o = %x", $time(), data_o);
  end


  always_latch clk <= #5 ~clk;


  always_ff @ (posedge clk) data_i <= data_i + 1;


endmodule
