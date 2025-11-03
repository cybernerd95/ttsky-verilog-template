import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer


def encode_ieee(data: int) -> int:
    encoded = 0
    for i in range(8):
        bit = (data >> (7 - i)) & 1
        encoded = (encoded << 2) | (0b10 if bit else 0b01)
    return encoded


def encode_thomas(data: int) -> int:
    encoded = 0
    for i in range(8):
        bit = (data >> (7 - i)) & 1
        encoded = (encoded << 2) | (0b01 if bit else 0b10)
    return encoded


@cocotb.test()
async def test_project(dut):
    """Test tt_um_xyz_manchester Manchester encoder."""

    dut._log.info("🔧 Starting test for tt_um_xyz_manchester")

    # Start clock (10ns period)
    clock = Clock(dut.clk, 10, unit="ns")
    cocotb.start_soon(clock.start())

    # Reset DUT if available
    if hasattr(dut, "rst_n"):
        dut.rst_n.value = 0
        await Timer(100, unit="ns")
        dut.rst_n.value = 1
        await RisingEdge(dut.clk)

    # Let DUT settle (important for gate-level)
    await Timer(200, unit="ns")

    for mode in [0, 1]:  # 0 = IEEE, 1 = Thomas
        data_in = 0b10110010
        dut.ui_in.value = data_in
        dut.uio_in.value = mode

        dut._log.info(f"Testing mode={mode}, data_in={data_in:08b}")

        # Wait for output to propagate (GL sims are slower)
        await RisingEdge(dut.clk)
        await Timer(200, unit="ns")

        # Safely convert outputs (replace X/Z)
        uo_val_str = str(dut.uo_out.value)
        uio_val_str = str(dut.uio_out.value)
        uo_val = int(uo_val_str.replace("x", "0").replace("z", "0"), 2)
        uio_val = int(uio_val_str.replace("x", "0").replace("z", "0"), 2)
        encoded_out = (uo_val << 8) | uio_val

        expected = encode_ieee(data_in) if mode == 0 else encode_thomas(data_in)

        dut._log.info(f"DUT={encoded_out:016b}, EXPECTED={expected:016b}")

        assert encoded_out == expected, (
            f"❌ Mismatch: mode={mode}, data={data_in:08b}, "
            f"expected={expected:016b}, got={encoded_out:016b}"
        )

    dut._log.info("✅ All tests passed for both IEEE and Thomas encodings.")
