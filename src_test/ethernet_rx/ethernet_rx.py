import cocotb
import logging
from scapy.all import Ether, ARP
from cocotb.clock import Clock
from cocotb.triggers import Event, ClockCycles
from cocotbext.eth import MiiSource, GmiiFrame, MiiPhy

IP_ADDR = "192.168.100.0"

@cocotb.test()
async def test_ethernet_rx(dut):


    cocotb.fork(Clock(dut.rx_clk, 2, units="ns").start())

    l = logging.getLogger("cocotb")

    l.setLevel(logging.DEBUG)
        
    dut.reset <= 1;

    await ClockCycles(dut.rx_clk, 10)

    dut.reset <= 0;


    packet = Ether(dst="01:23:45:67:89:ab")/ARP(pdst=IP_ADDR)
    
    bts = bytearray(packet.build())

    mii_src = MiiSource(dut.rxd, None, dut.rx_dv, dut.rx_clk)

    frame = GmiiFrame.from_payload(bts)

    await mii_src.send(frame)

    packet = Ether(dst="ff:ff:ff:ff:ff:00")/ARP(pdst=IP_ADDR)
    
    frame2 = GmiiFrame.from_payload(bytearray(packet.build()), tx_complete=Event())

    await mii_src.send(frame2)
        
    await mii_src.wait()

    await frame2.tx_complete.wait()

    assert True
    

