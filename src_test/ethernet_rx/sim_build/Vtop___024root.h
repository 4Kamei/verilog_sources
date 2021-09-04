// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vtop.h for the primary calling header

#ifndef VERILATED_VTOP___024ROOT_H_
#define VERILATED_VTOP___024ROOT_H_  // guard

#include "verilated_heavy.h"

//==========

class Vtop__Syms;

//----------

VL_MODULE(Vtop___024root) {
  public:

    // PORTS
    VL_IN8(rx_clk,0,0);
    VL_IN8(rxd,3,0);
    VL_IN8(rx_en,0,0);

    // LOCAL SIGNALS
    CData/*3:0*/ ethernet_rx__DOT__rxd;
    CData/*0:0*/ ethernet_rx__DOT__rx_clk;
    CData/*0:0*/ ethernet_rx__DOT__rx_en;
    CData/*1:0*/ ethernet_rx__DOT__state;
    SData/*10:0*/ ethernet_rx__DOT__nibble_counter;
    SData/*15:0*/ ethernet_rx__DOT__ethtype;
    VlWide<256>/*8191:0*/ ethernet_rx__DOT__payload;
    QData/*47:0*/ ethernet_rx__DOT__src_mac;
    QData/*47:0*/ ethernet_rx__DOT__dst_mac;

    // LOCAL VARIABLES
    CData/*0:0*/ __Vclklast__TOP__rx_clk;

    // INTERNAL VARIABLES
    Vtop__Syms* vlSymsp;  // Symbol table

    // PARAMETERS
    enum _IDataethernet_rx__DOT__MAX_PACKET_BYTES { ethernet_rx__DOT__MAX_PACKET_BYTES = 0x400U};
    static const IData var_ethernet_rx__DOT__MAX_PACKET_BYTES;

    // CONSTRUCTORS
  private:
    VL_UNCOPYABLE(Vtop___024root);  ///< Copying not allowed
  public:
    Vtop___024root(const char* name);
    ~Vtop___024root();

    // INTERNAL METHODS
    void __Vconfigure(Vtop__Syms* symsp, bool first);
} VL_ATTR_ALIGNED(VL_CACHE_LINE_BYTES);

//----------


#endif  // guard
