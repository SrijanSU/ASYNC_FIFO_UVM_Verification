//============================================================
// Project      : Asynchronous FIFO Verification
// File Name    : async_fifo_virtual_sequencer.sv
// Description  : Virtual sequencer that connects the write and 
//                read sequencers, allowing coordination of 
//                their sequences in the Asynchronous FIFO testbench.
// Author       : Srijan S Uppoor
//============================================================

class async_fifo_virtual_sequencer extends uvm_sequencer;
  
  `uvm_component_utils(async_fifo_virtual_sequencer)    //Register the component with factory

  // --------------------------------------------------------
  // Handles to lower-level sequencers
  // --------------------------------------------------------
  async_fifo_write_sequencer write_seqr;
  async_fifo_read_sequencer  read_seqr;

  // --------------------------------------------------------
  // Constructor
  // --------------------------------------------------------
  function new(string name="async_fifo_virtual_sequencer", uvm_component parent=null);
    super.new(name, parent);
  endfunction:new
  
endclass:async_fifo_virtual_sequencer
