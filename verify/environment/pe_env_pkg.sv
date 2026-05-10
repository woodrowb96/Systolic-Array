package pe_env_pkg;
  import uvm_pkg::*;
  import pe_agent_pkg::*;
  import pe_scoreboard_pkg::*;
  `include "uvm_macros.svh"


  class pe_env extends uvm_env;
    `uvm_component_utils(pe_env)

    pe_agent agn;
    pe_scoreboard scb;

    function new(string name = "pe_env", uvm_component parent=null);
      super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      agn = pe_agent::type_id::create("agn", this);
      scb = pe_scoreboard::type_id::create("scb",this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      agn.mon.mon_analysis_port.connect(scb.m_analysis_imp);
    endfunction
  endclass
endpackage
