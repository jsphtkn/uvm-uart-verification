# Makefile for Siemens Questa Sim (ModelSim)

# For the first time to create library, run:
# 	> make compile

# For standart runs:
# 	> make run
#   > make gui
#   > make clean
# 	> make test_9600
# 	> make test_19200
# 	> make test_57600
# 	> make test_115200
# 	> make regression

# ---------------------------------------------------------------------
# DIRECTORIES
# ---------------------------------------------------------------------
ROOT_DIR  = ..
RTL_DIR   = $(ROOT_DIR)/rtl
TB_DIR    = $(ROOT_DIR)/tb
UVM_DIR   = $(TB_DIR)/uvm
TOP_DIR   = $(TB_DIR)/top

# ---------------------------------------------------------------------
# FILES
# ---------------------------------------------------------------------
# RTL Files
RTL_SRC   = $(RTL_DIR)/uart_tx.v \
            $(RTL_DIR)/uart_rx.v \
            $(RTL_DIR)/uart_top.sv

# TB Files (Interface -> Package -> Top)
TB_SRC    = $(TOP_DIR)/uart_if.sv \
            $(UVM_DIR)/uart_pkg.sv \
            $(TOP_DIR)/tb_top.sv

# ---------------------------------------------------------------------
# COMPILATION FLAGS
# ---------------------------------------------------------------------
# -sv: Enable SystemVerilog
# +incdir: Where to find included files
# -timescale: Prevent timescale mismatches
VLOG_FLAGS = -sv \
             +incdir+$(UVM_DIR) \
             +incdir+$(RTL_DIR) \
             -timescale 1ns/1ps \
             -suppress 2181 \
             -work work

# ---------------------------------------------------------------------
# SIMULATION FLAGS
# ---------------------------------------------------------------------
# -c: Console mode (no GUI)
# -voptargs=+acc: Enable visibility for waveforms
# -do "run -all; quit": Run until $finish
VSIM_FLAGS = -voptargs=+acc -c -do "run -all; exit"

# ---------------------------------------------------------------------
# STANDARD TARGETS
# ---------------------------------------------------------------------
all: clean compile run

lib:
	vlib work

compile: lib
	vlog $(VLOG_FLAGS) $(RTL_SRC) $(TB_SRC)

# Default Run (115200 Baud / 868 Clocks)
run:
	vsim $(VSIM_FLAGS) work.tb_top -GCLKS_PER_BIT=868 -l run.log

# GUI Mode
gui:
	vsim -voptargs=+acc work.tb_top -GCLKS_PER_BIT=868

# ---------------------------------------------------------------------
# BAUD RATE TESTS
# ---------------------------------------------------------------------

test_9600:
	vsim $(VSIM_FLAGS) work.tb_top -GCLKS_PER_BIT=10417 -l log_9600.log

test_19200:
	vsim $(VSIM_FLAGS) work.tb_top -GCLKS_PER_BIT=5208 -l log_19200.log

test_57600:
	vsim $(VSIM_FLAGS) work.tb_top -GCLKS_PER_BIT=1736 -l log_57600.log

test_115200:
	vsim $(VSIM_FLAGS) work.tb_top -GCLKS_PER_BIT=868 -l log_115200.log

# ---------------------------------------------------------------------
# REGRESSION
# ---------------------------------------------------------------------
regression: clean compile test_115200 test_57600 test_19200 test_9600
	@echo "---------------------------------------------------"
	@echo "REGRESSION COMPLETE. Checking for PASS..."
	@grep "PASS" log_*.log
	@echo "---------------------------------------------------"

# ---------------------------------------------------------------------
# CLEANUP
# ---------------------------------------------------------------------
clean:
	rm -rf work transcript vsim.wlf log_*.log run.log *.log