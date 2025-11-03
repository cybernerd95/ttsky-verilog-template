`timescale 1ns / 1ps

module tt_um_xyz_manchester(
    input  [7:0] ui_in,
    output [7:0] uo_out,
    input  [7:0] uio_in,
    output [7:0] uio_out,
    output [7:0] uio_oe,
    input  ena,
    input  clk,
    input  rst_n
);
wire [7:0] data_in = ui_in;
wire mode = uio_in[0];
wire [15:0] encoded_out;

assign uo_out = encoded_out[15:8];
assign uio_out = encoded_out[7:0];
assign uio_oe = 8'hFF;

manchester uut(
    .clk(clk),
    .mode(mode),
    .data_in(data_in),
    .encoded_out(encoded_out)
);
endmodule