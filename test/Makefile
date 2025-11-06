# Makefile for Tiny Tapeout Cocotb Simulation
# SPDX-License-Identifier: Apache-2.0

# ============================================================================
# User configuration
# ============================================================================

# Simulator (Icarus is default for Tiny Tapeout CI)
SIM ?= icarus
COMPILE_ARGS += -g2012 -Wall -Wtimescale
TOPLEVEL_LANG ?= verilog

# Directories
SRC_DIR        := $(PWD)/../src
SIM_BUILD      := sim_build/rtl

# Your project source files (relative to src/)
PROJECT_SOURCES := project.v manchester.v

# Include path
COMPILE_ARGS   += -I$(SRC_DIR)

# Top-level module (the DUT)
TOPLEVEL       := tt_um_xyz_manchester

# Python testbench
COCOTB_TEST_MODULES := test

# ============================================================================
# Conditional gate-level support (optional)
# ============================================================================

ifneq ($(GATES),yes)

# RTL simulation sources
VERILOG_SOURCES += $(addprefix $(SRC_DIR)/,$(PROJECT_SOURCES))

else

# Gate-level simulation mode
SIM_BUILD       := sim_build/gl
COMPILE_ARGS    += -DGL_TEST -DFUNCTIONAL -DUSE_POWER_PINS -DSIM -DUNIT_DELAY=\#1

VERILOG_SOURCES += $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/primitives.v
VERILOG_SOURCES += $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v
VERILOG_SOURCES += $(PWD)/gate_level_netlist.v

endif

# ============================================================================
# Rules
# ============================================================================

# Default target
all: sim

# RTL Simulation rule
sim:
	@echo ""
	@echo "🚀 Running Cocotb test for module: $(TOPLEVEL)"
	@echo "📂 Sources: $(PROJECT_SOURCES)"
	@echo ""
	$(MAKE) -f $(shell cocotb-config --makefiles)/Makefile.sim \
		SIM=$(SIM) TOPLEVEL_LANG=$(TOPLEVEL_LANG) \
		TOPLEVEL=$(TOPLEVEL) SIM_BUILD=$(SIM_BUILD) \
		VERILOG_SOURCES="$(VERILOG_SOURCES)" \
		COCOTB_TEST_MODULES="$(COCOTB_TEST_MODULES)" \
		COMPILE_ARGS="$(COMPILE_ARGS)"

# Clean generated files
clean:
	rm -rf sim_build results.xml __pycache__

# ============================================================================
# Debug helpers
# ============================================================================

print-vars:
	@echo "TOPLEVEL          = $(TOPLEVEL)"
	@echo "SIM_BUILD         = $(SIM_BUILD)"
	@echo "SRC_DIR           = $(SRC_DIR)"
	@echo "PROJECT_SOURCES   = $(PROJECT_SOURCES)"
	@echo "VERILOG_SOURCES   = $(VERILOG_SOURCES)"
	@echo "COCOTB_TEST_MODULES = $(COCOTB_TEST_MODULES)"
	@echo "COMPILE_ARGS      = $(COMPILE_ARGS)"
