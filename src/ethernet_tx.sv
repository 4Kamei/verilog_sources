`timescale 1ns / 1ps
`default_nettype none

module ethernet_tx(
        input wire tx_clk, //clock at twice the output frequency for manchester encoding
        input wire tx_enable, //starts transmitting on next tx_clk cycle, and transmits for as long as tx_enable is high. 
        output reg /* verilator lint_off UNDRIVEN */ tx_finished, /* verilator lint_on UNDRIVEN */
        output wire tx_out,

        input wire [9:0] packet_size_ext,
        input wire [7:0] byte_data,
        input wire [9:0] write_address,
        input wire we,
        input wire w_clk
    );

    typedef enum [1:0] {IDLE, TRANSMIT, CRC} Ttx_state; 

    //1kB of ram for a maximum packet size of 1024 octets, this includes the header
    reg [7:0] tx_memory [1023:0]; 

    always @(posedge w_clk) begin
        if(we & ~tx_enable) begin
            tx_memory[write_address] <= byte_data;
        end
    end

    Ttx_state tx_state;
    reg [9:0] packet_size;
    reg [12:0] bit_counter;
    reg manchester;
    reg [7:0] cur_byte;

    always @(posedge tx_clk) begin
        if(tx_enable) begin
            case(tx_state)
                IDLE: begin
                    bit_counter <= 0;
                    packet_size <= packet_size_ext;
                    manchester <= 0; 
                    tx_state <= TRANSMIT;
                end
                TRANSMIT: begin 
                    cur_byte <= tx_memory[bit_counter[12:3]];
                    manchester <= ~manchester;
                    if(manchester == 1) begin
                        tx_out <= ~cur_byte[bit_counter[2:0]];
                    end else begin
                        tx_out <= cur_byte[bit_counter[2:0]];
                        bit_counter <= bit_counter + 1'b1;
                        if(bit_counter[12:3] == packet_size) begin
                           tx_state <= CRC; 
                        end
                    end
                end
                CRC: begin
                    //compute this
                end
                default: assert(0);
            endcase
        end
    end

endmodule
