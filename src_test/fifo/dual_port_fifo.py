import logging
import random
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, Combine, RisingEdge, Timer, FallingEdge

import queue

q = queue.Queue()

l = logging.getLogger("cocotb")

bit_num = 16

async def push(wr_data, dut):
    dut.wr_en <= 1
    dut.wr_data <= wr_data
    await ClockCycles(dut.wr_clk, 1)
    dut.wr_en <= 0
    
    if(dut.full == 0):
        q.put(wr_data)
        return True
    return False

async def pop(dut):
    
    await RisingEdge(dut.rd_clk)

    #data here invalid?
    data = dut.rd_data.value.integer
    if(dut.empty == 0):
        data2 = q.get()
        assert data == data2,("data read and data popped don't match {} != {}".format(hex(data), hex(data2)))
        return True
    return False

@cocotb.test()
async def test(dut):


    dut.rd_en <= 0

    random.seed(248234)

    wc = Clock(dut.wr_clk, 10, 'ns')
    cocotb.fork(wc.start())
    
    rc = Clock(dut.rd_clk, 3, 'ns')
    cocotb.fork(rc.start())
    

    dut.reset <= 1

    await Combine(ClockCycles(dut.wr_clk, 2), ClockCycles(dut.rd_clk, 2))

    dut.reset <= 0
    

    #push until full
    while(True):
        ret = await push(random.getrandbits(bit_num), dut)
        if(not ret):
            break

    l.info(list(map(lambda x: hex(x), q.queue)))

    l.info("pushed {} elements into queue".format(q.qsize()))
    
    await ClockCycles(dut.rd_clk, 1)

    l.info("waiting a little bit")
    
    dut.rd_en <= 1

    await RisingEdge(dut.rd_clk)

    while(True):
        ret = await pop(dut)
        if(not ret):
            break

    dut.rd_en <= 0

    l.info("popped all elements")

    

    
    
