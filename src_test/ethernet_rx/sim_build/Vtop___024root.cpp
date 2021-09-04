// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtop.h for the primary calling header

#include "Vtop___024root.h"
#include "Vtop__Syms.h"

#include "verilated_dpi.h"

//==========

VL_INLINE_OPT void Vtop___024root___combo__TOP__2(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___combo__TOP__2\n"); );
    // Body
    vlSelf->ethernet_rx__DOT__rxd = vlSelf->rxd;
    vlSelf->ethernet_rx__DOT__rx_clk = vlSelf->rx_clk;
    vlSelf->ethernet_rx__DOT__rx_en = vlSelf->rx_en;
}

VL_INLINE_OPT void Vtop___024root___sequent__TOP__4(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___sequent__TOP__4\n"); );
    // Variables
    CData/*1:0*/ __Vdly__ethernet_rx__DOT__state;
    SData/*10:0*/ __Vdly__ethernet_rx__DOT__nibble_counter;
    // Body
    __Vdly__ethernet_rx__DOT__state = vlSelf->ethernet_rx__DOT__state;
    __Vdly__ethernet_rx__DOT__nibble_counter = vlSelf->ethernet_rx__DOT__nibble_counter;
    if ((0U == (IData)(vlSelf->ethernet_rx__DOT__state))) {
        if (vlSelf->rx_en) {
            __Vdly__ethernet_rx__DOT__nibble_counter = 0U;
            __Vdly__ethernet_rx__DOT__state = 1U;
        }
    } else if ((1U == (IData)(vlSelf->ethernet_rx__DOT__state))) {
        if (vlSelf->rx_en) {
            vlSelf->ethernet_rx__DOT__payload[(0xffU 
                                               & ((IData)(vlSelf->ethernet_rx__DOT__nibble_counter) 
                                                  >> 3U))] 
                = (((~ ((IData)(1U) << (0x1fU & ((IData)(vlSelf->ethernet_rx__DOT__nibble_counter) 
                                                 << 2U)))) 
                    & vlSelf->ethernet_rx__DOT__payload[
                    (0xffU & ((IData)(vlSelf->ethernet_rx__DOT__nibble_counter) 
                              >> 3U))]) | ((1U & (IData)(vlSelf->rxd)) 
                                           << (0x1fU 
                                               & ((IData)(vlSelf->ethernet_rx__DOT__nibble_counter) 
                                                  << 2U))));
            vlSelf->ethernet_rx__DOT__payload[(0xffU 
                                               & (((IData)(1U) 
                                                   + 
                                                   ((IData)(vlSelf->ethernet_rx__DOT__nibble_counter) 
                                                    << 2U)) 
                                                  >> 5U))] 
                = (((~ ((IData)(1U) << (0x1fU & ((IData)(1U) 
                                                 + 
                                                 ((IData)(vlSelf->ethernet_rx__DOT__nibble_counter) 
                                                  << 2U))))) 
                    & vlSelf->ethernet_rx__DOT__payload[
                    (0xffU & (((IData)(1U) + ((IData)(vlSelf->ethernet_rx__DOT__nibble_counter) 
                                              << 2U)) 
                              >> 5U))]) | ((1U & ((IData)(vlSelf->rxd) 
                                                  >> 1U)) 
                                           << (0x1fU 
                                               & ((IData)(1U) 
                                                  + 
                                                  ((IData)(vlSelf->ethernet_rx__DOT__nibble_counter) 
                                                   << 2U)))));
            vlSelf->ethernet_rx__DOT__payload[(0xffU 
                                               & (((IData)(2U) 
                                                   + 
                                                   ((IData)(vlSelf->ethernet_rx__DOT__nibble_counter) 
                                                    << 2U)) 
                                                  >> 5U))] 
                = (((~ ((IData)(1U) << (0x1fU & ((IData)(2U) 
                                                 + 
                                                 ((IData)(vlSelf->ethernet_rx__DOT__nibble_counter) 
                                                  << 2U))))) 
                    & vlSelf->ethernet_rx__DOT__payload[
                    (0xffU & (((IData)(2U) + ((IData)(vlSelf->ethernet_rx__DOT__nibble_counter) 
                                              << 2U)) 
                              >> 5U))]) | ((1U & ((IData)(vlSelf->rxd) 
                                                  >> 2U)) 
                                           << (0x1fU 
                                               & ((IData)(2U) 
                                                  + 
                                                  ((IData)(vlSelf->ethernet_rx__DOT__nibble_counter) 
                                                   << 2U)))));
            vlSelf->ethernet_rx__DOT__payload[(0xffU 
                                               & (((IData)(3U) 
                                                   + 
                                                   ((IData)(vlSelf->ethernet_rx__DOT__nibble_counter) 
                                                    << 2U)) 
                                                  >> 5U))] 
                = (((~ ((IData)(1U) << (0x1fU & ((IData)(3U) 
                                                 + 
                                                 ((IData)(vlSelf->ethernet_rx__DOT__nibble_counter) 
                                                  << 2U))))) 
                    & vlSelf->ethernet_rx__DOT__payload[
                    (0xffU & (((IData)(3U) + ((IData)(vlSelf->ethernet_rx__DOT__nibble_counter) 
                                              << 2U)) 
                              >> 5U))]) | ((1U & ((IData)(vlSelf->rxd) 
                                                  >> 3U)) 
                                           << (0x1fU 
                                               & ((IData)(3U) 
                                                  + 
                                                  ((IData)(vlSelf->ethernet_rx__DOT__nibble_counter) 
                                                   << 2U)))));
        } else {
            __Vdly__ethernet_rx__DOT__state = 2U;
        }
        __Vdly__ethernet_rx__DOT__nibble_counter = 
            (0x7ffU & ((IData)(1U) + (IData)(vlSelf->ethernet_rx__DOT__nibble_counter)));
    } else if ((2U == (IData)(vlSelf->ethernet_rx__DOT__state))) {
        __Vdly__ethernet_rx__DOT__state = 0U;
    }
    vlSelf->ethernet_rx__DOT__nibble_counter = __Vdly__ethernet_rx__DOT__nibble_counter;
    vlSelf->ethernet_rx__DOT__state = __Vdly__ethernet_rx__DOT__state;
}

void Vtop___024root___eval(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval\n"); );
    // Body
    Vtop___024root___combo__TOP__2(vlSelf);
    if (((IData)(vlSelf->rx_clk) & (~ (IData)(vlSelf->__Vclklast__TOP__rx_clk)))) {
        Vtop___024root___sequent__TOP__4(vlSelf);
    }
    // Final
    vlSelf->__Vclklast__TOP__rx_clk = vlSelf->rx_clk;
}

QData Vtop___024root___change_request_1(Vtop___024root* vlSelf);

VL_INLINE_OPT QData Vtop___024root___change_request(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___change_request\n"); );
    // Body
    return (Vtop___024root___change_request_1(vlSelf));
}

VL_INLINE_OPT QData Vtop___024root___change_request_1(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___change_request_1\n"); );
    // Body
    // Change detection
    QData __req = false;  // Logically a bool
    return __req;
}

#ifdef VL_DEBUG
void Vtop___024root___eval_debug_assertions(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((vlSelf->rxd & 0xf0U))) {
        Verilated::overWidthError("rxd");}
    if (VL_UNLIKELY((vlSelf->rx_clk & 0xfeU))) {
        Verilated::overWidthError("rx_clk");}
    if (VL_UNLIKELY((vlSelf->rx_en & 0xfeU))) {
        Verilated::overWidthError("rx_en");}
}
#endif  // VL_DEBUG
