`timescale 1ns / 1ps
`default_nettype none

module ethernet_rx
   #(
       parameter MAX_PAYLOAD_BYTES = 11'd64
    )
    (
        input wire [3:0] rxd,
        input wire rx_clk,
        input wire rx_dv,
        input wire reset,

        output wire has_packet,
        output reg [47:0] dst_mac,
        output reg [47:0] src_mac,
        output reg [15:0] ethertype,
        
    );
    
    `define fill(ARRAY) \ 
        if(~upper_half) begin \  
            ARRAY[byte_counter * 8    ] <= rxd[0]; \ 
            ARRAY[byte_counter * 8 + 1] <= rxd[1]; \
            ARRAY[byte_counter * 8 + 2] <= rxd[2]; \ 
            ARRAY[byte_counter * 8 + 3] <= rxd[3]; \
            upper_half <= 1'b1; \
            byte_counter = byte_counter + 1'b1; \
        end else begin \
            ARRAY[byte_counter * 8 + 4] <= rxd[0]; \
            ARRAY[byte_counter * 8 + 5] <= rxd[1]; \
            ARRAY[byte_counter * 8 + 6] <= rxd[2]; \
            ARRAY[byte_counter * 8 + 7] <= rxd[3]; \ 
            upper_half <= 1'b0; \ 
        end
        

    `ifdef COCOTB_SIM
    initial begin
        $dumpfile("ethernet_rx.vcd");
        $dumpvars(0, ethernet_rx);
        #1;
    end
    `endif

    typedef enum logic [2:0] {IDLE, PREAMBLE, DST_MAC, SRC_MAC, ETHERTYPE, PAYLOAD, DONE} state_t;

    state_t state;


    //
    
    reg [$clog2(MAX_PAYLOAD_BYTES):0] byte_counter;
    
    reg upper_half;

    always @(posedge rx_clk) begin
        if(reset) begin
            state <= IDLE; 
            payload <= 0;
            src_mac <= 0;
            dst_mac <= 0;
            ethtype <= 0;
        end else begin
            if(state != IDLE && !rx_dv) begin
                state <= DONE;
            end
            case(state)
                IDLE: begin
                    if(rx_dv) begin
                        byte_counter <= 0;
                        upper_half <= 1'b1;
                        state <= PREAMBLE;
                    end
                end
                PREAMBLE: begin
                    if(rx_dv) begin
                        if(rxd == 4'hd) begin
                            state <= DST_MAC;
                        end
                    end
                end
                DST_MAC: begin
                    if(rx_dv) begin
                        `fill(dst_mac)
                        if(byte_counter == 'd6) begin
                            state <= SRC_MAC;
                            byte_counter <= 0;
                            upper_half <= 1'b1;
                        end
                        //collect data
                    end else begin
                        state <= DONE;
                    end
                end
                SRC_MAC: begin
                    if(rx_dv) begin
                        `fill(src_mac)
                        if(byte_counter == 'd6) begin
                            state <= ETHERTYPE;
                            byte_counter <= 0;
                            upper_half <= 1'b1;
                        end
                        //collect data
                    end else begin
                        state <= DONE;
                    end
                end
                ETHERTYPE: begin
                    if(rx_dv) begin
                        `fill(ethtype)
                        if(byte_counter == 'd2) begin
                            state <= PAYLOAD;
                            byte_counter <= 0;
                            upper_half <= 1'b1;
                        end
                        //collect data
                    end else begin
                        state <= DONE;
                    end
                end
                PAYLOAD: begin
                    if(rx_dv) begin
                        `fill(payload)
                    end else begin
                        state <= DONE;
                    end
                end
                DONE: begin
                    state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule
