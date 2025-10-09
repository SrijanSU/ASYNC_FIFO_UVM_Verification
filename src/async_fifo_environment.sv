//===========================================================
// Project: Asynchronous FIFO Verification (UVM Environment)
// Module : async_fifo_env
// Description : 
//  The environment acts as the top-level container in the UVM testbench, instantiating all major components such as agents, 
//  scoreboard, subscriber, and virtual sequencer. It also manages connections between components.
// Author       : Srijan S Uppoor
//===========================================================

class async_fifo_env extends uvm_env;

    `uvm_component_utils(async_fifo_env)  // Register this class with the UVM factory

    async_fifo_write_agent       wagent;   // Write-side agent
    async_fifo_read_agent        ragent;   // Read-side agent
    async_fifo_scoreboard        sb;       // Scoreboard for data comparison
    async_fifo_virtual_sequencer vseqr;    // Virtual sequencer for coordinating sequences
    async_fifo_subscriber        scb;      // Subscriber for functional coverage

    virtual fifo_if vif;                  // Virtual interface handle

    //===========================================================
    // Constructor
    //===========================================================
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction:new

    //===========================================================
    // Build Phase
    //===========================================================
    function void build_phase(uvm_phase phase);
        if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", "Virtual interface 'vif' not set in uvm_config_db")
        end
        wagent = async_fifo_write_agent::type_id::create("wagent", this);
        ragent = async_fifo_read_agent::type_id::create("ragent", this);
        sb     = async_fifo_scoreboard::type_id::create("sb", this);
        vseqr  = async_fifo_virtual_sequencer::type_id::create("vseqr", this);
        scb    = async_fifo_subscriber::type_id::create("scb", this);
    endfunction:build_phase

    //===========================================================
    // Connect Phase
    //===========================================================
    function void connect_phase(uvm_phase phase);
        wagent.mon.ap.connect(sb.write_fifo.analysis_export);    // Connect monitor analysis ports to scoreboard
        ragent.mon.ap.connect(sb.read_fifo.analysis_export);     // Connect monitor analysis ports to scoreboard
        ragent.mon.ap.connect(scb.read_cov_port.analysis_export);// Connect monitor analysis ports to subscriber for coverage
        wagent.mon.ap.connect(scb.write_cov_port.analysis_export);// Connect monitor analysis ports to subscriber for coverage

        // Connect virtual sequencer to agents' sequencers
        vseqr.write_seqr = wagent.seqr;
        vseqr.read_seqr  = ragent.seqr;
    endfunction:connect_phase

endclass:async_fifo_env
