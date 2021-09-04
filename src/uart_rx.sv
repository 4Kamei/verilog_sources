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
   #(   parameter clock_multiple = 3'd4    ) //need to be very careful with this, as not having 3' means DELAY_WIDTH is 32 suddenly, which increases the sizes of all reginsters for no reason
    (
        input wire uart_clk,
        input wire reset,

        input wire uart_in,
        
        output reg[7:0] data,
        output reg data_ready  
    );
    
    localparam DELAY_WIDTH = $clog2(clock_multiple) + 1'b1;

    reg receiving_state = 0;
    reg returned_high = 1;
    reg [2:0] byte_counter = 0;
    reg [DELAY_WIDTH - 1: 0] clock_delay = 0;
    
    //assume the clock is a multiple of the transmit frequency (4x)
    //when a 1 -> 0 transition is found, start reading data delayed by
    //4 clocks. 
    

    //TODO write TB for this 

    always @(posedge uart_clk) begin
        if(reset) begin     
            receiving_state <= 1'b0;
            byte_counter <= 3'b0;
            clock_delay <= 0;
            data_ready <= 1'b0;
            returned_high <= 1'b1;
        end else begin
        //if we are receiving
            if(receiving_state) begin
                if(clock_delay == 0) begin
                    data[byte_counter] <= uart_in;                    
                    clock_delay <= clock_multiple - 1;
                    byte_counter <= byte_counter + 1'b1;
                    if(byte_counter == 3'b111) begin
                        receiving_state <= 1'b0;
                        returned_high <= uart_in;
                        data_ready <= 1'b1;
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
                        data_ready <= 0;
                        //there is a chance that the edges of our clock fall close to the bit edges
                        //so we wait one extra clock to stop any skew
                        clock_delay <= clock_multiple; 
                        byte_counter <= 3'b000;
                    end
                end else begin
                    if(uart_in) begin
                        returned_high <= 1'b1;
                    end
                end
            end
        end
    end
    
endmodule

