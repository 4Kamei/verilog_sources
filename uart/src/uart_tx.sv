`timescale 1ns / 1ps
`default_nettype none

module uart_tx
    #(
        parameter INPUT_CLOCK = 12_000_000,
        parameter BAUD_RATE = 115_200,
        //TODO IMPLEMENT A PARITY BIT
    )(
        input wire clk,
        input wire reset,
        input wire [7:0] out_data,
        input wire transmit,
        output reg transmit_ready,
        output reg uart_out
    );
    
    localparam CLOCKS_PER_BAUD = INPUT_CLOCK/BAUD_RATE;
    localparam DIVIDER_WIDTH = $clog2(CLOCKS_PER_BAUD);

    typedef enum reg [1:0] {IDLE, TRANSMITTING} state_t;

    reg [DIVIDER_WIDTH-1:0] clock_counter;
    
    reg [3:0] byte_counter;
    reg [9:0] out_data_reg;

    reg send_strobe;

    state_t state;
 
    always @(posedge clk) begin
        transmit_ready <= 0;
        if(reset) begin
            clock_counter <= 0;
            state <= IDLE;
            send_strobe <= 0;
            uart_out <= 1;
        end else begin
            case(state)
                IDLE: begin
                    transmit_ready <= 1;
                    if(transmit) begin
                        state <= TRANSMITTING;
                        out_data_reg <= {1'b1, out_data, 1'b0};
                        byte_counter <= 0;
                    end
                end
                TRANSMITTING: begin
                    clock_counter <= clock_counter + 1'b1;
                    if(clock_counter == CLOCKS_PER_BAUD) begin
                        clock_counter <= 0;
                        send_strobe <= 1;
                    end
                end
            endcase
        end
    end

    always @(posedge clk) begin
        if(send_strobe) begin
            uart_out <= out_data_reg[byte_counter];
            byte_counter <= byte_counter + 1;
            if (byte_counter == 4'd9) begin
                state <= IDLE;
            end
            send_strobe <= 0;
        end
    end
    
endmodule
