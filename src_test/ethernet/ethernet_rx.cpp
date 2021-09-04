#include "Vethernet_rx.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vethernet_rx___024root.h"

vluint64_t m_time = 0;

uint8_t bytes[] = {0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0xD5, 0x00, 0x10, 0xA4, 0x7B, 0xEA, 0x80, 0x00, 0x12, 0x34, 0x56, 0x78, 0x90, 0x08, 0x00, 0x45, 0x00, 0x00, 0x2E, 0xB3, 0xFE, 0x00, 0x00, 0x80, 0x11, 0x05, 0x40, 0xC0, 0xA8, 0x00, 0x2C, 0xC0, 0xA8, 0x00, 0x04, 0x04, 0x00, 0x04, 0x00, 0x00, 0x1A, 0x2D, 0xE8, 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F, 0x10, 0x11, 0xB3, 0x31, 0x88, 0x1B};

int arrLength = sizeof(bytes)/sizeof(bytes[0]);

void tick(Vethernet_rx* top, VerilatedVcdC* tfp) {
    tfp->dump(m_time++);
    top->i_clkQ = ( (m_time  + 3) / 2) % 2;
    top->i_clk =  ((m_time) / 2) % 2;
    top->eval();
    tfp->flush();
}

void send_byte(Vethernet_rx* top, VerilatedVcdC* tfp, uint8_t byte) {
    int8_t ind = 0;
    for(ind = 0; ind < 8; ind++) {
        uint8_t bit = (byte >> ind) & 1;
        top->i_ethernet = !bit;
        tick(top, tfp);
        tick(top, tfp);
        top->i_ethernet = bit;
        tick(top, tfp);
        tick(top, tfp);
    }
}

int main(int argc, char** argv, char** env) {
    
    VerilatedContext* contextp = new VerilatedContext;
    contextp->commandArgs(argc, argv);
   
    Verilated::traceEverOn(true);
    
    VerilatedVcdC* tfp = new VerilatedVcdC;
    Vethernet_rx* top = new Vethernet_rx{contextp};
    
    top->trace(tfp, 99);
    tfp->open("ethernet_rx.vcd");

    bool not_sent = true;
    int clocks_before_send = 100;
    int cur_byte = 0;

    while (!contextp->gotFinish() && m_time < 1000) { 
        if(clocks_before_send > 0) {
            clocks_before_send--;
            tick(top, tfp);
        } else {
            send_byte(top, tfp, bytes[cur_byte++]);
        }
    }
    
    
    tfp->close();

    delete tfp; 
    delete top;
    delete contextp;
    return 0;
}


