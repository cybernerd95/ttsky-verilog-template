<<<<<<< HEAD
## SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

=======
>>>>>>> 9bb86036635bd36d153be892ff2965545f2126ea
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles
import os

# Set up XML test results
os.environ['COCOTB_RESULTS_FILE'] = 'results.xml'

@cocotb.test()
async def test_project(dut):
<<<<<<< HEAD
    dut._log.info("Start Manchester encoder test")

    # Set clock to 10 µs period (100 kHz)
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Resetting DUT")
=======
    """Test Manchester encoder basic functionality"""
    
    dut._log.info("Starting Manchester encoder test")
    
    # Set clock period to 100ns (10MHz)
    clock = Clock(dut.clk, 100, units="ns")
    cocotb.start_soon(clock.start())
    
    # Initialize all inputs
>>>>>>> 9bb86036635bd36d153be892ff2965545f2126ea
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
<<<<<<< HEAD
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 5)

    dut._log.info("Beginning Manchester encoding tests")

    # Define (mode, data_in) test vectors
    test_vectors = [
        (0, 0b10110010),
        (1, 0b10110010),
        (0, 0b11110000),
        (1, 0b11110000),
        (0, 0b00001111),
        (1, 0b00001111),
    ]

    for mode, data_in in test_vectors:
        dut.uio_in.value = mode  # mode = LSB
        dut.ui_in.value = data_in
        await ClockCycles(dut.clk, 2)

        ieee_encoded = encode_ieee(data_in)
        thomas_encoded = encode_thomas(data_in)
        expected = ieee_encoded if mode == 0 else thomas_encoded

        encoded_out = (dut.uo_out.value.integer << 8) | dut.uio_out.value.integer

        dut._log.info(
            f"Mode={mode}, Data={data_in:08b}, Encoded={encoded_out:016b}, Expected={expected:016b}"
        )

        assert encoded_out == expected, (
            f"FAIL: Mode={mode}, Data={data_in:08b}, "
            f"Expected={expected:016b}, Got={encoded_out:016b}"
        )

    dut._log.info("✅ All test cases passed!")


def encode_ieee(data):
    """IEEE Manchester encoding."""
    out = 0
    for i in range(8):
        bit = (data >> (7 - i)) & 1
        pair = 0b10 if bit else 0b01
        out = (out << 2) | pair
    return out


def encode_thomas(data):
    """Thomas Manchester encoding."""
    out = 0
    for i in range(8):
        bit = (data >> (7 - i)) & 1
        pair = 0b01 if bit else 0b10
    return out
=======
    
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
>>>>>>> 9bb86036635bd36d153be892ff2965545f2126ea
