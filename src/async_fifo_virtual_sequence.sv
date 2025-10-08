class async_fifo_virtual_sequence extends uvm_sequence #(uvm_sequence_item);

  `uvm_object_utils(async_fifo_virtual_sequence)
  `uvm_declare_p_sequencer(async_fifo_virtual_sequencer)
  
  async_fifo_write_sequencer write_seqr;
  async_fifo_read_sequencer read_seqr;
  
  async_fifo_write_sequence  wr_seq;
  wr_sequence1 wr_seq1;
  wr_sequence2 wr_seq2;
  
  async_fifo_read_sequence rd_seq;
  rd_sequence1 rd_seq1;
  rd_sequence2 rd_seq2;

  function new(string name = "async_fifo_virtual_sequence");
    super.new(name);
  endfunction

  task body();
    wr_seq = async_fifo_write_sequence::type_id::create("wr_seq");
    rd_seq = async_fifo_read_sequence::type_id::create("rd_seq");
    
    wr_seq1 = wr_sequence1::type_id::create("wr_seq1");
    wr_seq2 = wr_sequence2::type_id::create("wr_seq2");
    
    rd_seq1 = rd_sequence1::type_id::create("rd_seq1");
    rd_seq2 = rd_sequence2::type_id::create("rd_seq2");
   
	 fork 
      wr_seq.start(p_sequencer.write_seqr);
      rd_seq.start(p_sequencer.read_seqr);
    
    join
    
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
        wr_seq2.start(p_sequencer.write_seqr);
     begin
        rd_seq1.start(p_sequencer.read_seqr);
        #1;
     end
   join*/
    
  endtask

endclass

