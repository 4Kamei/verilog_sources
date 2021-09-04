`timescale 1ns / 1ps
`default_nettype none

module uart_rx_tb
    #(   
        parameter CLOCK_FREQUENCY = 20_000,
        parameter BAUD_RATE = 4_000,
        parameter PARITY_BIT = 0
    )(
        input wire i_uart_clk,
        input wire i_uart_in,
        input wire i_reset,

        output reg[7:0] o_data,
        output reg o_data_out_strobe
    );

    initial begin
        $dumpfile("uart_rx_tb.vcd");
        $dumpvars(0, uart_rx_tb);
    end

    uart_rx #(.CLOCK_FREQUENCY(CLOCK_FREQUENCY),
            .BAUD_RATE(BAUD_RATE),
            .PARITY_BIT(PARITY_BIT)) 
        uart_rx_inst(
        .uart_clk(i_uart_clk),
        .uart_in(i_uart_in),
        .reset(i_reset),
        .data(o_data),
        .data_out_strobe(o_data_out_strobe));

endmodule
