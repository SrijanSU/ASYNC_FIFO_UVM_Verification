//============================================================
// Project      : Asynchronous FIFO Verification
// File Name    : async_fifo_read_driver.sv
// Description  : Read Driver for Async FIFO – drives read-side
//                control signals (rinc) based on sequence items
// Author       : Srijan S Uppoor
//============================================================

class async_fifo_read_driver extends uvm_driver#(async_fifo_read_item);

    `uvm_component_utils(async_fifo_read_driver)		// Register driver with UVM Factory

    virtual fifo_if.READ_DRV vif;					    // Virtual interface handle for read domain

	// --------------------------------------------
  	// Constructor
  	// --------------------------------------------
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction:new

	// --------------------------------------------
  	// Build Phase
  	// --------------------------------------------
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif))
            `uvm_fatal("READ_DRIVER", "No virtual interface");
    endfunction:build_phase

	// --------------------------------------------
  	// Run Phase
  	// --------------------------------------------
    task run_phase(uvm_phase phase);
        async_fifo_read_item seq;
        forever begin
            seq_item_port.get_next_item(seq);		// Wait for next sequence item from sequencer
            repeat (1) @(vif.cb_r_drv);				// Drive control signal on next read clock
            vif.cb_r_drv.rinc <= seq.rinc;
            `uvm_info("READ_DRIVER",$sformatf("READ DRIVER SENDING RINC=%b", seq.rinc),UVM_LOW)
            seq.print();
            seq_item_port.item_done();				// Indicate completion of transaction
        end
    endtask:run_phase

endclass:async_fifo_read_driver
