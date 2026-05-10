package pe_scoreboard_pkg;
  import uvm_pkg::*;
  import pe_seq_item_pkg::*;
  `include "uvm_macros.svh"

  class pe_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(pe_scoreboard)

    //TODO
    //  - add reference model

    uvm_analysis_imp #(pe_seq_item, pe_scoreboard) m_analysis_imp;

    function new(string name = "pe_scoreboard", uvm_component parent=null);
      super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      m_analysis_imp = new("m_analysis_imp", this);
    endfunction

    //score our item using the ref model
    virtual function void write(pe_seq_item item);
      `uvm_info("SCB" , $sformatf("%s", item.convert2str()), UVM_HIGH);
      //TODO
      // - add ref_model
    endfunction
  endclass

endpackage
