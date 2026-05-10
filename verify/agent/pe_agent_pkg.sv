package pe_agent_pkg;
  import uvm_pkg::*;
  import pe_driver_pkg::*;
  import pe_monitor_pkg::*;
  import pe_seq_item_pkg::*;
  `include "uvm_macros.svh"

  class pe_agent extends uvm_agent;
    `uvm_component_utils(pe_agent)

    pe_driver drv;
    pe_monitor mon;
    uvm_sequencer #(pe_seq_item) seq;

    function new(string name = "pe_agent", uvm_component parent=null);
      super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      seq = uvm_sequencer#(pe_seq_item)::type_id::create("seq",this);
      drv = pe_driver::type_id::create("drv",this);
      mon = pe_monitor::type_id::create("mon",this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);

      drv.seq_item_port.connect(seq.seq_item_export);
    endfunction
  endclass

endpackage
