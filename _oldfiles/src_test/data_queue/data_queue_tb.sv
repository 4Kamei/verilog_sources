`timescale 1ns / 1ps
`default_nettype none

module data_queue_tb
    #(
        parameter DATA_WIDTH = 8,
        parameter QUEUE_DEPTH = 12'd4095,
        parameter QUEUE_MAX_ELEMENTS = 5'd31,
        parameter MAX_ELEMENT_LENGTH = 11'd2047
    )
    (
        input wire i_read_clk,
        input wire i_read_en,
        output wire [DATA_WIDTH-1:0] o_data,
        output wire o_has_data,
        output wire o_queue_empty,

        input wire i_write_clk,
        input wire i_write_en,
        input wire [DATA_WIDTH-1:0] i_data,
        output wire o_queue_full,

        input wire i_reset

    );

    initial begin
        $dumpfile("data_queue_tb.vcd");          
        $dumpvars(0, data_queue_tb);
    end

    data_queue #(
        .DATA_WIDTH(DATA_WIDTH),
        .QUEUE_DEPTH(QUEUE_DEPTH),
        .QUEUE_MAX_ELEMENTS(QUEUE_MAX_ELEMENTS),
        .MAX_ELEMENT_LENGTH(MAX_ELEMENT_LENGTH))
        data_queue_inst(
            .read_clk(i_read_clk),
            .read_en(i_read_en),
            .o_data(o_data),
            .has_data(o_has_data),
            .queue_empty(o_queue_empty),
            .write_clk(i_write_clk),
            .write_en(i_write_en),
            .i_data(i_data),
            .queue_full(o_queue_full),
            .reset(i_reset));


endmodule
