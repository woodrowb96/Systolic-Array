package pe_driver_pkg;
  import uvm_pkg::*;
  import pe_seq_item_pkg::*;
  `include "uvm_macros.svh"

  class pe_driver extends uvm_driver #(pe_seq_item);
    `uvm_component_utils(pe_driver)

    virtual pe_intf vif;

    function new(string name = "pe_driver", uvm_component parent=null);
      super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      if(!uvm_config_db#(virtual pe_intf)::get(this, "", "pe_vif", vif))
        `uvm_fatal("DRV", "Could not get vif")
    endfunction

    virtual task run_phase(uvm_phase phase);
      super.run_phase(phase);

      //loop, get items from the sequencer, drive them onto the interface
      forever begin
        pe_seq_item item;
        `uvm_info("DRV", $sformatf("WAIT for item from sequence"), UVM_HIGH)
        seq_item_port.get_next_item(item);
        drive_item(item);
        seq_item_port.item_done();
      end
    endtask

    virtual task drive_item(pe_seq_item item);
      @(vif.cb_drv);
      // vif.cb_drv.valid <= 1; //sim only   NEED TO LOOK INTO THIS
      vif.cb_drv.mode          <= item.mode;
      vif.cb_drv.weight_in     <= item.weight_in;
      vif.cb_drv.activation_in <= item.activation_in;
      vif.cb_drv.psum_in       <= item.psum_in;
    endtask
  endclass

endpackage
