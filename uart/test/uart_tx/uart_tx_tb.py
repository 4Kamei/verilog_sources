import cocotb
import random as r
from cocotbext.uart import UartSink
from cocotb.clock import Clock
from cocotb.triggers import FallingEdge, RisingEdge, ClockCycles, Timer

CLOCK_FREQUENCY = 12_000_000

class TB():

    def __init__(self, dut, clock_freq):
        self.dut = dut
        self.clock_freq = clock_freq
        self.uart_sink = UartSink(dut.uart_out, baud=115200, bits=8)

    def start(self):
        clock_period = int(0.5 * 10 ** 12/self.clock_freq) #picos
        print("clock period is {}".format(clock_period))
        clock = Clock(self.dut.clk, 2*clock_period, "ps")
        cocotb.fork(clock.start())

    async def reset(self):
        self.dut.transmit <= 0
        await ClockCycles(self.dut.clk, 1)
        self.dut.reset <= 1
        await ClockCycles(self.dut.clk, 1)
        self.dut.reset <= 0

    async def transmit(self, byte):
        if(self.dut.transmit_ready == 0):
            await RisingEdge(self.dut.transmit_ready)
        await ClockCycles(self.dut.clk, 1)

        self.dut.out_data <= byte
        self.dut.transmit <= 1

        await ClockCycles(self.dut.clk, 2)
        
        self.dut.transmit <= 0        
        
        await ClockCycles(self.dut.clk, 10)

    async def receive(self):
        await self.uart_sink.wait()
        data = await self.uart_sink.read()
        return data

    async def verify(self, byte):
        await self.transmit(byte)
        byte_in = await self.receive()

        assert byte == int.from_bytes(byte_in, byteorder='big')

@cocotb.test()
async def test_uart_transmit(device):
    dut = TB(device, CLOCK_FREQUENCY)    
    dut.start()
    await dut.reset()
    
    await dut.verify(0)
    await dut.verify(255)

    for i in range(30):
        value = r.randint(0, 255)
        await dut.verify(value)
