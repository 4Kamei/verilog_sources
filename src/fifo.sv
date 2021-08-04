`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/01/2021 12:07:16 AM
// Design Name: 
// Module Name: fifo
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

//when write_enable is high, store the input_data on the fifo on every clock
//pulse. 
//
//consdering a depth 2 fifo. 
//starting empty -> empty signal high.
//read_enable goes high + clk rising edge => input_data is read into fifo
//+ empty goes low.
//what if full + reading + writing? 
module fifo
   #(   
       parameter DATA_WIDTH = 8,
       parameter DEPTH = 32
    )
    (
        //writing and reading clock
        input wire clk,
        
        //data to be written to the fifo on clock pulse
        input reg [DATA_WIDTH - 1: 0] input_data, 
        //active high write enable
        input reg write_enable,
        output reg full,

        //element polled off fifo every clock if read_enable is high
        output reg [DATA_WIDTH - 1: 0] output_data,
        output reg read_enable,
        output reg empty
    );

    //TODO formally verify this works

endmodule
