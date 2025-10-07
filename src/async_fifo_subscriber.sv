class async_fifo_subscriber extends uvm_component;
  
  `uvm_component_utils(async_fifo_subscriber)
  
  uvm_tlm_analysis_fifo #(async_fifo_write_item) write_cov_port;
  uvm_tlm_analysis_fifo #(async_fifo_read_item) read_cov_port;
  
  async_fifo_write_item wr_item;
  async_fifo_read_item rd_item;
  
  real write_cov_report;
  real read_cov_report;
  
  covergroup cg1;
    write_data: coverpoint wr_item.wdata{
      bins data[] = {[0:255]};
    }
    wfull: coverpoint wr_item.wfull{
      bins full_flag[] = {0,1};
    }
    winc: coverpoint wr_item.winc{
      bins winc[] = {0,1};
    }
  endgroup
  
  covergroup cg2;
    read_data: coverpoint rd_item.rdata{
      bins data[] = {[0:255]};
    }
    rempty: coverpoint rd_item.rempty{
      bins empty_flag[] = {0,1};
    }
    rinc: coverpoint rd_item.rinc{
      bins rinc[] = {0,1};
    }
  endgroup
  
  function new(string name = "fifo_subscriber", uvm_component parent);
    super.new(name, parent);
    write_cov_port = new("write_cov_port",this);
    read_cov_port = new("read_cov_port",this); 
    cg1 = new;
    cg2 = new;
  endfunction 
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
    write_cov_port.get(wr_item);
    cg1.sample();
    read_cov_port.get(rd_item);
    cg2.sample();
    end
  endtask
  
  virtual function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    write_cov_report = cg1.get_coverage();
    read_cov_report = cg2.get_coverage();
  endfunction
  
  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("get_name()",$sformatf("[WRITE] coverage = %0.2f",write_cov_report),UVM_LOW);
    `uvm_info("get_name()",$sformatf("[READ] coverage = %0.2f",read_cov_report),UVM_LOW);
  endfunction
  
endclass
