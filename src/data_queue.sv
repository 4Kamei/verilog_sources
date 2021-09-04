`timescale 1ns / 1ps
`default_nettype none


//dual-port queue for variable-width data
//

module data_queue
    #(
        parameter DATA_WIDTH,
        parameter QUEUE_DEPTH,
        parameter QUEUE_MAX_ELEMENTS
    )
    (
        input wire read_clk,
        input wire read_en,
        output wire [ELEMENT_WIDTH-1:0] o_data,
        output wire has_data,

        input wire write_clk,
        input wire write_en,
        input wire [ELEMENT_WIDTH-1:0] i_data,
        output wire queue_full,

        input wire reset;
    );



    localparam LENGTH_STORAGE_WIDTH = $clog2(MAX_ELEMENT_LENGTH)


    reg [LENGTH_STORAGE_WIDTH-1:0] write_data_length;
    reg write_length_strobe;

    reg [LENGTH_STORAGE_WIDTH-1:0] read_data_length;
    
    wire length_queue_full;

    dual_port_fifo #(
        .DATA_WIDTH(LENGTH_STORAGE_WIDTH),
        .FIFO_DEPTH(QUEUE_MAX_ELEMENTS))
        length_queue_fifo_inst (
        .reset(reset),
        //read signals
        .rd_clk(read_clk),
        .rd_en(1'b0),
        .rd_data(),
        .empty(),
        //write signals
        .wr_clk(write_clk),
        .wr_en(write_length_strobe),
        .wr_data(write_data_length),
        .full(length_queue_full));
        
    wire data_queue_full;

    dual_port_fifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .FIFO_DEPTH(QUEUE_DEPTH))
        data_queue_fifo_inst (
        .reset(reset),
        //read signals
        .rd_clk(read_clk),
        .rd_en(1'b0),
        .rd_data(o_data),
        .empty(),
        //write signals
        .wr_clk(write_clk),
        .wr_en(write_en),
        .wr_data(i_data),
        .full(data_queue_full));

    assign queue_full = data_queue_full | length_queue_full;

    reg reading_state;
    reg writing_state;
    
    always @(posedge write_clk) begin
        write_length_strobe <= 0;
        if(write_en) begin
            if(writing_state) begin
                write_data_length <= write_data_length + 1;
            end else begin
                write_data_length <= 0;
                writing_state <= 1;
            end
        end else begin
            if(writing_state) begin
                writing_state <= 0;
                write_length_strobe <= 1;
            end
        end
    end

    always @(posedge read_clk) begin
        //TODO reading logic 
    end


endmodule

