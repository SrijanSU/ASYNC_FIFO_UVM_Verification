class async_fifo_read_sequencer extends uvm_sequencer#(async_fifo_read_item);
  
  `uvm_component_utils(async_fifo_read_sequencer)
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction:new
  
endclass:async_fifo_read_sequencer
