package pe_seq_pkg;
  import uvm_pkg::*;
  import systolic_verify_pkg::*;
  import pe_seq_item_pkg::*;
  `include "uvm_macros.svh"

  class pe_seq extends uvm_sequence;
    `uvm_object_utils(pe_seq)

    int seq_length;

    function new(string name = "pe_seq");
      super.new(name);
    endfunction

    //TODO:
    //No constraints yet, just get randomization working

    virtual task body();
      for(int i = 0; i < seq_length; i++) begin

        //create item with UVMs factory
        pe_seq_item item = pe_seq_item::type_id::create("item");

        //start_item handshake with the driver and sequencer
        start_item(item);

        //randomize the item

        if(item.randomize()) begin
          `uvm_info("SEQ", $sformatf("Generate new item: %s", item.convert2str()), UVM_HIGH);
        end
        else begin
          `uvm_fatal("SEQ", "Failed item.randomize().")
        end

        //tell driver and sequencer the item is ready
        finish_item(item);
      end
      `uvm_info("SEQ", $sformatf("Done generating %0d items", seq_length), UVM_HIGH);
    endtask
  endclass

endpackage
