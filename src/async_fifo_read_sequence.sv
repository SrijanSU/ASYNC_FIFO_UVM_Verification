class async_fifo_read_sequence extends uvm_sequence#(async_fifo_read_item);

    `uvm_object_utils(async_fifo_read_sequence)

    function new(string name = "async_fifo_read_sequence");
        super.new(name);
    endfunction:new

    task body();
        req = async_fifo_read_item::type_id::create("req");
        `uvm_rand_send_with(req, {rinc == 1;})
    endtask:body
  
endclass:async_fifo_read_sequence


class rd_sequence1 extends async_fifo_read_sequence;

    `uvm_object_utils(rd_sequence1)

    function new(string name = "rd_sequence1");
        super.new(name);
    endfunction:new

    virtual task body();
        req = async_fifo_read_item::type_id::create("req");
        `uvm_rand_send_with(req, {rinc == 1;})
    endtask:body

endclass:rd_sequence1


class rd_sequence2 extends async_fifo_read_sequence;

    `uvm_object_utils(rd_sequence2)

    function new(string name = "rd_sequence2");
        super.new(name);
    endfunction:new

    virtual task body();
        req = async_fifo_read_item::type_id::create("req");
        `uvm_rand_send_with(req, {rinc == 0;})
    endtask:body

endclass:rd_sequence2
