class async_fifo_write_sequencer extends uvm_sequencer #(async_fifo_write_item);
  
  `uvm_component_utils(async_fifo_write_sequencer)
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
endclass
