`timescale 1ns / 1ps
`default_nettype none

module dual_port_fifo
    #(
        parameter DATA_WIDTH = 16,
        parameter FIFO_DEPTH = 31
    )(
        input wire wr_clk,
        input wire wr_en,
        input wire [DATA_WIDTH - 1: 0] wr_data,
        output wire full,

        input wire rd_clk,
        output wire rd_en,
        output reg [DATA_WIDTH - 1: 0] rd_data,
        output wire empty,

        input wire reset;
    
    )

    logic [DATA_WIDTH - 1:0] fifo_data [FIFO_DEPTH - 1: 0];

    logic [DATA_WIDTH - 1:0] tmp_write;


    //the address of the next element to write in
    logic [$clog2(FIFO_DEPTH + 1) - 1:0] read_pointer;

    logic [$clog2(FIFO_DEPTH + 1) - 1:0] write_pointer;

    always @(posedge rd_clk) begin
        if(rd_en) begin
            wr_data <= fifo_data[read_pointer];
            read_pointer <= read_pointer + 1'b1;
        end
    end

    always @(posedge wr_clk) begin
        if(wr_en) begin
            fifo_data[write_pointer] <= wr_data;
            write_pointer <= write_pointer + 1'b1;
        end
    end

endmodule
