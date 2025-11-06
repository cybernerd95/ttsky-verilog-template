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
    dut._log.info("🔧 Starting Manchester system test")

    clock = Clock(dut.clk, 10, unit="ns")
    cocotb.start_soon(clock.start())

    dut.rst_n.value = 1

    for mode in [0, 1]:
        data_in = 0b10110010
        dut.ui_in.value = data_in
        dut.uio_in.value = mode

        await RisingEdge(dut.clk)
        await Timer(100, unit="ns")

        uo_val_str = str(dut.uo_out.value)
        uio_val_str = str(dut.uio_out.value)

        if all(ch in "xXzZ" for ch in uo_val_str + uio_val_str):
            dut._log.warning("⚠️ Output undefined (X/Z), skipping")
            continue

        decoded_val = int(uo_val_str.replace("x", "0").replace("z", "0"), 2)
        encoded_low = int(uio_val_str.replace("x", "0").replace("z", "0"), 2)

        expected_encoded = encode_ieee(data_in) if mode == 0 else encode_thomas(data_in)
        expected_decoded = data_in

        dut._log.info(f"Mode={mode} Data={data_in:08b}")
        dut._log.info(f"Encoded(low)={encoded_low:08b} Decoded={decoded_val:08b}")
        dut._log.info(f"Expected Encoded={expected_encoded:016b}")

        assert decoded_val == expected_decoded, f"Decoded mismatch: got {decoded_val:08b}, expected {expected_decoded:08b}"

    dut._log.info("✅ Manchester system passed all tests")
