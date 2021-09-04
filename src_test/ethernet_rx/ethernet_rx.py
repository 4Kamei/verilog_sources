import cocotb
import logging
from cocotb.clock import Clock
from cocotb.triggers import Event, Timer
from cocotbext.eth import MiiSource, GmiiFrame, MiiPhy

@cocotb.test()
async def test_ethernet_rx(dut):


    cocotb.fork(Clock(dut.rx_clk, 2, units="ns").start())

    l = logging.getLogger("cocotb")

    l.setLevel(logging.DEBUG)

    l.info("testing mii data")

    mii_src = MiiSource(dut.rxd, None, dut.rx_dv, dut.rx_clk, dut.reset)

    #TODO WRITE SCAPY PACKETS

    frame = GmiiFrame.from_payload(b'hello world', tx_complete=Event())
    
    l.info("sending data")
    
    await mii_src.send(frame)

    l.info("waiting for data to send")
    
    await mii_src.wait()
    
    l.info("finished sending")
    assert True
    

