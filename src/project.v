`timescale 1ns/1ps
`default_nettype none

module tt_um_xyz_manchester (
    input  wire [7:0] ui_in,    // 8-bit input data
    output wire [7:0] uo_out,   // upper 8 bits of encoded output
    input  wire [7:0] uio_in,   // bidirectional (mode input on bit 0)
    output wire [7:0] uio_out,  // lower 8 bits of encoded output
    output wire [7:0] uio_oe,   // enable for outputs
    input  wire ena,            // enable
    input  wire clk,            // clock
    input  wire rst_n           // reset (active low)
);

    // mode select (0 = IEEE, 1 = Thomas)
    wire mode = uio_in[0];
    wire [15:0] encoded;

    manchester encoder (
        .clk(clk),
        .rst_n(rst_n),
        .mode(mode),
        .data_in(ui_in),
        .encoded_out(encoded)
    );

    // Split 16-bit output across 8-bit TT IOs
    assign uo_out  = encoded[15:8];
    assign uio_out = encoded[7:0];
    assign uio_oe  = 8'hFF; // drive all uio_out bits

endmodule

`default_nettype wire
