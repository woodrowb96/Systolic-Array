/*
    Processing element for a systolic array.

Parameters:
  DATA_WIDTH: activation and weight data width

  ACC_WIDTH: accumulator width

Reset:
  logic reset_n:
    - active low (async/sync tbd) reset signal
    - when asserted:
        - tbd

Control:
  mode_t mode:
    - mode control signal
    - mode == CALC
        - processing is activly calculating the input and outputs
    - mode == LOAD
        - weight_in is being loaded in and processing is inactive

Input;
  logic signed [DATA_WIDTH-1:0] weight_in:
    - signed weight
    - when mode == LOAD weight_in is clocked into weight_reg
    - when mode == CALC weight_reg is stable


  logic signed [DATA_WIDTH-1:0] activation_in:
    - signed activation data input
    - when mode == LOAD no data is being clocked in
    - when mode == CALC data is being clocked in

  logic signed [ACC_WIDTH-1:0]  psum_in:
    - signed partial_sum input
    - when mode == LOAD no data is clocked in
    - when mode == CALC partial_sum is clocked in

Output:
  logic signed [DATA_WIDTH-1:0] activation_out:
    - activation data ouput to the next pe in the array
    - activation_out is just the passed through activation_in being clocked out
    - when mode == LOAD no data is clocked out
    - when mode == CALC activation_in is clocked out through the activation_out port

  logic signed [ACC_WIDTH-1:0]  psum_out:
    - activation partial sum output to the next pe in the array
    - when mode == LOAD no sum is calulated and clocked out
    - when mode == CALC partial_sum is calulated according to the equation
           psum_out = psum_in + activation_in * weight_reg
      then is clocked out
*/
module pe
  import systolic_pkg::*;
#(
  parameter  DATA_WIDTH = 8,
  parameter  ACC_WIDTH  = 32  //accumulator width
)(
  input logic clk,
  input logic reset_n,

  //control
  input mode_t mode,

  //input
  input logic signed [DATA_WIDTH-1:0] weight_in,
  input logic signed [DATA_WIDTH-1:0] activation_in,
  input logic signed [ACC_WIDTH-1:0]  psum_in,

  //output
  output logic signed [DATA_WIDTH-1:0] activation_out,
  output logic signed [ACC_WIDTH-1:0]  psum_out
);

endmodule
