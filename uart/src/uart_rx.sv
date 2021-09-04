`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/29/2021 10:17:57 PM
// Design Name: 
// Module Name: uart_rx
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module uart_rx
    #(   parameter CLOCK_FREQUENCY = 12_000_000,
         parameter BAUD_RATE = 115_200,
         parameter PARITY_BIT = 0
     )(
        input wire uart_clk,
        input wire uart_in,
        input wire reset,

        output reg [7:0] data,
        output reg data_out_strobe
    );
    
    localparam CLOCKS_PER_BAUD = CLOCK_FREQUENCY/BAUD_RATE;

    localparam DELAY_WIDTH = $clog2(CLOCK_FREQUENCY * 3/2);

    //for easier verification
    `ifdef COCOTB_SIM
        wire read_strobe;
        assign read_strobe = clock_delay == 0;
    `endif

    reg receiving_state = 0;
    reg returned_high = 1;
    reg [2:0] byte_counter = 0;
    reg [DELAY_WIDTH: 0] clock_delay = 0;

    always @(posedge uart_clk) begin
        if(reset) begin     
            data_out_strobe <= 0;
            receiving_state <= 0;
            byte_counter <= 0;
            clock_delay <= 0;
            returned_high <= 1;
        end else begin
        //if we are receiving
            if(receiving_state) begin
                if(clock_delay == 0) begin
                    data[byte_counter] <= uart_in;                    
                    clock_delay <= CLOCKS_PER_BAUD - 1'b1;
                    byte_counter <= byte_counter + 1'b1;
                    if(byte_counter == 3'b111) begin
                        receiving_state <= 1'b0;
                        returned_high <= 0;
                    end
                end else begin
                    clock_delay <= clock_delay - 1'b1;
                end
            end else begin
            //set receiving state, so we're receiving bits
            //delay by one clock cycle
                if(returned_high) begin
                    if(uart_in == 0) begin
                        receiving_state <= 1'b1;
                        //there is a chance that the edges of our clock fall close to the bit edges
                        //so we wait one extra clock to stop any skew
                        clock_delay <= (CLOCKS_PER_BAUD + CLOCKS_PER_BAUD/2); 
                        byte_counter <= 3'b000;
                    end
                end else begin
                    if(uart_in) begin
                        returned_high <= 1'b1;
                        data_out_strobe <= 1'b1;
                    end
                end
            end
        end
        if(data_out_strobe) begin
            data_out_strobe <= 0;
        end
    end
    
endmodule

