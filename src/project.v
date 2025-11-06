`timescale 1ns/1ps

module tt_um_xyz_manchester (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire ena,
    input  wire clk,
    input  wire rst_n
);

    // Internal wires
    wire mode;
    wire [7:0] data_in;
    wire [15:0] encoded;
    wire [7:0] decoded;

    assign mode    = ui_in[0];          // mode = ui_in[0]
    assign data_in = ui_in;             // use ui_in for data
    assign uo_out  = decoded;           // decoded output visible
    assign uio_out = encoded[7:0];      // lower 8 bits of encoded
    assign uio_oe  = 8'hFF;             // drive all uio_out pins

    // Instantiate the real logic
    manchester_system core (
        .clk(clk),
        .mode(mode),
        .data_in(data_in),
        .encoded_out(encoded),
        .decoded_out(decoded)
    );

endmodule
