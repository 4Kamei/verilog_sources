`timescale 1ns / 1ps
`default_nettype none

module gray2bin
    #(
        parameter BINARY_WIDTH = 8
    )
    (
        output reg [BINARY_WIDTH - 1: 0] binary,
        input wire [BINARY_WIDTH - 1: 0] gray
    );

    integer i;

    always_comb begin
        for(i = 0; i < BINARY_WIDTH; i++) begin
            binary[i] <= ^(gray >> i);
        end
    end

endmodule 
    
