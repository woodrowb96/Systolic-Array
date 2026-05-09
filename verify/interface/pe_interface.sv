interface pe_intf
  import systolic_pkg::*;
#(
  parameter DATA_WIDTH = 8,
  parameter ACC_WIDTH  = 32
)(
  input logic clk
);
  logic reset_n;
  //control
  mode_t mode;
  //input
  logic signed [DATA_WIDTH-1:0] weight_in;
  logic signed [DATA_WIDTH-1:0] activation_in;
  logic signed [ACC_WIDTH-1:0]  psum_in;
  //output
  logic signed [DATA_WIDTH-1:0] activation_out;
  logic signed [ACC_WIDTH-1:0]  psum_out;

  bit valid; //sim only

  clocking cb_drv @(posedge clk);
    default output negedge;
    output mode, weight_in, activation_in, psum_in, reset_n, valid;
  endclocking

  clocking cb_mon @(posedge clk);
    default input #1step;
    input mode, weight_in, activation_in, psum_in, activation_out, psum_out, reset_n, valid;
  endclocking

  function void print(string msg = "");
    $display("[%s] t=%0t mode:%s weight_in:%0d activation_in:%0d psum_in:%0d, activation_out:%0d, psum_out:%0d",
             msg, $time, mode, weight_in, activation_in, psum_in, activation_out, psum_out);
  endfunction
endinterface
