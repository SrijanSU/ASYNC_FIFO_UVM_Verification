`include "uvm_macros.svh"
  import uvm_pkg::*;

class async_fifo_write_item extends uvm_sequence_item;

  rand bit [`DATA_WIDTH-1:0] wdata;
  rand bit winc;
  bit wfull;

  `uvm_object_utils_begin(async_fifo_write_item)
  `uvm_field_int(wdata , UVM_ALL_ON)
  `uvm_field_int(winc,UVM_ALL_ON)
  `uvm_field_int(wfull,UVM_ALL_ON) 
  `uvm_object_utils_end

   function new(string name = "asyc_fifo_write_item");
      super.new();
   endfunction
  
endclass
