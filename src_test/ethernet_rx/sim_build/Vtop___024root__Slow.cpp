// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtop.h for the primary calling header

#include "Vtop___024root.h"
#include "Vtop__Syms.h"

#include "verilated_dpi.h"

//==========

const IData Vtop___024root::var_ethernet_rx__DOT__MAX_PACKET_BYTES(0x400U);


void Vtop___024root___ctor_var_reset(Vtop___024root* vlSelf);

Vtop___024root::Vtop___024root(const char* _vcname__)
    : VerilatedModule(_vcname__)
 {
    // Reset structure values
    Vtop___024root___ctor_var_reset(this);
}

void Vtop___024root::__Vconfigure(Vtop__Syms* _vlSymsp, bool first) {
    if (false && first) {}  // Prevent unused
    this->vlSymsp = _vlSymsp;
}

Vtop___024root::~Vtop___024root() {
}

void Vtop___024root___initial__TOP__1(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___initial__TOP__1\n"); );
    // Variables
    VlWide<4>/*127:0*/ __Vtemp1;
    // Body
    __Vtemp1[0U] = 0x2e766364U;
    __Vtemp1[1U] = 0x745f7278U;
    __Vtemp1[2U] = 0x65726e65U;
    __Vtemp1[3U] = 0x657468U;
    vlSymsp->_vm_contextp__->dumpfile(VL_CVT_PACK_STR_NW(4, __Vtemp1));
    VL_PRINTF_MT("-Info: ../../src/ethernet_rx.sv:18: $dumpvar ignored, as Verilated without --trace\n");
}

void Vtop___024root___eval_initial(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_initial\n"); );
    // Body
    Vtop___024root___initial__TOP__1(vlSelf);
    vlSelf->__Vclklast__TOP__rx_clk = vlSelf->rx_clk;
}

void Vtop___024root___combo__TOP__2(Vtop___024root* vlSelf);

void Vtop___024root___eval_settle(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_settle\n"); );
    // Body
    Vtop___024root___combo__TOP__2(vlSelf);
}

void Vtop___024root___final(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___final\n"); );
}

void Vtop___024root___ctor_var_reset(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___ctor_var_reset\n"); );
    // Body
    vlSelf->rxd = VL_RAND_RESET_I(4);
    vlSelf->rx_clk = VL_RAND_RESET_I(1);
    vlSelf->rx_en = VL_RAND_RESET_I(1);
    vlSelf->ethernet_rx__DOT__rxd = VL_RAND_RESET_I(4);
    vlSelf->ethernet_rx__DOT__rx_clk = VL_RAND_RESET_I(1);
    vlSelf->ethernet_rx__DOT__rx_en = VL_RAND_RESET_I(1);
    vlSelf->ethernet_rx__DOT__state = VL_RAND_RESET_I(2);
    vlSelf->ethernet_rx__DOT__nibble_counter = VL_RAND_RESET_I(11);
    VL_RAND_RESET_W(8192, vlSelf->ethernet_rx__DOT__payload);
    vlSelf->ethernet_rx__DOT__src_mac = VL_RAND_RESET_Q(48);
    vlSelf->ethernet_rx__DOT__dst_mac = VL_RAND_RESET_Q(48);
    vlSelf->ethernet_rx__DOT__ethtype = VL_RAND_RESET_I(16);
}
