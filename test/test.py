import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer


def encode_ieee(data: int) -> int:
    """IEEE Manchester: 1 -> 10, 0 -> 01"""
    encoded = 0
    for i in range(8):
        bit = (data >> (7 - i)) & 1
        encoded = (encoded << 2) | (0b10 if bit else 0b01)
    return encoded


def encode_thomas(data: int) -> int:
    """Thomas Manchester: 1 -> 01, 0 -> 10"""
    encoded = 0
    for i in range(8):
        bit = (data >> (7 - i)) & 1
        encoded = (encoded << 2) | (0b01 if bit else 0b10)
    return encoded


@cocotb.test()
async def test_project(dut):
    """Test tt_um_xyz_manchester Manchester encoder."""

    dut._log.info("🔧 Starting test for tt_um_xyz_manchester")

    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    # Reset DUT
    dut.rst_n.value = 0
    await Timer(20, units="ns")
    dut.rst_n.value = 1
    await RisingEdge(dut.clk)

    for mode in [0, 1]:  # 0 = IEEE, 1 = Thomas
        data_in = 0b10110010
        dut.ui_in.value = data_in
        dut.uio_in.value = mode

        await RisingEdge(dut.clk)
        await Timer(20, units="ns")

        encoded_out = (dut.uo_out.value.integer << 8) | dut.uio_out.value.integer

        expected = encode_ieee(data_in) if mode == 0 else encode_thomas(data_in)
        dut._log.info(f"Testing mode={mode}, data_in={data_in:08b}")
        dut._log.info(f"DUT={encoded_out:016b}, EXPECTED={expected:016b}")

        assert encoded_out == expected, (
            f"❌ Mismatch: mode={mode}, data={data_in:08b}, "
            f"expected={expected:016b}, got={encoded_out:016b}"
        )

    dut._log.info("✅ All tests passed for both IEEE and Thomas encodings.")
