`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/03/2021 03:34:23 PM
// Design Name: 
// Module Name: seg7_driver
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


module seg7_driver
   #(   parameter DISP_NUMBER = 4,
        parameter CLOCK_DIVIDER = 12_000    
    )
    (   input wire i_clk,
        input wire[4 * DISP_NUMBER - 1: 0] i_disp_data,
        output reg [DISP_NUMBER - 1: 0] o_disp_enable,
        output reg [6:0] o_segments
    );

    //active low, so all bits except one are 1
    initial o_disp_enable = ~1;   
    
    //for the for loop

    always @(posedge i_clk) begin
        o_disp_enable <= {o_disp_enable[0], o_disp_enable[DISP_NUMBER - 1: 1]};
    end

    wire [3:0] selected_nibble;

    logic [DISP_NUMBER-1: 0] tmp0; 
    logic [DISP_NUMBER-1: 0] tmp1; 
    logic [DISP_NUMBER-1: 0] tmp2; 
    logic [DISP_NUMBER-1: 0] tmp3; 

    genvar i;

    //generate combinatorial logic for selecting the correct nibble to write
    //out, based on the position of the 0 in o_disp_enable. 
    generate 
        for(i = 0; i < DISP_NUMBER; i = i + 1) begin : nibble_selector_loop
            assign tmp0[i] = ~o_disp_enable[i] & i_disp_data[4*i+0];
            assign tmp1[i] = ~o_disp_enable[i] & i_disp_data[4*i+1];
            assign tmp2[i] = ~o_disp_enable[i] & i_disp_data[4*i+2];
            assign tmp3[i] = ~o_disp_enable[i] & i_disp_data[4*i+3];
        end
    endgenerate
    
    assign selected_nibble = {|tmp3, |tmp2, |tmp1, |tmp0};

    hex_to_sseg decoder_inst(.i_hex(selected_nibble), .o_sseg(o_segments)); 

endmodule
