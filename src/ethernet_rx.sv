`timescale 1ns / 1ps
`default_nettype none

module ethernet_rx
   #(
       parameter MAX_PACKET_BYTES = 11'd1024
    )
    (
        input wire [3:0] rxd,
        input wire rx_clk,
        input wire rx_dv,
        input wire reset
    );


    `ifdef COCOTB_SIM
    initial begin
        $dumpfile("ethernet_rx.vcd");
        $dumpvars(0, ethernet_rx);
        #1;
    end
    `endif

    typedef enum logic [1:0] {IDLE, REC, DONE} state_t;

    state_t state;


    //
    reg [$clog2(MAX_PACKET_BYTES): 0] nibble_counter;

    reg [MAX_PACKET_BYTES * 8 - 1: 0] payload;

    wire [47:0] src_mac;
    wire [47:0] dst_mac;
    wire [15:0] ethtype;

    always @(posedge rx_clk) begin
        if(reset) begin
            state = IDLE;   
        end else begin
            case(state)
                IDLE: begin
                    if(rx_dv) begin
                        nibble_counter <= 0;
                        state <= REC;
                    end
                end
                REC: begin
                    if(rx_dv) begin
                        payload[nibble_counter * 4] <= rxd[0];
                        payload[nibble_counter * 4 + 1] <= rxd[1];
                        payload[nibble_counter * 4 + 2] <= rxd[2];
                        payload[nibble_counter * 4 + 3] <= rxd[3];
                        //collect data
                    end else begin
                        state <= DONE;
                    end
                    nibble_counter <= nibble_counter + 1'b1;
                end
                DONE: begin
                    state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule
