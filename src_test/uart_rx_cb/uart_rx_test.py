import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ClockCycles

CLOCK_MULTIPLE = 4


async def transmit(dut, byte):
    dut.uart_in <= 0
    await ClockCycles(dut.uart_clk, CLOCK_MULTIPLE)

    for i in range(8):
        bit = (byte >> i) & 1
        print("sending {} for bit {}".format(bit, i))
        dut.uart_in <= bit
        await ClockCycles(dut.uart_clk, CLOCK_MULTIPLE)

    dut.uart_in <= 1

@cocotb.test()
async def test_uart_transmit(dut):

    clock = Clock(dut.uart_clk, 10, units="ns")
    cocotb.fork(clock.start())
    
    byte = int('0x55', 16)     
    
    dut.uart_in <= 1
    await ClockCycles(dut.uart_clk, 10)
    await transmit(dut, byte)
    
    val = dut.data.value
    print("got output value {}".format(val))
    assert int(val, 2) == byte, "test failed"
