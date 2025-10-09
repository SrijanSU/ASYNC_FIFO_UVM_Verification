onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /fifo_top/dut/wclk
add wave -noupdate -radix unsigned /fifo_top/dut/rclk
add wave -noupdate -radix unsigned /fifo_top/dut/rdata
add wave -noupdate -radix unsigned /fifo_top/dut/wdata
add wave -noupdate -radix unsigned /fifo_top/dut/wptr
add wave -noupdate -radix unsigned /fifo_top/dut/wrst_n
add wave -noupdate -radix unsigned /fifo_top/dut/wq2_rptr
add wave -noupdate -radix unsigned /fifo_top/dut/winc
add wave -noupdate -radix unsigned /fifo_top/dut/wfull
add wave -noupdate -radix unsigned /fifo_top/dut/waddr
add wave -noupdate -radix unsigned /fifo_top/dut/rrst_n
add wave -noupdate -radix unsigned /fifo_top/dut/rq2_wptr
add wave -noupdate -radix unsigned /fifo_top/dut/rptr
add wave -noupdate -radix unsigned /fifo_top/dut/rinc
add wave -noupdate -radix unsigned /fifo_top/dut/rempty
add wave -noupdate -radix unsigned /fifo_top/dut/raddr
add wave -noupdate -radix unsigned /fifo_top/dut/DSIZE
add wave -noupdate -radix unsigned /fifo_top/dut/ASIZE
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {225 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 234
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {62 ns}
