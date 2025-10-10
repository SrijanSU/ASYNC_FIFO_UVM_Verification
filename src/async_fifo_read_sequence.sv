//============================================================
// Project      : Asynchronous FIFO Verification
// File Name    : async_fifo_read_sequence.sv
// Description  : Contains base and derived read sequences
//                for controlling read operations(rinc=1) of Async FIFO
// Author       : Srijan S Uppoor
//============================================================

class async_fifo_read_sequence extends uvm_sequence#(async_fifo_read_item);

    `uvm_object_utils(async_fifo_read_sequence)        // Register sequence with UVM Factory

  // --------------------------------------------
  // Constructor
  // --------------------------------------------
    function new(string name = "async_fifo_read_sequence");
        super.new(name);
    endfunction:new

  // --------------------------------------------
  //  Main Phase body
  // --------------------------------------------
    task body();
        req = async_fifo_read_item::type_id::create("req");
        `uvm_rand_send_with(req, {rinc == 1;})        // Generate read operation
    endtask:body
  
endclass:async_fifo_read_sequence

//------------------------------------------------------------
// Read Sequence 1
// Generates read requests with rinc = 1
//------------------------------------------------------------
class rd_sequence1 extends async_fifo_read_sequence;

    `uvm_object_utils(rd_sequence1)        // Register sequence with UVM Factory

  // --------------------------------------------
  // Constructor
  // --------------------------------------------
    function new(string name = "rd_sequence1");
        super.new(name);
    endfunction:new

  // --------------------------------------------
  //  Main Phase body
  // --------------------------------------------
    virtual task body();
        req = async_fifo_read_item::type_id::create("req");
        `uvm_rand_send_with(req, {rinc == 1;})                 // Active read
    endtask:body

endclass:rd_sequence1

//------------------------------------------------------------
// Read Sequence 2
// Generates idle cycles (no read operation, rinc = 0)
//------------------------------------------------------------
class rd_sequence2 extends async_fifo_read_sequence;

    `uvm_object_utils(rd_sequence2)         // Register sequence with UVM Factory

  // --------------------------------------------
  // Constructor
  // --------------------------------------------
    function new(string name = "rd_sequence2");
        super.new(name);
    endfunction:new

  // --------------------------------------------
  //  Main Phase body
  // --------------------------------------------
    virtual task body();
        req = async_fifo_read_item::type_id::create("req");
        `uvm_rand_send_with(req, {rinc == 0;})                // No read
    endtask:body

endclass:rd_sequence2
