package pe_monitor_pkg;
  import uvm_pkg::*;
  import pe_seq_item_pkg::*;
  `include "uvm_macros.svh"

  class pe_monitor extends uvm_monitor;
    `uvm_component_utils(pe_monitor)

    virtual pe_intf vif;

    uvm_analysis_port #(pe_seq_item) mon_analysis_port;

    function new(string name = "pe_monitor", uvm_component parent=null);
      super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      //hookup interface
      if(!uvm_config_db#(virtual pe_intf)::get(this, "", "pe_vif", vif))
        `uvm_fatal("MON", "Could not get vif")

      mon_analysis_port = new("mon_analysis_port", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
      super.run_phase(phase);

      forever begin
        @(vif.cb_mon);
        if(vif.reset_n) begin
          pe_seq_item item = pe_seq_item::type_id::create("item");

          //sample DUT inputs
          item.mode          = vif.cb_mon.mode;
          item.weight_in     = vif.cb_mon.weight_in;
          item.activation_in = vif.cb_mon.activation_in;
          item.psum_in       = vif.cb_mon.psum_in;

          //sample DUT outputs
          item.activation_out = vif.cb_mon.activation_out;
          item.psum_out       = vif.cb_mon.psum_out;

          //send item to scoreboard
          mon_analysis_port.write(item);
          `uvm_info("MON", $sformatf("Saw item %s", item.convert2str()), UVM_HIGH)
        end
      end
    endtask
  endclass

endpackage
