`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/03/2021 04:53:05 PM
// Design Name: 
// Module Name: seg7_driver_tb
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


module seg7_driver_tb;
    
    reg clk = 0;
    reg [15:0] output_bytes = 0;

    initial begin
        $dumpfile("seg7_driver_tb.vcd");
        $dumpvars(clk, output_bytes, de, segments);
    end

    always begin
        #8
        output_bytes = output_bytes + 8'h11;
    end

    always #1 clk = ~clk;

    reg [3:0] de;
    reg [6:0] segments;

    seg7_driver #(.DISP_NUMBER(4), .CLOCK_DIVIDER(2)) uut(clk, output_bytes, de, segments); 

endmodule
