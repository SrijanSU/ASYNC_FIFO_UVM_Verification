//============================================================
// Project      : Asynchronous FIFO Verification
// File Name    : async_fifo_write_agent.sv
// Description  : UVM Agent for handling the write interface
//                of the Asynchronous FIFO. It contains the
//                driver, monitor, and sequencer components.
// Author       : Srijan S Uppoor
//============================================================

class async_fifo_write_agent extends uvm_agent;

    `uvm_component_utils(async_fifo_write_agent)         // Registering with Factory

    // --------------------------------------------------------
    // Component Handles
    // --------------------------------------------------------
    async_fifo_write_driver    drv;
    async_fifo_write_monitor   mon;
    async_fifo_write_sequencer seqr;

    // --------------------------------------------------------
    // Constructor
    // --------------------------------------------------------
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction:new

    // --------------------------------------------------------
    // Build Phase
    // --------------------------------------------------------
    function void build_phase(uvm_phase phase);
        if (get_is_active() == UVM_ACTIVE) begin
            drv  = async_fifo_write_driver::type_id::create("drv", this);
            seqr = async_fifo_write_sequencer::type_id::create("seqr", this);
        end
        mon = async_fifo_write_monitor::type_id::create("mon", this);
    endfunction:build_phase

    // --------------------------------------------------------
    // Connect Phase
    // --------------------------------------------------------
    function void connect_phase(uvm_phase phase);
        if (get_is_active() == UVM_ACTIVE)
            drv.seq_item_port.connect(seqr.seq_item_export);
    endfunction:connect_phase

endclass:async_fifo_write_agent
