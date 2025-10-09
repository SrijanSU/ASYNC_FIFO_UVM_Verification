//============================================================
// Project      : Asynchronous FIFO Verification
// File Name    : async_fifo_read_agent.sv
// Description  : Read Agent for Async FIFO – integrates driver, 
//                monitor, and sequencer for the read domain
// Author       : Srijan S Uppoor
//============================================================

class async_fifo_read_agent extends uvm_agent;

    `uvm_component_utils(async_fifo_read_agent)    // Register agent with UVM Factory

  // --------------------------------------------
  // Component Declarations
  // --------------------------------------------
    async_fifo_read_driver    drv;
    async_fifo_read_monitor   mon;
    async_fifo_read_sequencer seqr;

    // --------------------------------------------
    // Constructor
    // --------------------------------------------
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction:new

    // --------------------------------------------
    // Build Phase
    // --------------------------------------------
    function void build_phase(uvm_phase phase);
        if (get_is_active() == UVM_ACTIVE) begin
            drv  = async_fifo_read_driver::type_id::create("drv", this);
            seqr = async_fifo_read_sequencer::type_id::create("seqr", this);
        end
        mon = async_fifo_read_monitor::type_id::create("mon", this);
    endfunction:build_phase

    // --------------------------------------------
    // Connect Phase
    // Connects sequencer and driver (TLM connections)
    // --------------------------------------------
    function void connect_phase(uvm_phase phase);
        if (get_is_active() == UVM_ACTIVE)
            drv.seq_item_port.connect(seqr.seq_item_export);
    endfunction: connect_phase

endclass:async_fifo_read_agent
