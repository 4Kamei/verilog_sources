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

    typedef enum [2:0] {IDLE, SYNC, REC_DSTMAC, REC_SRCMAC, REC_ETHERTYPE, PAYLOAD} ethernet_state /*verilator public*/;

    reg [1:0] bits;
    reg has_edge;


    ethernet_state state;

    reg [15:0] bitCounter;
    reg [47:0] dst_mac_brev;
    reg [47:0] src_mac_brev;

    /* verilator lint_off UNUSED */
    
    reg [15:0] ethertype_brev; 

    wire [47:0] dst_mac;
    wire [47:0] src_mac;

    wire has_edge;
    assign has_edge = bits[0] ^ bits[1];

    //reverse the order of the bytes for both destination and source mac

    assign dst_mac = {dst_mac_brev[ 7:0], 
                      dst_mac_brev[15:8],
                      dst_mac_brev[23:16],
                      dst_mac_brev[31:24],
                      dst_mac_brev[39:32],
                      dst_mac_brev[47:40]};

    assign src_mac = {src_mac_brev[ 7:0], 
                      src_mac_brev[15:8],
                      src_mac_brev[23:16],
                      src_mac_brev[31:24],
                      src_mac_brev[39:32],
                      src_mac_brev[47:40]}; 

    /* verilator lint_on UNUSED */
    
    //used for ip packet handling


    always @(posedge i_clkQ) begin
        bits <= {bits[0], i_ethernet}; //shift bits lower
    end

    //triggering on negedge as that's the next edge of the clocks i_clkQ and
    //i_clk. 
    always @(negedge i_clk) begin

        if(state != IDLE & state != SYNC) begin
            bitCounter <= bitCounter + 1; //increment bit counter whenever a new bit comes in, 
        end
        case(state)
            IDLE: begin
                if(has_edge) begin
                    state <= SYNC;
                end
            end
            SYNC: begin
                if(!has_edge) begin
                    state <= REC_DSTMAC;
                    bitCounter <= 0; 

                end
            end
            REC_DSTMAC: begin
                dst_mac_brev[bitCounter[5:0]] <= bits[0];
                if(bitCounter == 16'd47) begin
                    state <= REC_SRCMAC;
                    bitCounter <= 0;
                end
            end
            REC_SRCMAC: begin
                src_mac_brev[bitCounter[5:0]] <= bits[0];
                if(bitCounter == 16'd47) begin
                    state <= REC_ETHERTYPE;
                    bitCounter <= 0;
                end
            end
            REC_ETHERTYPE: begin
                ethertype_brev[bitCounter[3:0]] <= bits[0];
                if(bitCounter == 16'd15) begin
                    state <= PAYLOAD;
                    bitCounter <= 0;
                end
            end
            PAYLOAD: begin
                //payload is storted and forwarded to the controller 
            end
            default: assert(0);
        endcase
    end

endmodule
