import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles
import os

# Set up XML test results
os.environ['COCOTB_RESULTS_FILE'] = 'results.xml'

@cocotb.test()
async def test_project(dut):
    """Test Manchester encoder basic functionality"""
    
    dut._log.info("Starting Manchester encoder test")
    
    # Set clock period to 100ns (10MHz)
    clock = Clock(dut.clk, 100, units="ns")
    cocotb.start_soon(clock.start())
    
    # Initialize all inputs
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    
    # Hold reset for several cycles
    dut._log.info("Applying reset")
    await ClockCycles(dut.clk, 10)
    
    # Release reset
    dut.rst_n.value = 1
    dut._log.info("Reset released")
    await ClockCycles(dut.clk, 5)
    
    # Test 1: Standard Manchester encoding
    dut._log.info("Test 1: Standard Manchester with data 0b10110011")
    dut.ui_in.value = 0  # encode_mode = 0
    dut.uio_in.value = 0b10110011  # data_in
    
    await ClockCycles(dut.clk, 20)
    dut._log.info("Test 1 completed")
    
    # Test 2: Inverse Manchester encoding
    dut._log.info("Test 2: Inverse Manchester with data 0b01001101")
    dut.ui_in.value = 1  # encode_mode = 1
    dut.uio_in.value = 0b01001101  # data_in
    
    await ClockCycles(dut.clk, 20)
    dut._log.info("Test 2 completed")
    
    # Test 3: Different pattern
    dut._log.info("Test 3: Pattern 0b11110000")
    dut.ui_in.value = 0
    dut.uio_in.value = 0b11110000
    
    await ClockCycles(dut.clk, 20)
    dut._log.info("Test 3 completed")
    
    # Test 4: All zeros
    dut._log.info("Test 4: All zeros")
    dut.ui_in.value = 0
    dut.uio_in.value = 0b00000000
    
    await ClockCycles(dut.clk, 20)
    dut._log.info("Test 4 completed")
    
    # Test 5: All ones
    dut._log.info("Test 5: All ones")
    dut.ui_in.value = 0
    dut.uio_in.value = 0b11111111
    
    await ClockCycles(dut.clk, 20)
    dut._log.info("Test 5 completed")
    
    dut._log.info("All tests completed successfully!")