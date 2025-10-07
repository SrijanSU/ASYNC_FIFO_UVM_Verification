// `uvm_analysis_imp_decl(_read_mon)
// `uvm_analysis_imp_decl(_write_mon)

class async_fifo_scoreboard extends uvm_component;
  `uvm_component_utils(async_fifo_scoreboard)

//   uvm_analysis_imp_read_mon#(async_fifo_read_item, async_fifo_scoreboard) rd_imp;
//   uvm_analysis_imp_write_mon#(async_fifo_write_item,  async_fifo_scoreboard) wr_imp;
  
  uvm_tlm_analysis_fifo #(async_fifo_write_item) write_fifo;
  uvm_tlm_analysis_fifo #(async_fifo_read_item) read_fifo;
  
  uvm_tlm_fifo#(async_fifo_write_item) exp_fifo;

  async_fifo_write_item write_item;
  async_fifo_read_item read_item;

  bit full, empty;
  static int MATCH;
  static int MISMATCH;
  static int count;

  function new(string name, uvm_component parent);
    super.new(name,parent);
    write_fifo = new("wr_imp", this);
    read_fifo = new("rd_imp", this);
    exp_fifo   = new("exp_fifo", this, 16);
  endfunction

  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    fork
      writes();
      reads();
    join_none
  endtask 
  
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);

    `uvm_info("SCOREBOARD", 
              $sformatf("========= FINAL SCOREBOARD SUMMARY =========\nMATCH   = %0d\nMISMATCH= %0d\nCOUNT   =%0d\n===========================================", 
                        MATCH, MISMATCH,count),
              UVM_NONE)
  endfunction
  
  
  task writes();
    int depth;
    int maxd;
    bit exp_full;
    forever begin
      write_fifo.get(write_item);
      depth = exp_fifo.used();
      maxd  = exp_fifo.size();  
      exp_full = (depth == maxd);
      if (write_item.wfull !== exp_full) begin
        `uvm_error("SCOREBOARD", $sformatf("wfull mismatch: DUT=%0b EXP=%0b depth=%0d",write_item.wfull, exp_full, depth));
        MISMATCH++;
      end


      if (write_item.winc ) begin
        if (exp_full) begin
          if (write_item.wfull) begin
            `uvm_info("SCOREBOARD", $sformatf("WRITE is full %d", depth), UVM_LOW);
          end 
          
        end 
        else begin
          async_fifo_write_item cloned;
          $cast(cloned, write_item.clone());
          exp_fifo.put(cloned);
          `uvm_info("SCOREBOARD", $sformatf("WRITE: stored %d (depth now=%0d)", cloned.wdata, exp_fifo.used()), UVM_MEDIUM);
        end
      end 
      
    end
  endtask

  task reads();
    int depth_before;
    bit exp_empty;
    async_fifo_write_item check;
    forever begin
      read_fifo.get(read_item); 
      count++;
      depth_before = exp_fifo.used();
      exp_empty = (depth_before == 0);

      if (read_item.rempty !== exp_empty) begin
        `uvm_error("SCOREBOARD", $sformatf("rempty mismatch: DUT=%0b EXP=%0b depth=%0d",
                                           read_item.rempty, exp_empty, depth_before));
       // MISMATCH++;
      end

      if (read_item.rinc) begin
        if (exp_empty) begin
          if (read_item.rempty) begin
            `uvm_info("SCOREBOARD", $sformatf("READ blocked as expected (depth=0)"), UVM_LOW);
          end 
          
        end 
        else begin
          
//           if (!exp_fifo.peek(check)) begin
//             `uvm_error("SCOREBOARD", "Peeked, No data found (Should be present)");
//             MISMATCH++;
//           end 
          if(exp_fifo.try_get(check))begin
            //exp_fifo.get(check);
            if (check.wdata !== read_item.rdata) begin
              `uvm_error("SCOREBOARD", $sformatf("DATA MISMATCH: EXP=%d GOT=%d (depth before pop=%0d)",check.wdata, read_item.rdata, depth_before));
              MISMATCH++;
            end 
            else begin
              MATCH++;
              `uvm_info("SCOREBOARD", $sformatf("DATA MATCH: EXP=%d GOT=%d (depth now =%0d)",check.wdata, read_item.rdata, exp_fifo.used()), UVM_LOW);
            end
          end
        end
      end 
    end
  endtask
  
  
  
endclass
