include "defines.sv"

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
  
  clocking cb_r_mon @(posedge wclk or negedge wrst_n);
    default input #0 output #0;
    input rinc, rdata, rempty;
  endclocking

  	modport WRITE_DRV  (clocking cb_w_drv);
    modport WRITE_MON  (clocking cb_w_mon);
    modport READ_DRV   (clocking cb_r_drv);
    modport READ_MON   (clocking cb_r_mon);
	
endinterface

