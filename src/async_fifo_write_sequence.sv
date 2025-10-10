//============================================================
// Project      : Asynchronous FIFO Verification
// File Name    : async_fifo_write_sequence.sv
// Description  : Write-side sequence classes to generate
//                transactions for the Asynchronous FIFO.
// Author       : Srijan S Uppoor
//============================================================

//------------------------------------------------------------
// Class : async_fifo_write_sequence
// Purpose : Base sequence to generate write transactions with
//           random data and write enable control.
//------------------------------------------------------------
class async_fifo_write_sequence extends uvm_sequence #(async_fifo_write_item);
  
  `uvm_object_utils(async_fifo_write_sequence)    // Registering with Factory

  // --------------------------------------------------------
  // Constructor
  // --------------------------------------------------------
  function new(string name="async_fifo_write_sequence"); 
    super.new(name); 
  endfunction:new

  // --------------------------------------------------------
  // Task : body
  // Purpose : Generates a write transaction with winc = 1.
  // --------------------------------------------------------
  virtual task body();
    async_fifo_write_item seq;
      seq = async_fifo_write_item::type_id::create("seq");
      `uvm_rand_send_with(seq,{winc == 1;})
  endtask:body
  
endclass:async_fifo_write_sequence

//------------------------------------------------------------
// Class : wr_sequence1
// Purpose : Derived sequence that drives write enable high
//           (winc = 1) for FIFO write operation.
//------------------------------------------------------------
class wr_sequence1 extends async_fifo_write_sequence;
  
  `uvm_object_utils(wr_sequence1)      // Registering with Factory

  // --------------------------------------------------------
  // Constructor
  // --------------------------------------------------------
  function new(string name = "wr_sequence1");
    super.new(name);
  endfunction:new 

  // --------------------------------------------------------
  // Task : body
  // Purpose : Generates a transaction where winc = 1.
  // --------------------------------------------------------
  virtual task body();
    req = async_fifo_write_item::type_id::create("req");
    `uvm_rand_send_with(req,{winc == 1;})
  endtask:body
  
endclass:wr_sequence1

//------------------------------------------------------------
// Class : wr_sequence2
// Purpose : Derived sequence that drives write enable low
//           (winc = 0) to simulate idle or blocked writes.
//------------------------------------------------------------
class wr_sequence2 extends async_fifo_write_sequence ;
  
  `uvm_object_utils(wr_sequence2)    // Registering with Factory

  // --------------------------------------------------------
  // Constructor
  // --------------------------------------------------------
  function new(string name = "wr_sequence0");
    super.new(name);
  endfunction:new 

    // --------------------------------------------------------
    // Task : body
    // Purpose : Generates a transaction where winc = 0.
    // --------------------------------------------------------
  virtual task body();
    req = async_fifo_write_item::type_id::create("req");
    `uvm_rand_send_with(req,{winc == 0;})
  endtask:body
  
endclass:wr_sequence2


