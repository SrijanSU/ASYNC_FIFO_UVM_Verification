class async_fifo_test extends uvm_test;
  
  `uvm_component_utils(async_fifo_test)

  async_fifo_env env;
  async_fifo_virtual_sequence vs;

  function new(string name="async_fifo_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction:new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = async_fifo_env::type_id::create("env", this);
    
    uvm_config_db#(uvm_active_passive_enum)::set(this,"env.ragent" , "is_active" ,UVM_ACTIVE);      		  
    uvm_config_db#(uvm_active_passive_enum)::set(this,"env.wagent","is_active",UVM_ACTIVE);
  endfunction:build_phase

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    vs = async_fifo_virtual_sequence::type_id::create("vs");
    repeat(1000)begin
      vs.start(env.vseqr);
    end:repeat
    phase.drop_objection(this);
  endtask:run_phase
  
endclass:async_fifo_test
