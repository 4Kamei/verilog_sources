#include "Vuart_rx.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

#define MAX_CLOCK 4

vluint64_t m_time = 0;


void tick(Vuart_rx* top, VerilatedVcdC* tfp) {
    tfp->dump(m_time++);
    top->eval();
    tfp->flush();
}

void send_byte(uint8_t b, Vuart_rx* top, VerilatedVcdC* tfp) {
    int8_t clocks, index;
    for(index = -1; index < 9; index++) {
        for(clocks = 0; clocks < 2*MAX_CLOCK - 1; clocks++) {
            top->uart_clk = m_time % 2;
            tick(top, tfp);
        }
        top->uart_clk = m_time % 2;
        VL_PRINTF(" main_time=%d, uart_in=%x, clk=%x \n, index=%d", m_time, top->uart_in, top->uart_clk, index);
        if(index == -1) {
            top->uart_in = 0;
        } else if(index == 8) {
            top->uart_in = 1;
        } else {
            top->uart_in = (b >> index) & 0x01;
        }
        tick(top, tfp);
    }
    top->uart_clk = m_time % 2;
    top->uart_in = 1;
    tick(top, tfp);
}

int main(int argc, char** argv, char** env) {
    
    VerilatedContext* contextp = new VerilatedContext;
    contextp->commandArgs(argc, argv);
   
    Verilated::traceEverOn(true);
    
    VerilatedVcdC* tfp = new VerilatedVcdC;
    Vuart_rx* top = new Vuart_rx{contextp};
    
    top->trace(tfp, 99);
    tfp->open("uart_rx.vcd");

    bool not_sent = true;

    while (!contextp->gotFinish() && m_time < 10000) { 
        top->uart_clk = m_time % 2;
        top->uart_in = 1;
        top->reset = 0; 
        tick(top, tfp);

        if(m_time > 1000 && not_sent) {
            
            not_sent = false;

            send_byte(0x55, top, tfp);
            tick(top, tfp);
            tick(top, tfp);
            tick(top, tfp);
            tick(top, tfp);
            
            send_byte(0xff, top, tfp);
            tick(top, tfp);
            tick(top, tfp);
            tick(top, tfp);
            tick(top, tfp);
            
            send_byte('a', top, tfp);
            tick(top, tfp);
            tick(top, tfp);
            tick(top, tfp);
            tick(top, tfp);
            
        }
    }
    
    
    tfp->close();

    delete tfp; 
    delete top;
    delete contextp;
    return 0;
}


