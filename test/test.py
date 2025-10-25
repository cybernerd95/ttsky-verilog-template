import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_project(dut):
    """Test Manchester encoder basic functionality"""
    
    dut._log.info("Starting Manchester encoder test")
    
    # Set clock period to 100ns (10MHz)
    clock = Clock(dut.clk, 100, units="ns")
    cocotb.start_soon(clock.start())
    
    # Reset the design
    dut._log.info("Applying reset")
    dut.ena.value = 1
    dut.rst_n.value = 0
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 1)
    
    # Test 1: Standard Manchester encoding (encode_mode = 0)
    dut._log.info("Test 1: Standard Manchester with data 0b10110011")
    dut.ui_in.value = 0  # encode_mode = 0
    dut.uio_in.value = 0b10110011  # data_in
    
    # Run for enough cycles to see output
    await ClockCycles(dut.clk, 20)
    
    # Test 2: Inverse Manchester encoding (encode_mode = 1)
    dut._log.info("Test 2: Inverse Manchester with data 0b01001101")
    dut.ui_in.value = 1  # encode_mode = 1
    dut.uio_in.value = 0b01001101  # data_in
    
    await ClockCycles(dut.clk, 20)
    
    # Test 3: Different data pattern
    dut._log.info("Test 3: Pattern 0b11110000")
    dut.ui_in.value = 0
    dut.uio_in.value = 0b11110000
    
    await ClockCycles(dut.clk, 20)
    
    # Test 4: All zeros
    dut._log.info("Test 4: All zeros")
    dut.ui_in.value = 0
    dut.uio_in.value = 0b00000000
    
    await ClockCycles(dut.clk, 20)
    
    # Test 5: All ones
    dut._log.info("Test 5: All ones")
    dut.ui_in.value = 0
    dut.uio_in.value = 0b11111111
    
    await ClockCycles(dut.clk, 20)
    
    dut._log.info("All tests completed successfully!")