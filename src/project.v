`timescale 1ns/1ps

module tt_um_xyz_manchester (
    input  wire clk,
    input  wire rst_n,
    input  wire [7:0] ui_in,    // data_in
    output wire [7:0] uo_out,   // decoded_out
    input  wire [7:0] uio_in,   // uio_in[0] = mode
    output wire [7:0] uio_out,  // lower byte of encoded_out
    output wire [7:0] uio_oe    // output enable (all 1's for outputs)
);

wire [15:0] encoded_out;
wire [7:0] decoded_out;
wire mode = uio_in[0];

manchester_system core (
    .clk(clk),
    .mode(mode),
    .data_in(ui_in),
    .encoded_out(encoded_out),
    .decoded_out(decoded_out)
);

assign uo_out  = decoded_out;
assign uio_out = encoded_out[7:0];
assign uio_oe  = 8'hFF; // enable all outputs

endmodule
