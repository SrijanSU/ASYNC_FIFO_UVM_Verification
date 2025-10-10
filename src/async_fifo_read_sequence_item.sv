//============================================================
// Project      : Asynchronous FIFO Verification
// File Name    : async_fifo_read_item.sv
// Description  : Sequence item representing a single read-side
//                transaction for the Asynchronous FIFO.
// Author       : Srijan S Uppoor
//============================================================
`include "uvm_macros.svh"
import uvm_pkg::*;

class async_fifo_read_item extends uvm_sequence_item;

    randc bit rinc;                 // Read enable signal (1 = read)
    bit [`DATA_WIDTH-1:0] rdata;    // Data read from FIFO
    bit rempty;                     // FIFO empty flag

    // --------------------------------------------------------
    // UVM Field Macros for automation (copy, compare, print)
    // --------------------------------------------------------
    `uvm_object_utils_begin(async_fifo_read_item)
        `uvm_field_int(rdata, UVM_ALL_ON && UVM_DEC)
        `uvm_field_int(rinc, UVM_ALL_ON && UVM_BIN)
        `uvm_field_int(rempty, UVM_ALL_ON && UVM_BIN)
    `uvm_object_utils_end

    // --------------------------------------------------------
    // Constructor
    // --------------------------------------------------------
    function new(string name = "async_fifo_read_item");
        super.new();
    endfunction:new

endclass:async_fifo_read_item
