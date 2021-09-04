import cocotb
from bitarray import bitarray
from bitarray.util import ba2int
from cocotb.triggers import RisingEdge
from cocotb.clock import Clock

import random as r


class TB:
    
    def __init__(self, dut):
        self.dut = dut
    
    def start(self):
        cocotb.fork(Clock(self.dut.i_write_clk, 2, 'ns').start())
        cocotb.fork(Clock(self.dut.i_read_clk, 2, 'ns').start())

    async def reset(self):
        

    async def write_data(self, data):    

        bits = bitarray()
        bits.frombytes(bytes(data))
        i = 0
    
        while (i < bits.buffer_info()[1] * 8 / DATA_WIDTH):
            value = bits[i * DATA_WIDTH:(i + 1)*DATA_WIDTH]
           
            await RisingEdge(dut.write_clk)

            dut.write_en <= 1
            dut.i_data <= ba2int(value)
            i = i + 1

        dut.write_en <= 0        

    async def read_data(dut):
        await RisingEdge(dut.read_clk)
        dut.read_en <= 1
        bits = bitarray()
        await RisingEdeg(dut.has_data)
        while(dut.has_data == 1):
            bits.append(bitarray(dut.o_data))
            await RisingEdge(dut.read_clk)
        dut.read_en <= 0
        
        return bits.tobytes()
    

@cocotb.test()
async def test(dut):
    
    tb = TB(dut)

    tb.start()

    await tb.reset()

    r.seed(23489723)

    data_lengths = [r.randint(1, 1024) for i in range(num_test)]

    test_data = [r.randbytes(i) for i in data_lengths]

    for data in test_data:
        await tb.write_data(dut, data)
   
    #add a little bit of delay to make wave diagram easier to read
    await RisingEdge(dut.write_clk)
    await RisingEdge(dut.read_clk)

    read_data = []

    while(dut.queue_empty == 0):
        read_data = await read_data(dut)
    
    print(test_data)
    print(read_data)

