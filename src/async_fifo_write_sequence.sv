class async_fifo_write_sequence extends uvm_sequence #(async_fifo_write_item);
  
  `uvm_object_utils(async_fifo_write_sequence)
  
  function new(string name="async_fifo_write_sequence"); 
    super.new(name); 
  endfunction

  virtual task body();
    async_fifo_write_item seq;
      seq = async_fifo_write_item::type_id::create("seq");
      `uvm_rand_send_with(seq,{winc == 1;})
  endtask
  
endclass


class wr_sequence1 extends async_fifo_write_sequence;
  
  `uvm_object_utils(wr_sequence1)
  
  function new(string name = "wr_sequence1");
    super.new(name);
  endfunction 
  
  virtual task body();
    req = async_fifo_write_item::type_id::create("req");
    `uvm_rand_send_with(req,{winc == 1;})
  endtask
endclass

class wr_sequence2 extends async_fifo_write_sequence ;
  
  `uvm_object_utils(wr_sequence2)
  
  function new(string name = "wr_sequence0");
    super.new(name);
  endfunction 
  
  virtual task body();
    req = async_fifo_write_item::type_id::create("req");
    `uvm_rand_send_with(req,{winc == 0;})
  endtask
endclass


