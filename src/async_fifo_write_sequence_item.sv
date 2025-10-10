//============================================================
// Project      : Asynchronous FIFO Verification
// File Name    : async_fifo_write_item.sv
// Description  : Sequence item representing a single write-side
//                transaction for the Asynchronous FIFO.
// Author       : Srijan S Uppoor
//============================================================

`include "uvm_macros.svh"
import uvm_pkg::*;

class async_fifo_write_item extends uvm_sequence_item;

    // Data Members
    randc bit [`DATA_WIDTH-1:0] wdata;
    rand bit winc;
    bit wfull;

    // --------------------------------------------------------
    // Registering with Factory and Field Automation
    // --------------------------------------------------------
    `uvm_object_utils_begin(async_fifo_write_item)
        `uvm_field_int(wdata, UVM_ALL_ON)
        `uvm_field_int(winc,  UVM_ALL_ON)
        `uvm_field_int(wfull, UVM_ALL_ON) 
    `uvm_object_utils_end

    // --------------------------------------------------------
    // Constructor
    // --------------------------------------------------------
    function new(string name = "async_fifo_write_item");
        super.new();
    endfunction:new

endclass
