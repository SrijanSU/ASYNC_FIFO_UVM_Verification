//============================================================
// Project      : Asynchronous FIFO Verification
// File Name    : async_fifo_virtual_sequence.sv
// Description  : Virtual sequence to coordinate execution of 
//                read and write sequences through the virtual 
//                sequencer in the Asynchronous FIFO environment.
// Author       : Srijan S Uppoor
//============================================================

class async_fifo_virtual_sequence extends uvm_sequence #(uvm_sequence_item);

  `uvm_object_utils(async_fifo_virtual_sequence)			//Register with factory
	
  `uvm_declare_p_sequencer(async_fifo_virtual_sequencer)	// p-sequencer declaration

  // --------------------------------------------------------
  // Handles to sequencers
  // --------------------------------------------------------
  async_fifo_write_sequencer write_seqr;		// Write-side sequencer handle
  async_fifo_read_sequencer read_seqr;			// Read-side sequencer handle

  // --------------------------------------------------------
  // Handles to write and read sequences
  // --------------------------------------------------------
  async_fifo_write_sequence  wr_seq;		// Default write sequence
  wr_sequence1 wr_seq1;						// Custom write sequence 1
  wr_sequence2 wr_seq2;						// Custom write sequence 2
  
  async_fifo_read_sequence rd_seq;			// Default read sequence
  rd_sequence1 rd_seq1;						// Custom read sequence 1
  rd_sequence2 rd_seq2;						// Custom read sequence 2

  // --------------------------------------------------------
  // Constructor
  // --------------------------------------------------------
  function new(string name = "async_fifo_virtual_sequence");
    super.new(name);
  endfunction

  // --------------------------------------------------------
  // body : Main task controlling sequence execution
  // --------------------------------------------------------
  task body();
	// Create instances of all sequences
    wr_seq = async_fifo_write_sequence::type_id::create("wr_seq");
    rd_seq = async_fifo_read_sequence::type_id::create("rd_seq");
    
    wr_seq1 = wr_sequence1::type_id::create("wr_seq1");
    wr_seq2 = wr_sequence2::type_id::create("wr_seq2");
    
    rd_seq1 = rd_sequence1::type_id::create("rd_seq1");
    rd_seq2 = rd_sequence2::type_id::create("rd_seq2");

    // ------------------------------------------------------
    // Parallel execution of write and read sequences
    // ------------------------------------------------------
	 fork 
      wr_seq.start(p_sequencer.write_seqr);
      rd_seq.start(p_sequencer.read_seqr); 
    join

    // ------------------------------------------------------
    // Optional: Uncomment to test custom read/write sequences
    // ------------------------------------------------------
    /*fork
      begin
        $display("1");
        wr_seq1.start(p_sequencer.write_seqr);
        #1;
      end
      begin
        rd_seq1.start(p_sequencer.read_seqr);
        #1;
      end
    join*/
    
  /*  fork
      begin
        $display("3");
        wr_seq1.start(p_sequencer.write_seqr);
        #1;
      end
        rd_seq2.start(p_sequencer.read_seqr);
    join*/
/*    fork   
      $display("4");
    join
    
    fork   
        $display("4");
        wr_seq2.start(p_sequencer.write_seqr);
     begin
        rd_seq1.start(p_sequencer.read_seqr);
        #1;
     end
   join*/
    
  endtask:body

endclass:async_fifo_virtual_sequence

