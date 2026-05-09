module tb_pe
  import systolic_verify_pkg::*;
  import systolic_pkg::*;
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
    repeat(5) begin
      @(intf.cb_drv)
      intf.cb_drv.reset_n <= 0;
      intf.cb_drv.mode <=  LOAD;
      intf.cb_drv.weight_in <=  'd5;
      intf.cb_drv.activation_in <=  'd6;
      intf.cb_drv.psum_in <=  'd10;
    end

    repeat(5) begin
      @(intf.cb_drv)
      intf.cb_drv.reset_n <= 1;
    end

    repeat(5) begin
      @(intf.cb_drv)
      intf.cb_drv.mode <=  CALC;
      intf.cb_drv.weight_in <=  'd7;
    end

    $stop(1);
  end
endmodule
