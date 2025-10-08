QUESTA := /home/share/questa.csh
SHELL := /bin/csh
TEST ?= async_fifo_test
V ?= UVM_DEBUG

.ONESHELL:	
all:
	source $(QUESTA)
	make clean
	make compile
	make simulate
	vcover report -html fifo_coverage.ucdb -htmldir covReport -details

clean:
	rm -rf work/ transcript vsim.wlf wave.vcd
	rm -rf covReport fifo_coverage.ucdb
	rm fifo.log simulation.log
	rm fifo_coverage.ucdb
	cleaBOSITY=<level>
	clear
	clear

compile:
	@echo "COMPILING CODE ......."
	source $(QUESTA)
	vlog -sv +acc +cover +fcover +define+UVM_NO_DPI  +define+WCLK=$(WCLK) +define+RCLK=$(RCLK) -l fifo.log testbench.sv  "+incdir+/tools/mentor/questasim_10.6c/questasim/uvm-1.1d/../verilog_src/uvm-1.1d/src"

wave:
	make compile
	vsim -novopt work.fifo_top +UVM_TESTNAME=$(TEST) +UVM_VERBOSITY=$(V)

simulate:
	@echo "SIMULATING CODE"
	vsim -vopt work.fifo_top -voptargs=+acc=npr -assertdebug -l simulation.log -coverage -c -do "coverage save -onexit -assert -directive -cvg -codeAll fifo_coverage.ucdb; run -all; exit" +UVM_TESTNAME=$(TEST) +UVM_VERBOSITY=$(V)

view:
	firefox ./covReport/index.html
