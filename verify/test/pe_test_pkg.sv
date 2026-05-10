package tb_tests_pkg;
  import uvm_pkg::*;
  import pe_env_pkg::*;
  import pe_seq_pkg::*;
  import systolic_verify_pkg::*;
  `include "uvm_macros.svh"

  /************************ BASE TEST ******************************/
  class pe_base_test extends uvm_test;
    `uvm_component_utils(pe_base_test)

    virtual pe_intf vif;
    pe_env env;
    pe_seq seq;

    function new(string name = "pe_base_test", uvm_component parent = null);
      super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      env = pe_env::type_id::create("env", this);

      if(!uvm_config_db#(virtual pe_intf)::get(this, "", "pe_vif", vif))
        `uvm_fatal("TEST", "Could not get vif")

      uvm_config_db#(virtual pe_intf)::set(this, "env.agn.*", "pe_vif", vif);

      seq = pe_seq::type_id::create("seq");
      // seq.seq_length = 10; //hardcode for now ... well figure a better way ... idk where to do this yet?
    endfunction

    virtual task run_phase(uvm_phase phase);
      phase.raise_objection(this);

      apply_reset_n();            //reset the interface
      seq.start(env.agn.seq);     //start generating sequences
      #(CLK_PERIOD * 1.5)         //wait a bit, so the last trans can get processed (not sure here?)

      //testing is done so drop our objection
      phase.drop_objection(this);
    endtask

    virtual task apply_reset_n();
      @(vif.cb_mon)
      vif.cb_mon.reset_n <= 0;
      @(vif.cb_mon)
      vif.cb_mon.reset_n <= 1;
    endtask
  endclass

  /************************ TEST 1 ******************************/
  class pe_test_1 extends pe_base_test;
    `uvm_component_utils(pe_test_1)

    function new(string name = "pe_test_1", uvm_component parent = null);
      super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      seq.seq_length = 10;
    endfunction
  endclass
endpackage
