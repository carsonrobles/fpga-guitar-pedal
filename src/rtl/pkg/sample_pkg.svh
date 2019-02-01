`ifndef SAMPLE_PKG_SVH
`define SAMPLE_PKG_SVH

package sample_pkg;


  typedef struct {
    logic signed [23:0] lc;    // left channel data
    logic signed [23:0] rc;    // right channel data
  } sample_t;


endpackage

`endif
