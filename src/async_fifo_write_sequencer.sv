//============================================================
// Project      : Asynchronous FIFO Verification
// File Name    : async_fifo_write_sequencer.sv
// Description  : Sequencer for generating write-side sequence
//                items to be sent to the FIFO write driver.
// Author       : Srijan S Uppoor
//============================================================

class async_fifo_write_sequencer extends uvm_sequencer #(async_fifo_write_item);
  
  `uvm_component_utils(async_fifo_write_sequencer)        // Registering with Factory

  // --------------------------------------------------------
  // Constructor
  // --------------------------------------------------------
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction:new
  
endclass:async_fifo_write_sequencer
