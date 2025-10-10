//============================================================
// Project      : Asynchronous FIFO Verification
// File Name    : async_fifo_read_monitor.sv
// Description  : Read Monitor for Async FIFO – captures read-side
//                transactions and sends them to the scoreboard
// Author       : Srijan S Uppoor
//============================================================

class async_fifo_read_monitor extends uvm_component;

    `uvm_component_utils(async_fifo_read_monitor)         // Register monitor with UVM Factory

    virtual fifo_if.READ_MON vif;                         // Virtual interface handle for read domain
    int first = 1;                                        // Used to handle initial synchronization

    uvm_analysis_port#(async_fifo_read_item) ap;          // Analysis port to send data to scoreboard/subscriber

    // --------------------------------------------
    // Constructor
    // --------------------------------------------
    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction:new

  // --------------------------------------------
  // Build Phase
  // --------------------------------------------
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif))
            `uvm_fatal("WRITE_MONITOR", "No virtual interface");
    endfunction:build_phase

  // --------------------------------------------
  // Run Phase
  // Samples read domain signals and reports transactions
  // --------------------------------------------
    task run_phase(uvm_phase phase);
        async_fifo_read_item seq;
        forever begin
            repeat (1) @(vif.cb_r_mon);        // Wait for read clock edge
            if (vif.cb_r_mon.rinc) begin       // Sample only when read increment (rinc) is asserted
                seq = async_fifo_read_item::type_id::create("seq");
                seq.rinc   = vif.cb_r_mon.rinc;
                seq.rdata  = vif.cb_r_mon.rdata;
                seq.rempty = vif.cb_r_mon.rempty;
                `uvm_info("READ_MONITOR", $sformatf("READ MONITOR TO SCOREBOARD"), UVM_LOW)
                ap.write(seq);                   // Send sampled transaction to scoreboard or subscriber
                if (first) begin                 // Handle first-cycle synchronization if needed
                    first = 0;
                    repeat (2) @(vif.cb_r_mon);
                end
            end
        end
    endtask:run_phase

endclass:async_fifo_read_monitor 
