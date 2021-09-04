`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.07.2021 12:16:19
// Design Name: 
// Module Name: hex_to_sseg
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: None
// 
// Revision: 1
// Revision 0.01 - File Created
// Additional Comments:
// Takes a hex signal and converts to a 7 wide seven segment display input
//////////////////////////////////////////////////////////////////////////////////




module hex_to_sseg(
	input wire[3:0] i_hex,
	output reg[6:0] o_sseg);
	
	always @(*) begin
	   case(i_hex) 
	       4'h0: o_sseg = 7'h3f;
	       4'h1: o_sseg = 7'h06;
	       4'h2: o_sseg = 7'h5b;
	       4'h3: o_sseg = 7'h4f;
	       4'h4: o_sseg = 7'h66;
	       4'h5: o_sseg = 7'h6d;
	       4'h6: o_sseg = 7'h7d;
	       4'h7: o_sseg = 7'h07;
	       4'h8: o_sseg = 7'h7f;
	       4'h9: o_sseg = 7'h6f;
	       4'ha: o_sseg = 7'h77;
	       4'hb: o_sseg = 7'h7c;
	       4'hc: o_sseg = 7'h39;
	       4'hd: o_sseg = 7'h5e;
	       4'he: o_sseg = 7'h79;
	       4'hf: o_sseg = 7'h71;
	   endcase   
	end
	
endmodule
