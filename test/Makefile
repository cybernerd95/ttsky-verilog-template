# Makefile for cocotb simulation
# Compatible with Tiny Tapeout tt-sky130 template

# Simulator and language
SIM ?= icarus
TOPLEVEL_LANG ?= verilog

# Directories
SRC_DIR = $(PWD)/../src

# Project source files
PROJECT_SOURCES = project.v manchester.v

# Build directory for simulation
SIM_BUILD = sim_build/rtl

# Verilog source list
VERILOG_SOURCES += $(addprefix $(SRC_DIR)/, $(PROJECT_SOURCES))

# Include path for shared definitions
COMPILE_ARGS += -I$(SRC_DIR)

# Top-level DUT (must match your Tiny Tapeout module)
TOPLEVEL = tt_um_xyz_manchester

# Python testbench
COCOTB_TEST_MODULES = test

# Disable VPI optimization for CI stability
EXTRA_ARGS += -Wall -Wno-timescale

# Rule for building simulation
all: sim

# Run RTL simulation
sim:
	@echo "Running cocotb test for $(TOPLEVEL)..."
	$(MAKE) -f $(shell cocotb-config --makefiles)/Makefile.sim SIM=$(SIM) TOPLEVEL=$(TOPLEVEL) \
		VERILOG_SOURCES="$(VERILOG_SOURCES)" SIM_BUILD=$(SIM_BUILD) \
		COCOTB_TEST_MODULES=$(COCOTB_TEST_MODULES) COMPILE_ARGS="$(COMPILE_ARGS)" EXTRA_ARGS="$(EXTRA_ARGS)"

clean:
	rm -rf sim_build results.xml __pycache__
