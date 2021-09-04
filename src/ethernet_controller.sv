`timescale 1ns / 1ps
`default_nettype none

    /* this module acts as a controller for parsing layer 2 encodings of incoming and outgoing ethernet
    * packets, it gets decoded information from ethernet_rx in the form of 
    *   48' src_mac
    *   48' dst_mac
    *   16' ethertype
    *   
    *   and a stream of packet data, which then is given to the appropriate
    *   decoder module.  
    *
    *
    *
    *
    */
module ethernet_controller
    (
        input wire clk
    );

    

endmodule
