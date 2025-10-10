//============================================================
// Project      : Asynchronous FIFO Verification
// File Name    : async_fifo_write_monitor.sv
// Description  : UVM Monitor for the write-side of the
//                Asynchronous FIFO. Captures DUT transactions
//                from the write interface and sends them to
//                the analysis port for scoreboard/coverage.
// Author       : Srijan S Uppoor
//============================================================

class async_fifo_write_monitor extends uvm_component;

    `uvm_component_utils(async_fifo_write_monitor)        // Registering with Factory

    virtual fifo_if.WRITE_MON vif;                // Write-side monitor interface
    int first = 1;

    uvm_analysis_port#(async_fifo_write_item) ap;         // Analysis port to send observed transactions

    // --------------------------------------------------------
    // Constructor
    // --------------------------------------------------------
    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction:new

    // --------------------------------------------------------
    // Build Phase
    // --------------------------------------------------------
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif))
            `uvm_fatal("READ_MONITOR", "No virtual interface");
    endfunction:build_phase

    // --------------------------------------------------------
    // Run Phase
    // --------------------------------------------------------
    task run_phase(uvm_phase phase);
        async_fifo_write_item seq;
        forever begin
            repeat (1) @(vif.cb_w_mon);
            if (vif.cb_w_mon.winc) begin
                seq = async_fifo_write_item::type_id::create("seq");
                seq.winc  = vif.cb_w_mon.winc;
                seq.wdata = vif.cb_w_mon.wdata;
                seq.wfull = vif.cb_w_mon.wfull;
                `uvm_info("WRITE_MONITOR", $sformatf("WRITE MONITOR TO SCOREBOARD"), UVM_LOW)
                ap.write(seq);
            end
        end
    endtask:run_phase

endclass:async_fifo_write_monitor
