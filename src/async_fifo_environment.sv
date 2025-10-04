class async_fifo_env extends uvm_env;
  
  `uvm_component_utils(async_fifo_env)

  async_fifo_write_agent wagent;
  async_fifo_read_agent  ragent;
  async_fifo_scoreboard  sb;
  async_fifo_virtual_sequencer vseqr;
  async_fifo_subscriber scb;
  
  virtual fifo_if vif;

  function new(string name, uvm_component parent); 
    super.new(name,parent); 
  endfunction

  function void build_phase(uvm_phase phase);
    if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal("NOVIF", "Virtual interface 'vif' not set in uvm_config_db")
    end
    wagent = async_fifo_write_agent::type_id::create("wagent", this);
    ragent = async_fifo_read_agent ::type_id::create("ragent", this);
    sb     = async_fifo_scoreboard ::type_id::create("sb", this);
    vseqr  = async_fifo_virtual_sequencer::type_id::create("vseqr", this);
    scb    = async_fifo_subscriber::type_id::create("scb",this);
  endfunction

  function void connect_phase(uvm_phase phase);
    wagent.mon.ap.connect(sb.write_fifo.analysis_export);
    ragent.mon.ap.connect(sb.read_fifo.analysis_export);
    ragent.mon.ap.connect(scb.read_cov_port.analysis_export);
    wagent.mon.ap.connect(scb.write_cov_port.analysis_export);
    
    vseqr.write_seqr = wagent.seqr;   
    vseqr.read_seqr  = ragent.seqr;
    
  endfunction
  
endclass
