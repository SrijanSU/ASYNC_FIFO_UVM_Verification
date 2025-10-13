//============================================================
// Project      : Asynchronous FIFO Verification
// File Name    : fifo_top.sv
// Description  : Top-level testbench module connecting DUT,
//                interface, and UVM environment. Responsible
//                for clock and reset generation, interface
//                instantiation, DUT connection, and starting
//                the UVM test.
// Author       : Srijan S Uppoor
//============================================================

`include "uvm_pkg.sv"
`include "uvm_macros.svh"
`include "async_fifo_pkg.sv"
`include "fifo_if.sv"
`include "design.sv"

module fifo_top;

  // --------------------------------------------------------
  // Package Imports
  // --------------------------------------------------------
  import uvm_pkg::*;  
  import fifo_pkg::*;

  // --------------------------------------------------------
  // Signal Declarations
  // --------------------------------------------------------
  bit wclk;
  bit rclk;
  bit rrst_n;
  bit wrst_n;

  // --------------------------------------------------------
  // Clock Generation
  // --------------------------------------------------------
  always #`WRITE_CLK wclk = ~wclk;
  always #`READ_CLK rclk = ~rclk;

  // --------------------------------------------------------
  // Reset Generation
  // --------------------------------------------------------
  initial begin 
    wclk = 0;
    rclk = 0;
    rrst_n = 0;
    wrst_n = 0;
    
    #10 rrst_n = 1;
    wrst_n = 1;
  end
  
  // --------------------------------------------------------
  // Interface Instantiation
  // --------------------------------------------------------
  fifo_if intf(wclk,rclk,wrst_n,rrst_n);

  // --------------------------------------------------------
  // DUT Instantiation
  // --------------------------------------------------------
  FIFO dut( .rdata(intf.rdata),
           .wfull(intf.wfull),
           .rempty(intf.rempty),
           .wdata(intf.wdata),
           .winc(intf.winc),
           .wclk(wclk),
           .wrst_n(wrst_n),
           .rinc(intf.rinc),
           .rclk(rclk),
           .rrst_n(rrst_n));

  // --------------------------------------------------------
  // Testbench Configuration
  // --------------------------------------------------------
  initial begin 
    uvm_config_db #(virtual fifo_if)::set(null,"*","vif",intf);
    $dumpfile("wave.vcd");
    $dumpvars;
  end

  // --------------------------------------------------------
  // Start UVM Test
  // --------------------------------------------------------
  initial begin 
    run_test("async_fifo_test");
    #100000 $finish;
  end
endmodule
