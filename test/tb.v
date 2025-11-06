`timescale 1ns/1ps

module tb;
    reg clk = 0;
    reg [7:0] ui_in;
    reg [7:0] uio_in;
    reg ena = 1;
    reg rst_n = 1;
    wire [7:0] uo_out;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;

    tt_um_xyz_manchester dut (
        .ui_in(ui_in),
        .uo_out(uo_out),
        .uio_in(uio_in),
        .uio_out(uio_out),
        .uio_oe(uio_oe),
        .ena(ena),
        .clk(clk),
        .rst_n(rst_n)
    );

    always #5 clk = ~clk;

    initial begin
        ui_in = 8'b10110010; #20;
        ui_in = 8'b11110000; #20;
        ui_in = 8'b10101010; #20;
        $stop;
    end
endmodule
