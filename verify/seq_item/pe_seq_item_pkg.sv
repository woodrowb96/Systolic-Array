package pe_seq_item_pkg;
  import uvm_pkg::*;
  import systolic_pkg::*;
  import systolic_verify_pkg::*;
  `include "uvm_macros.svh"

  class pe_seq_item extends uvm_sequence_item;
    `uvm_object_utils(pe_seq_item);

    //dut control
    rand mode_t mode;

    //dut input
    rand logic signed [TB_DATA_WIDTH-1:0] weight_in;
    rand logic signed [TB_DATA_WIDTH-1:0] activation_in;
    rand logic signed [TB_ACC_WIDTH-1:0]  psum_in;

    //dut output
    logic signed [TB_DATA_WIDTH-1:0] activation_out;
    logic signed [TB_ACC_WIDTH-1:0]  psum_out;

    logic valid; //sim only

    function new(string name = "pe_seq_item");
      super.new(name);
    endfunction

    virtual function string convert2str();
      return $sformatf("valid:%b, mode:%s weight_in:%0d activation_in:%0d psum_in:%0d, activation_out:%0d, psum_out:%0d",
             valid, mode, weight_in, activation_in, psum_in, activation_out, psum_out);
    endfunction
  endclass

endpackage
