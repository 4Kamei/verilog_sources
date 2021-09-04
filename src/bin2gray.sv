`timescale 1ns / 1ps
`default_nettype none

module bin2gray
    #(
        parameter BINARY_WIDTH = 8
    )
    (
        input wire [BINARY_WIDTH - 1: 0] binary,
        output reg [BINARY_WIDTH - 1: 0] gray
    );

    always_comb begin 
        gray <= binary >> 1 ^ binary;
    end

endmodule 
    
