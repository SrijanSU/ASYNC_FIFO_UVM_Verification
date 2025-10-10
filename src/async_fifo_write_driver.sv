//============================================================
// Project      : Asynchronous FIFO Verification
// File Name    : async_fifo_write_driver.sv
// Description  : UVM Driver for the write-side of the
//                Asynchronous FIFO. Responsible for driving
//                the DUT write interface using sequence items.
// Author       : Srijan S Uppoor
//============================================================

class async_fifo_write_driver extends uvm_driver#(async_fifo_write_item);

    `uvm_component_utils(async_fifo_write_driver)        // Registering with Factory

    virtual fifo_if.WRITE_DRV vif;                       // Virtual Interface Handle

    // --------------------------------------------------------
    // Constructor
    // --------------------------------------------------------
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction:new

    // --------------------------------------------------------
    // Build Phase
    // --------------------------------------------------------
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif))
            `uvm_fatal("WRITE_DRIVER", "No virtual interface");
    endfunction:build_phase

    // --------------------------------------------------------
    // Run Phase
    // --------------------------------------------------------
    task run_phase(uvm_phase phase);
        async_fifo_write_item seq;
        forever begin
            seq_item_port.get_next_item(seq);
            repeat (1) @(vif.cb_w_drv);
            vif.cb_w_drv.wdata <= seq.wdata;
            vif.cb_w_drv.winc  <= seq.winc;
            `uvm_info("WRITE_DRIVER",
                      $sformatf("WRITE DRIVER SENDING: WDATA=%d, WINC=%b", seq.wdata, seq.winc),
                      UVM_LOW)
            seq_item_port.item_done();
        end
    endtask:run_phase

endclass:async_fifo_write_driver
