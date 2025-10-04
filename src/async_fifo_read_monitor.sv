class async_fifo_read_monitor extends uvm_component;
  
  `uvm_component_utils(async_fifo_read_monitor)
  
  virtual fifo_if.READ_MON vif;
  
  uvm_analysis_port#(async_fifo_read_item) ap;

  function new(string name, uvm_component parent); 
    super.new(name,parent); 
    ap = new("ap", this); 
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(virtual fifo_if)::get(this,"","vif",vif))
      `uvm_fatal("WRITE_MONITOR","No virtual interface");
  endfunction

  task run_phase(uvm_phase phase);
    async_fifo_read_item seq;
    forever begin
      repeat(2)@(vif.cb_r_mon);
      if (vif.cb_r_mon.rinc && !vif.cb_r_mon.rempty) begin
        seq = async_fifo_read_item::type_id::create("seq");
        seq.rinc  = vif.cb_r_mon.rinc;
        seq.rdata = vif.cb_r_mon.rdata;
        seq.rempty = vif.cb_r_mon.rempty;
        `uvm_info("READ_MONITOR",$sformatf("READ MONITOR TO SCOREBOARD"),UVM_LOW);
        ap.write(seq);
      end
    end
  endtask
  
endclass
