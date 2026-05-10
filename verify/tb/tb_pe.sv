module tb_pe
  import systolic_verify_pkg::*;
  import systolic_pkg::*;
  import uvm_pkg::*;
  import pe_test_pkg::*;
  `include "uvm_macros.svh"
();
  /******* TB CLK *******/
  bit clk;
  initial begin
    clk = 0;
    forever #(CLK_PERIOD/2) clk = ~clk;
  end

  /******* INTERFACE **********/
  pe_intf #(.DATA_WIDTH(TB_DATA_WIDTH), .ACC_WIDTH(TB_ACC_WIDTH)) intf(.clk);

  /********** DUT ***************/
  pe #(.DATA_WIDTH(TB_DATA_WIDTH), .ACC_WIDTH(TB_ACC_WIDTH)) dut(
    .clk(clk),
    .reset_n(intf.reset_n),
    .mode(intf.mode),
    .weight_in(intf.weight_in),
    .activation_in(intf.activation_in),
    .psum_in(intf.psum_in),
    .activation_out(intf.activation_out),
    .psum_out(intf.psum_out)
  );

  /******** TESTING **********/
  initial begin
    uvm_config_db#(virtual pe_intf)::set(null, "uvm_test_top", "pe_vif", intf);
    run_test("pe_test_1");
    $stop(1);
  end
endmodule
