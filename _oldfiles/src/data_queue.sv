`timescale 1ns / 1ps
`default_nettype none


//dual-port queue for variable-width data
//

module data_queue
    #(
        parameter DATA_WIDTH = 8,
        parameter QUEUE_DEPTH = 12'd4095,
        parameter QUEUE_MAX_ELEMENTS = 5'd31,
        parameter MAX_ELEMENT_LENGTH = 11'd2047
    )
    (
        input wire read_clk,
        input wire read_en,
        output wire [DATA_WIDTH-1:0] o_data,
        output wire has_data,
        output wire queue_empty,

        input wire write_clk,
        input wire write_en,
        input wire [DATA_WIDTH-1:0] i_data,
        output wire queue_full,

        input wire i_reset 
    );


    localparam LEN_STOR_W= $clog2(MAX_ELEMENT_LENGTH);


    reg [LEN_STOR_W-1:0] write_data_length;
    reg write_length_strobe;

    
    wire [LEN_STOR_W-1:0] read_data_length;
    reg [LEN_STOR_W-1:0] read_data_length_reg;

    reg read_length_strobe;

    wire length_queue_full;

    dual_port_fifo #(
        .DATA_WIDTH(LEN_STOR_W),
        .FIFO_DEPTH(QUEUE_MAX_ELEMENTS))
        length_queue_fifo_inst (
        .reset(reset),
        //read signals
        .rd_clk(read_clk),
        .rd_en(read_length_strobe),
        .rd_data(read_data_length),
        //unused, as should be synchronised to the data fifo
        .empty(),
        //write signals
        .wr_clk(write_clk),
        .wr_en(write_length_strobe),
        .wr_data(write_data_length),
        .full(length_queue_full));
        
    wire data_queue_full;

    reg read_data_enable;

    dual_port_fifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .FIFO_DEPTH(QUEUE_DEPTH))
        data_queue_fifo_inst (
        .reset(reset),
        //read signals
        .rd_clk(read_clk),
        .rd_en(read_data_enable),
        .rd_data(o_data),
        .empty(queue_empty),
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
                write_data_length <= write_data_length + 1'b1;
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
        read_length_strobe <= 0;
        read_data_enable <= 0;
        if(read_en) begin
            if(reading_state) begin
                read_data_enable <= 1;
                read_data_length_reg <= read_data_length_reg - 1'b1;
            end else begin
                read_data_length_reg <= read_data_length;
                read_length_strobe <= 1;
            end 
        end else begin
            if(reading_state & read_data_length_reg == 0) begin
                reading_state <= 0;
            end
        end
    end


endmodule

