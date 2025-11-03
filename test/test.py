# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    """Test tt_um_xyz_manchester Manchester encoder."""

    dut._log.info("🔧 Starting test for tt_um_xyz_manchester")

    # Start clock
    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    # Reset and enable
    dut.rst_n.value = 0
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 1)

    # (mode, data) test vectors
    test_vectors = [
        (0, 0b10110010),
        (1, 0b10110010),
        (0, 0b11110000),
        (1, 0b11110000),
        (0, 0b00001111),
        (1, 0b00001111),
    ]

    for mode, data_in in test_vectors:
        dut._log.info(f"Testing mode={mode}, data_in={data_in:08b}")

        dut.ui_in.value = data_in
        dut.uio_in.value = mode
        await ClockCycles(dut.clk, 2)

        encoded_out = (dut.uo_out.value.integer << 8) | dut.uio_out.value.integer

        ieee = encode_ieee(data_in)
        thomas = encode_thomas(data_in)
        expected = ieee if mode == 0 else thomas

        dut._log.info(f"DUT={encoded_out:016b}, EXPECTED={expected:016b}")
        assert encoded_out == expected, (
            f"❌ Mismatch: mode={mode}, data={data_in:08b}, "
            f"expected={expected:016b}, got={encoded_out:016b}"
        )

    dut._log.info("✅ All Manchester encoding tests passed successfully!")


def encode_ieee(data):
    """IEEE Manchester encoding: 1 → 10, 0 → 01"""
    out = 0
    for i in range(8):
        bit = (data >> (7 - i)) & 1
        pair = 0b10 if bit else 0b01
        out = (out << 2) | pair
    return out


def encode_thomas(data):
    """Thomas Manchester encoding: 1 → 01, 0 → 10"""
    out = 0
    for i in range(8):
        bit = (data >> (7 - i)) & 1
        pair = 0b01 if bit else 0b10
        out = (out << 2) | pair
    return out
