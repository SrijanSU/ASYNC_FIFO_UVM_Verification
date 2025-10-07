class async_fifo_read_driver extends uvm_driver#(async_fifo_read_item);
  
  `uvm_component_utils(async_fifo_read_driver)
  
  virtual fifo_if.READ_DRV vif;
  int first=1;
	
  function new(string name, uvm_component parent); 
    super.new(name,parent); 
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(virtual fifo_if)::get(this,"","vif",vif))
      `uvm_fatal("READ_DRIVER","No virtual interface");
  endfunction

  task run_phase(uvm_phase phase);
    async_fifo_read_item seq;
    forever begin
      seq_item_port.get_next_item(seq);
      repeat(1)@(vif.cb_r_drv);
        vif.cb_r_drv.rinc <= seq.rinc;
      `uvm_info("READ_DRIVER",$sformatf("READ DRIVER SENDING RINC=%b",seq.rinc),UVM_LOW);
      seq.print();
      seq_item_port.item_done();
    end
  endtask
  
endclass
