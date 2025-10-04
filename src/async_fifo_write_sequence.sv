class async_fifo_write_sequence extends uvm_sequence #(async_fifo_write_item);
  
  `uvm_object_utils(async_fifo_write_sequence)
  
  function new(string name="async_fifo_write_sequence"); 
    super.new(name); 
  endfunction

  virtual task body();
    async_fifo_write_item seq;
//     repeat (2) begin
      seq = async_fifo_write_item::type_id::create("seq");
      `uvm_rand_send_with(seq,{winc == 1;})
   
//     end
  endtask
  
endclass
