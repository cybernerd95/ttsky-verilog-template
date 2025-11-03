# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

# Makefile
# See https://docs.cocotb.org/en/stable/quickstart.html for more info

# defaults
SIM ?= icarus
TOPLEVEL_LANG ?= verilog
SRC_DIR = $(PWD)/../src
PROJECT_SOURCES = tt_um_xyz_manchester.v manchester.v

# Note: PROJECT_SOURCES lists your design files in ../src/
# tb.v is your testbench wrapper and stays in the test/ directory

ifneq ($(GATES),yes)

# RTL simulation
SIM_BUILD = sim_build/rtl
VERILOG_SOURCES += $(addprefix $(SRC_DIR)/,$(PROJECT_SOURCES))

else

# Gate-level simulation
SIM_BUILD = sim_build/gl
COMPILE_ARGS += -DGL_TEST
COMPILE_ARGS += -DFUNCTIONAL
COMPILE_ARGS += -DUSE_POWER_PINS
COMPILE_ARGS += -DSIM
COMPILE_ARGS += -DUNIT_DELAY=\#1
VERILOG_SOURCES += $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/primitives.v
VERILOG_SOURCES += $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v

# This file gets copied by the GDS workflow
VERILOG_SOURCES += $(PWD)/gate_level_netlist.v

endif

# Allow sharing configuration between design and testbench via include
COMPILE_ARGS += -I$(SRC_DIR)

# Include the testbench sources
VERILOG_SOURCES += $(PWD)/tb.v
TOPLEVEL = tb

# List test modules to run (Python files without .py)
COCOTB_TEST_MODULES = test

# Cocotb results path for CI test summary
COCOTB_RESULTS_DIR = $(PWD)/test
COCOTB_RESULTS_FILE = $(COCOTB_RESULTS_DIR)/results.xml
export COCOTB_RESULTS_FILE

# Ensure results directory exists before simulation
all: prep sim

prep:
	mkdir -p $(COCOTB_RESULTS_DIR)

# Include cocotb make rules for simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim
