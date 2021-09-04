`timescale 1ns / 1ps
`default_nettype none

module uart_tx_tb
    #(
        parameter INPUT_CLOCK = 12_000_000,
        parameter BAUD_RATE = 115_200
    )(
        input wire clk,
        input wire reset,
        input wire [7:0] out_data,
        input wire transmit,
        output reg transmit_ready,
        output reg uart_out
    );

    initial begin
        $dumpfile("uart_tx_tb.vcd");
        $dumpvars(0, uart_tx_tb);
    end

    uart_tx #(.INPUT_CLOCK(INPUT_CLOCK),
            .BAUD_RATE(BAUD_RATE)) 
        uart_tx_inst(
            .clk,
            .reset,
            .out_data,
            .transmit,
            .transmit_ready,
            .uart_out);
endmodule
