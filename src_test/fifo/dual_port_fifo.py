import logging
import random
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, Combine, RisingEdge, Timer,FallingEdge
from cocotb.binary import BinaryValue

import queue

class TB:

    def __init__(self, dut):
        self.log = logging.getLogger("cocotb")
        self.dut = dut;
        self.queue = queue.Queue()
        self.queue_width = 16
        self.wr_clk_period = 13
        self.rd_clk_period = 7

    async def start(self):
        self.dut.rd_en <= 0
        self.dut.wr_en <= 0
        self.dut.reset <= 0

        wc = Clock(self.dut.wr_clk, self.wr_clk_period, 'ns')
        cocotb.fork(wc.start())
        
        rc = Clock(self.dut.rd_clk, self.rd_clk_period, 'ns')
        cocotb.fork(rc.start())


    async def reset(self) -> None:
        self.dut.reset <= 1
        
        await ClockCycles(self.dut.rd_clk, 1)
        await ClockCycles(self.dut.wr_clk, 1)
        await ClockCycles(self.dut.rd_clk, 1)
        await ClockCycles(self.dut.wr_clk, 1)
        
        self.dut.reset <= 0
        
        await ClockCycles(self.dut.rd_clk, 1)
        await ClockCycles(self.dut.wr_clk, 1)
    
        
        
    def stop_write(self):
        self.dut.wr_en <= 0
        self.dut.wr_data <= BinaryValue('z' * self.queue_width)

    def stop_read(self):
        self.dut.rd_en <= 0

    async def push(self, wr_data):
        await FallingEdge(self.dut.wr_clk)
        
        if(self.dut.full == 1):
            return False
        
        self.dut.wr_en <= 1
        self.dut.wr_data <= wr_data
        await RisingEdge(self.dut.wr_clk)
        self.queue.put(wr_data)
        self.log.info("pushing {}".format(wr_data))
        return True
    
    async def pop(self):  
        await FallingEdge(self.dut.rd_clk)
        
        if(self.dut.empty == 1):
            self.log.info("empty status == {}".format(self.dut.empty))
            if(not self.queue.empty()):
                self.log.info(list(map(hex, self.queue.queue)))
            return False, None
        


        self.dut.rd_en <= 1
        data = self.dut.rd_data.value.integer
        await RisingEdge(self.dut.rd_clk)
        self.log.info("popping {}".format(data))
        
        test_data = self.queue.get()
        assert data == test_data, "pushed and popped values don't match! read {}, expected {}".format(hex(data), hex(test_data))

        return True, data

@cocotb.test()
async def write_then_read(device):
              
    dut = TB(device)

    await dut.start()
    await dut.reset()

    dut.log.info("device reset")
 
    #push until full
    while(True):
        data = random.getrandbits(dut.queue_width)       
        result = await dut.push(data)
        if(not result):
            break

    dut.stop_write()

    dut.log.info("queue full, popping all elements")

   
    while(True):
        ret, data = await dut.pop()
        if(not ret):
            break
    
    dut.stop_read()


    dut.log.info("popped all elements")


@cocotb.test()
async def write_and_read(device):

    dut = TB(device)

    await dut.start()
    await dut.reset()

    #dut should be in predictable state
    
    dut.log.info("device reset")

    operations = 2000
    while(operations > 0):
        operations -= 1
        read = random.randint(0, 1) == 0
        if(read):
            dut.stop_write()
            result, data = await dut.pop()

        else:
            dut.stop_read()
            data = random.getrandbits(dut.queue_width)
            result = await dut.push(data)

    
    
    
