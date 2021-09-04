import cocotb
import logging
from cocotb.triggers import Timer

def bin2gray(num):
    return num >> 1 ^ num;

def gray2bin(num):
    mask = num
    while(mask != 0):
        mask = mask >> 1
        num = num ^ mask
    return num


BINARY_WIDTH = 8

@cocotb.test()
async def test(dut):
    max_value = 2 ** BINARY_WIDTH
    values = [i for i in range(max_value)]

    l = logging.getLogger("cocotb")


    for i in range(max_value):
        g = bin2gray(i)
        l.info("testing BIN -> GRAY {}".format(i))
        dut.i_bin <= i;

        await Timer(2, "ns")
        
        assert dut.o_gray == g, "got : {}".format(dut.o_gray.value)
                
    for i in range(max_value):
        g = bin2gray(i)
        l.info("testing GRAY -> BIN {}".format(i))
        dut.i_gray <= g;

        await Timer(2, "ns")
        
        assert dut.o_bin == i, "got : {}".format(dut.o_bin.value)
                
