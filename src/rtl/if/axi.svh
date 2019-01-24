`ifndef AXI_SVH
`define AXI_SVH

interface axis_if #(
  parameter type DATA_TYPE = logic [0:0]
) ();

  DATA_TYPE data = '{default : '0};
  logic     vld  = 0;
  logic     rdy  = 0;

  wire      ok   = vld & rdy;

  modport master (
    output data,
    output vld,
    input  rdy,
    input  ok
  );

  modport slave (
    input  data,
    input  vld,
    output rdy,
    input  ok
  );

endinterface

`endif
