package systolic_verify_pkg;
  localparam CLK_PERIOD = 10;  //with 1ns timeunits -> 100 MHz

  //cycles needed for all inputs to get output at the end of testing after the
  //last sequence_item has been driven into the DUT
  localparam PE_LATENCY = 1;

  localparam TB_DATA_WIDTH = 8;
  localparam TB_ACC_WIDTH  = 32;
endpackage
