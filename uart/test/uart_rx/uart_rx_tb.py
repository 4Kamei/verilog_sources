import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ClockCycles, Timer

CLOCK_FREQUENCY = 20000
BAUD_RATE = 4000

class TB():

    def __init__(self, dut, clock_freq, baud_rate):
        self.dut = dut
        self.baud_rate = baud_rate
        self.clock_freq = clock_freq
    
    def start(self):

        clock_period = int(0.5 * 10 ** 12/self.clock_freq) #picos
        print("clock period is {}".format(clock_period))
        clock = Clock(self.dut.i_uart_clk, 2*clock_period, "ps")
        cocotb.fork(clock.start())

    async def reset(self):
        self.dut.i_uart_in <= 1
        await ClockCycles(self.dut.i_uart_clk, 1)
        self.dut.i_reset <= 1
        await ClockCycles(self.dut.i_uart_clk, 1)
        self.dut.i_reset <= 0

    async def wait_clock(self):
        await Timer(10 ** 9/self.baud_rate, "ns")

    async def transmit(self, byte):
    
        self.dut.i_uart_in <= 0

        await self.wait_clock()

        for i in range(8):
            bit = (byte >> i) & 1
            self.dut.i_uart_in <= bit
            await self.wait_clock()

        self.dut.i_uart_in <= 1
    
    async def verify_receive(self, byte):
        await RisingEdge(self.dut.o_data_out_strobe)
        data = self.dut.o_data
        assert data == byte, f"read data {data}, and send data {byte} don't match"

    async def write_verify(self, byte):
        await self.transmit(byte)
        await self.verify_receive(byte)

@cocotb.test()


async def test_uart_receive(device):
    dut = TB(device, CLOCK_FREQUENCY, BAUD_RATE)    
    dut.start()
    await dut.reset()
    for i in range(256):
        await dut.write_verify(i)
    
