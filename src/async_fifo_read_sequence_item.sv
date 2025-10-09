`include "uvm_macros.svh"
import uvm_pkg::*;

class async_fifo_read_item extends uvm_sequence_item;

    randc bit rinc;
    bit [`DATA_WIDTH-1:0] rdata;
    bit rempty;

    `uvm_object_utils_begin(async_fifo_read_item)
        `uvm_field_int(rdata, UVM_ALL_ON && UVM_DEC)
        `uvm_field_int(rinc, UVM_ALL_ON && UVM_BIN)
        `uvm_field_int(rempty, UVM_ALL_ON && UVM_BIN)
    `uvm_object_utils_end

    function new(string name = "async_fifo_read_item");
        super.new();
    endfunction:new

endclass:async_fifo_read_item
