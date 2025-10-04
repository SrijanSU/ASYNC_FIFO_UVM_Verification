class async_fifo_read_sequence extends uvm_sequence #(async_fifo_read_item);
  
  `uvm_object_utils(async_fifo_read_sequence)
  
  function new(string name="async_fifo_read_sequence"); 
    super.new(name);
  endfunction

  task body();
    req = async_fifo_read_item::type_id::create("req");
    `uvm_rand_send_with(req,{rinc == 1;})
  endtask
  
endclass
