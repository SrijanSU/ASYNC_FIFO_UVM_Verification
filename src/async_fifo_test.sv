//============================================================
// Project      : Asynchronous FIFO Verification
// File Name    : async_fifo_test.sv
// Description  : Top-level UVM test class that configures the 
//                environment, sets agent activity, and runs the 
//                virtual sequence for the Asynchronous FIFO.
// Author       : Srijan S Uppoor
//============================================================

class async_fifo_test extends uvm_test;
  
  `uvm_component_utils(async_fifo_test)    //Register the component in the factory

  async_fifo_env env;                      // Environment handle
  async_fifo_virtual_sequence vs;          // Virtual sequence handle

  // --------------------------------------------------------
  // Constructor
  // --------------------------------------------------------
  function new(string name="async_fifo_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction:new

  // --------------------------------------------------------
  // build_phase : Creates environment and sets configuration
  // --------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = async_fifo_env::type_id::create("env", this);

    // Make both read and write agents as "Active"
    uvm_config_db#(uvm_active_passive_enum)::set(this,"env.ragent" , "is_active" ,UVM_ACTIVE);      		  
    uvm_config_db#(uvm_active_passive_enum)::set(this,"env.wagent","is_active",UVM_ACTIVE);
  endfunction:build_phase

  // --------------------------------------------------------
  // run_phase : Executes the virtual sequence multiple times
  // --------------------------------------------------------
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    vs = async_fifo_virtual_sequence::type_id::create("vs");
    repeat(100)begin                                             // Run 100 iterations of the virtual sequence
      vs.start(env.vseqr);
    end
    phase.drop_objection(this);
  endtask:run_phase
  
endclass:async_fifo_test
