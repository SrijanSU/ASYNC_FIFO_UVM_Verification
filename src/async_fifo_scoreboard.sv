class async_fifo_scoreboard extends uvm_component;

    `uvm_component_utils(async_fifo_scoreboard)

    uvm_tlm_analysis_fifo#(async_fifo_write_item) write_fifo;
    uvm_tlm_analysis_fifo#(async_fifo_read_item)  read_fifo;

    uvm_tlm_fifo#(async_fifo_write_item) exp_fifo;

    async_fifo_write_item write_item;
    async_fifo_read_item  read_item;

    static int  depth;
    static int  maxd;
    static bit  exp_full;
    static int  MATCH;
    static int  MISMATCH;
    static int  count;
    static bit  old_wfull = 0;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        write_fifo = new("wr_imp", this);
        read_fifo  = new("rd_imp", this);
        exp_fifo   = new("exp_fifo", this, 2**`ADDR_WIDTH);
    endfunction:new

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        fork
            writes();
            reads();
        join_none
    endtask:run_phase

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("SCOREBOARD",$sformatf("========= FINAL SCOREBOARD SUMMARY =========\n 
                            MATCH   = %0d\n MISMATCH= %0d\n COUNT   = %0d\n===========================================",
                            MATCH, MISMATCH, count),UVM_NONE)
    endfunction:report_phase

    task writes();
        forever begin
            write_fifo.get(write_item);
            depth    = exp_fifo.used();
            maxd     = exp_fifo.size();
            exp_full = (exp_fifo.used() >= exp_fifo.size());

            if (write_item.winc && !old_wfull) begin
                if (exp_fifo.used() == exp_fifo.size()) begin
                    `uvm_error("SCOREBOARD", $sformatf("WRITE is full in scoreboard but not in DUT (depth=%0d)", 
                                                       exp_fifo.used()));
                end 
                else begin
                    async_fifo_write_item cloned;
                    $cast(cloned, write_item.clone());
                    exp_fifo.put(cloned);
                    depth    = exp_fifo.used();
                    exp_full = (depth == maxd);

                    `uvm_info("SCOREBOARD",
                              $sformatf("WRITE: stored %0d (depth now=%0d)", cloned.wdata, exp_fifo.used()),
                              UVM_MEDIUM);
                end
                if (old_wfull !== exp_full) begin
                    `uvm_error("SCOREBOARD",
                               $sformatf("WFULL MISMATCH: DUT=%0b EXP=%0b depth=%0d prev=%b",
                                         write_item.wfull, exp_full, exp_fifo.used(), old_wfull));
                end 
                else begin
                    `uvm_info("SCOREBOARD",
                              $sformatf("WFULL MATCH: DUT=%0b EXP=%0b depth=%0d",
                                        write_item.wfull, old_wfull, exp_fifo.used()),
                              UVM_MEDIUM);
                end
            end 
            else if (write_item.winc && old_wfull) begin
                `uvm_info("SCOREBOARD",
                          $sformatf("WRITE BLOCKED (old_wfull=1): no data written, depth=%0d", exp_fifo.used()),
                          UVM_LOW);
            end
            old_wfull = write_item.wfull;
        end:forever
    endtask:writes

    task reads();
        int depth_before;
        bit exp_empty;

        async_fifo_write_item check;

        forever begin
            read_fifo.get(read_item);
            maxd   = exp_fifo.size();
            count++;
            depth  = exp_fifo.used();
            exp_empty = (depth == 0);

            if (read_item.rempty !== exp_empty) begin
                `uvm_error("SCOREBOARD",
                           $sformatf("rempty mismatch: DUT=%0b EXP=%0b depth=%0d",
                                     read_item.rempty, exp_empty, exp_fifo.used()));
            end

            if (read_item.rinc) begin
                if (exp_empty) begin
                    if (read_item.rempty) begin
                        `uvm_info("SCOREBOARD",
                                  $sformatf("READ blocked as expected (depth=0)"),
                                  UVM_LOW);
                    end
                end 
                else begin
                    exp_fifo.get(check);
                    depth    = exp_fifo.used();
                    maxd     = exp_fifo.size();
                    exp_full = (depth == maxd);

                    if (check.wdata !== read_item.rdata) begin
                        `uvm_error("SCOREBOARD",
                                   $sformatf("DATA MISMATCH: EXP=%d GOT=%d REMPTY=%0d (depth after pop=%0d)",
                                             check.wdata, read_item.rdata, read_item.rempty, exp_fifo.used()));
                        MISMATCH++;
                    end 
                    else begin
                        MATCH++;
                        `uvm_info("SCOREBOARD",
                                  $sformatf("DATA MATCH: EXP=%d GOT=%d REMPTY=%0d (depth now=%0d)",
                                            check.wdata, read_item.rdata, read_item.rempty, exp_fifo.used()),
                                  UVM_LOW);
                    end
                end
            end
        end:forever
    endtask:reads

endclass:async_fifo_scoreboard
