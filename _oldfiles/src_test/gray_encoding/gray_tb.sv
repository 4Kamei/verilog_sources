`timescale 1ns / 1ps
`default_nettype none

module gray_tb
    #(
        parameter BINARY_WIDTH = 8
    )(

        input wire [BINARY_WIDTH - 1: 0] i_bin,
        output wire [BINARY_WIDTH - 1: 0] o_gray,
        input wire [BINARY_WIDTH - 1: 0] i_gray,
        output wire [BINARY_WIDTH - 1: 0] o_bin
    );


    bin2gray #(.BINARY_WIDTH(BINARY_WIDTH)) b2g(.binary(i_bin), .gray(o_gray));
    
    gray2bin #(.BINARY_WIDTH(BINARY_WIDTH)) g2b(.binary(o_bin), .gray(i_gray));

endmodule 
