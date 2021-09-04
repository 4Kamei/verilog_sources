`timescale 1ns / 1ps
`default_nettype none


//inputs a clock at half the ethernet clock, and single-ended data signal 

//assume that the clock is synchronized to the data


module ethernet_rx (
        //input clock to ethernet
        input wire i_clk,
        //input clock phase-shifted by 90 degrees, so that rising edge is in
        //the middle of the second half of a bit. This means we can read the
        //bit on the rising edge of the clock 
        input wire i_clkQ,  
        input wire i_ethernet
    );

    typedef enum {IDLE, SYNC, REC_HEADER, REC_HEADER_DONE, REC_PAYLOAD} ethernet_state /*verilator public*/;

    typedef enum {IP, UNK} ethernet_type /*verilator public*/;

    reg [1:0] bits;
    reg has_edge;

    ethernet_state state;


    reg [6:0] bitCounter;
    /* verilator lint_off UNUSED */
    reg [111:0] header; //MAC DST, MAC SRC, ETHERTYPE
    /* verilator lint_on UNUSED */

    always @(posedge i_clkQ) begin
        bits <= {bits[0], i_ethernet}; //shift bits lower
    end

    always @(negedge i_clkQ) begin
        if(state == REC_HEADER) begin
            bitCounter <= bitCounter + 1'b1;
        end
    end

    //triggering on negedge as that's the next edge of the clocks i_clkQ and
    //i_clk. 
    always @(negedge i_clk) begin
        has_edge <= bits[0] ^ bits[1];
        case(state)
            IDLE: begin
                if(has_edge) begin
                    state <= SYNC;
                end
            end
            SYNC: begin
                if(!has_edge) begin
                    state <= REC_HEADER;
                end
            end
            REC_HEADER: begin
                header[bitCounter] <= bits[0];
                if(bitCounter == 7'd111) begin
                    state <= REC_PAYLOAD;
                end
            end
            REC_PAYLOAD: begin
                state <= IDLE;
            end
        endcase
    end

endmodule
