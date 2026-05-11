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

      wait(vif.reset_n);

      forever begin
        pe_seq_item item;
        @(vif.cb_drv);
        //If we have a valid transaction available then drive it and set valid == 1
        //If we dont, set valid == 0 then loop around to the next clk cycle and try again
        seq_item_port.try_next_item(item);
        if(item != null) begin
          vif.cb_drv.valid <= 1; //sim only, so monitor knows the interface has a valid transaction on it
          vif.cb_drv.mode          <= item.mode;
          vif.cb_drv.weight_in     <= item.weight_in;
          vif.cb_drv.activation_in <= item.activation_in;
          vif.cb_drv.psum_in       <= item.psum_in;
          seq_item_port.item_done();
        end
        else begin
          vif.cb_drv.valid <= 1'b0;
        end
      end
    endtask
  endclass

endpackage
