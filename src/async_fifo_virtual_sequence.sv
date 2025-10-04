class async_fifo_virtual_sequence extends uvm_sequence #(uvm_sequence_item);

  `uvm_object_utils(async_fifo_virtual_sequence)


  `uvm_declare_p_sequencer(async_fifo_virtual_sequencer)

  function new(string name = "async_fifo_virtual_sequence");
    super.new(name);
  endfunction

  task body();
    async_fifo_write_sequence wseq;
    async_fifo_read_sequence  rseq;

    wseq = async_fifo_write_sequence::type_id::create("wseq");
    rseq = async_fifo_read_sequence::type_id::create("rseq");

    fork
      wseq.start(p_sequencer.write_seqr);
      rseq.start(p_sequencer.read_seqr);
    join
  endtask

endclass

