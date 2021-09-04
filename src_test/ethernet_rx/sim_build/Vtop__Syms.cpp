// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table implementation internals

#include "Vtop__Syms.h"
#include "Vtop.h"
#include "Vtop___024root.h"

// FUNCTIONS
Vtop__Syms::~Vtop__Syms()
{

    // Tear down scope hierarchy
    __Vhier.remove(0, &__Vscope_ethernet_rx);

}

Vtop__Syms::Vtop__Syms(VerilatedContext* contextp, const char* namep,Vtop* modelp)
    : VerilatedSyms{contextp}
    // Setup internal state of the Syms class
    , __Vm_modelp(modelp)
    // Setup module instances
    , TOP(namep)
{
    // Configure time unit / time precision
    _vm_contextp__->timeunit(-9);
    _vm_contextp__->timeprecision(-12);
    // Setup each module's pointers to their submodules
    // Setup each module's pointer back to symbol table (for public functions)
    TOP.__Vconfigure(this, true);
    // Setup scopes
    __Vscope_TOP.configure(this, name(), "TOP", "TOP", 0, VerilatedScope::SCOPE_OTHER);
    __Vscope_ethernet_rx.configure(this, name(), "ethernet_rx", "ethernet_rx", -9, VerilatedScope::SCOPE_MODULE);

    // Set up scope hierarchy
    __Vhier.add(0, &__Vscope_ethernet_rx);

    // Setup export functions
    for (int __Vfinal=0; __Vfinal<2; __Vfinal++) {
        __Vscope_TOP.varInsert(__Vfinal,"rx_clk", &(TOP.rx_clk), false, VLVT_UINT8,VLVD_IN|VLVF_PUB_RW,0);
        __Vscope_TOP.varInsert(__Vfinal,"rx_en", &(TOP.rx_en), false, VLVT_UINT8,VLVD_IN|VLVF_PUB_RW,0);
        __Vscope_TOP.varInsert(__Vfinal,"rxd", &(TOP.rxd), false, VLVT_UINT8,VLVD_IN|VLVF_PUB_RW,1 ,3,0);
        __Vscope_ethernet_rx.varInsert(__Vfinal,"MAX_PACKET_BYTES", const_cast<void*>(static_cast<const void*>(&(TOP.var_ethernet_rx__DOT__MAX_PACKET_BYTES))), true, VLVT_UINT16,VLVD_NODIR|VLVF_PUB_RW,1 ,10,0);
        __Vscope_ethernet_rx.varInsert(__Vfinal,"dst_mac", &(TOP.ethernet_rx__DOT__dst_mac), false, VLVT_UINT64,VLVD_NODIR|VLVF_PUB_RW,1 ,47,0);
        __Vscope_ethernet_rx.varInsert(__Vfinal,"ethtype", &(TOP.ethernet_rx__DOT__ethtype), false, VLVT_UINT16,VLVD_NODIR|VLVF_PUB_RW,1 ,15,0);
        __Vscope_ethernet_rx.varInsert(__Vfinal,"nibble_counter", &(TOP.ethernet_rx__DOT__nibble_counter), false, VLVT_UINT16,VLVD_NODIR|VLVF_PUB_RW,1 ,10,0);
        __Vscope_ethernet_rx.varInsert(__Vfinal,"payload", &(TOP.ethernet_rx__DOT__payload), false, VLVT_WDATA,VLVD_NODIR|VLVF_PUB_RW,1 ,8191,0);
        __Vscope_ethernet_rx.varInsert(__Vfinal,"rx_clk", &(TOP.ethernet_rx__DOT__rx_clk), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_ethernet_rx.varInsert(__Vfinal,"rx_en", &(TOP.ethernet_rx__DOT__rx_en), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0);
        __Vscope_ethernet_rx.varInsert(__Vfinal,"rxd", &(TOP.ethernet_rx__DOT__rxd), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,3,0);
        __Vscope_ethernet_rx.varInsert(__Vfinal,"src_mac", &(TOP.ethernet_rx__DOT__src_mac), false, VLVT_UINT64,VLVD_NODIR|VLVF_PUB_RW,1 ,47,0);
        __Vscope_ethernet_rx.varInsert(__Vfinal,"state", &(TOP.ethernet_rx__DOT__state), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,1 ,1,0);
    }
}
