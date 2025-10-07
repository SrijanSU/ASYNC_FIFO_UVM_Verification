`include "defines.sv"

interface fifo_if(input bit wclk,input bit rclk, input bit wrst_n,input bit rrst_n);

  logic [`DATA_WIDTH-1:0] wdata;
  logic winc;
  logic wfull;
  logic [`DATA_WIDTH-1:0] rdata;
  logic rinc;
  logic rempty;

  clocking cb_w_drv @(posedge wclk or negedge wrst_n);
    default input #0 output #0;
    output winc, wdata;
  endclocking

  clocking cb_r_drv @(posedge rclk or negedge rrst_n);
    default input #0 output #0;
    output rinc;
  endclocking
  
  clocking cb_w_mon @(posedge wclk or negedge wrst_n);
    default input #0 output #0;
    input winc, wdata, wfull;
  endclocking
  
  clocking cb_r_mon @(posedge rclk or negedge rrst_n);
    default input #0 output #0;
    input rinc, rdata, rempty;
  endclocking

  	modport WRITE_DRV  (clocking cb_w_drv);
    modport WRITE_MON  (clocking cb_w_mon);
    modport READ_DRV   (clocking cb_r_drv);
    modport READ_MON   (clocking cb_r_mon);


		property wrst_check;
       @(posedge wclk) (!wrst_n) |-> !wfull;
  endproperty

  property write_unknown;
        @(posedge wclk) disable iff(!wrst_n)
        (winc) |->!$isunknown(wdata);
  endproperty

  assert property (wrst_check)
         else $info("wrst_check FAILED: wfull is not 0 when wrst = 0");

  assert property(write_unknown)
         else $info("write_unknown FAILED: wdata is X/Z on valid write!");



	property rrst_check;
      @(posedge rclk) (!rrst_n) |-> (rempty && !rdata);
   endproperty

   property read_unknown;
      @(posedge rclk) disable iff(!rrst_n)
         (rinc && !rempty) |-> !$isunknown(rdata);
   endproperty

   assert property (rrst_check)
          else $info("rrst_check FAILED: rempty != 1 or rdata != 0 when rrst = 0");

   assert property(read_unknown)
          else $info("read_unknown FAILED: rdata is X/Z on valid read!");
	
endinterface

