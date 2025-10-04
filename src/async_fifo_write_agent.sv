class async_fifo_write_agent extends uvm_agent;
  
  `uvm_component_utils(async_fifo_write_agent)
  
  async_fifo_write_driver drv;
  async_fifo_write_monitor mon;
  async_fifo_write_sequencer seqr;

  function new(string name, uvm_component parent); 
    super.new(name,parent); 
  endfunction

  function void build_phase(uvm_phase phase);
    if(get_is_active() == UVM_ACTIVE) begin
    drv  = async_fifo_write_driver::type_id::create("drv", this);
    seqr = async_fifo_write_sequencer::type_id::create("seqr", this);
    end
    mon  = async_fifo_write_monitor::type_id::create("mon", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    if(get_is_active() == UVM_ACTIVE) 
    drv.seq_item_port.connect(seqr.seq_item_export);
  endfunction
endclass
