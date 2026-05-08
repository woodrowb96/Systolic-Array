/*
    Processing element for a systolic array.

Parameters:
  DATA_WIDTH: activation and weight data width

  ACC_WIDTH: accumulator width

Reset:
  logic reset_n:
    - active low asyncronous reset signal
    - when asserted:
        - weight_reg     <= 0
        - activation_out <= 0
        - psum_out       <= 0

Control:
  mode_t mode:
    - mode control signal
    - mode == CALC
        - processing is actively calculating the input and outputs
    - mode == LOAD
        - weight_in is being loaded in and processing is inactive

Input:
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
    - activation data output to the next pe in the array
    - activation_out is just the passed through activation_in being clocked out
    - when mode == LOAD no data is clocked out
    - when mode == CALC activation_in is clocked out through the activation_out port

  logic signed [ACC_WIDTH-1:0]  psum_out:
    - partial sum output to the next pe in the array
    - when mode == LOAD no sum is calculated and clocked out
    - when mode == CALC partial_sum is calculated according to the equation
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

  logic signed [DATA_WIDTH-1:0]   weight_reg;
  logic signed [2*DATA_WIDTH-1:0] product;

  /*********** WEIGHT REGISTER *****************/
  always_ff @(posedge clk, negedge reset_n) begin
    if(~reset_n) begin
      weight_reg <= '0;
    end
    else if(mode == LOAD) begin
      weight_reg <= weight_in;
    end
  end

  /*********** ACTIVATION PASSTHROUGH **********/
  always_ff @(posedge clk, negedge reset_n) begin
    if(~reset_n) begin
      activation_out <= '0;
    end
    else if(mode == LOAD) begin
      activation_out <= '0;
    end
    else begin
      activation_out <= activation_in;
    end
  end

  /*********** PSUM_OUT CALCULATION ***************/
  assign product = weight_reg * activation_in;

  always_ff @(posedge clk, negedge reset_n) begin
    if(~reset_n) begin
      psum_out <= '0;
    end
    else if(mode == LOAD) begin
      psum_out <= '0;
    end
    else begin
      psum_out <= psum_in + product;
    end
  end
endmodule
