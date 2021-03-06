`timescale 1ns / 1ps
`default_nettype none

module dual_port_fifo
    #(
        parameter DATA_WIDTH = 16,
        parameter FIFO_DEPTH = 32
    )(
        input wire wr_clk,
        input wire wr_en,
        input wire [DATA_WIDTH - 1: 0] wr_data,
        output reg full,

        input wire rd_clk,
        input wire rd_en,
        output reg [DATA_WIDTH - 1: 0] rd_data,
        output wire empty,

        input wire reset
    );

    localparam POINTER_WIDTH = $clog2(FIFO_DEPTH);

    logic [DATA_WIDTH - 1: 0] fifo_data [FIFO_DEPTH - 1: 0];

    //READ CLOCK DOMAIN
    logic [POINTER_WIDTH:0] rd_pointer_binary;
    logic [POINTER_WIDTH:0] rd_pointer_gray;   
    logic [POINTER_WIDTH:0] rd_pointer_gray_incremented;   
    logic [POINTER_WIDTH:0] rdcdc_wr_pointer_gray;

    gray2bin #(.BINARY_WIDTH(POINTER_WIDTH + 1))
        rd_side_g2b(.gray(rd_pointer_gray), .binary(rd_pointer_binary));
    
    bin2gray #(.BINARY_WIDTH(POINTER_WIDTH + 1))
        rd_side_b2g(.gray(rd_pointer_gray_incremented), .binary(rd_pointer_binary + 1'b1));
    
        
    assign empty = rdcdc_wr_pointer_gray == rd_pointer_gray;

    always @(*) begin
        rd_data <= fifo_data[rd_pointer_binary[POINTER_WIDTH-1:0]];
    end

    always @(posedge rd_clk) begin
        //CDC of wr pointer
        rdcdc_wr_pointer_gray <= wr_pointer_gray;
        if(reset) begin
            rd_pointer_gray <= 0;
        end else begin
            if(rd_en & ~empty) begin
                rd_pointer_gray = rd_pointer_gray_incremented;
            end
        end
    end

    ///WRITE CLOCK DOMAIN
    logic [POINTER_WIDTH:0] wr_pointer_binary;
    logic [POINTER_WIDTH:0] wr_pointer_gray;   
    logic [POINTER_WIDTH:0] wr_pointer_gray_incremented;   
    logic [POINTER_WIDTH:0] wrcdc_rd_pointer_gray;
    logic [POINTER_WIDTH:0] wrcdc_rd_pointer_binary;
    
    gray2bin #(.BINARY_WIDTH(POINTER_WIDTH + 1))
        wr_side_g2b(.gray(wr_pointer_gray), .binary(wr_pointer_binary));
    
    bin2gray #(.BINARY_WIDTH(POINTER_WIDTH + 1))
        wr_side_b2g(.gray(wr_pointer_gray_incremented), .binary(wr_pointer_binary + 1'b1));

    gray2bin #(.BINARY_WIDTH(POINTER_WIDTH + 1))
        wr_side_pointer_g2b(.gray(wrcdc_rd_pointer_gray), .binary(wrcdc_rd_pointer_binary));
    
    assign full = wrcdc_rd_pointer_binary == {~wr_pointer_binary[POINTER_WIDTH], wr_pointer_binary[POINTER_WIDTH - 1:0]};

    always @(posedge wr_clk) begin
        wrcdc_rd_pointer_gray <= rd_pointer_gray;
        if(reset) begin
            wr_pointer_gray <= 0;
        end else begin
            if(wr_en & ~full) begin
                fifo_data[wr_pointer_binary[POINTER_WIDTH-1:0]] <= wr_data;
                wr_pointer_gray <= wr_pointer_gray_incremented;
            end
        end
    end
endmodule
