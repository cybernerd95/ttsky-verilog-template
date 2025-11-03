module testbench;
reg clk;
reg mode;
reg [7:0] data_in;
wire [7:0] uo_out;
wire [7:0] uio_out;
wire [7:0] uio_oe;
wire [15:0] encoded_out;
assign encoded_out = {uo_out,uio_out};

tt_um_xyz_manchester uut(
    .ui_in(data_in),
    .uo_out(uo_out),
    .uio_in({7'b0,mode}),
    .uio_out(uio_out),
    .uio_oe(uio_oe),
    .ena(1'b1),
    .clk(clk),
    .rst_n(1'b1)
);

initial begin
clk=0;
forever #5 clk=~clk;
end

initial begin
mode=0;data_in=8'b10110010;#10;
mode=1;data_in=8'b10110010;#10;
mode=0;data_in=8'b11110000;#10;
mode=1;data_in=8'b11110000;#10;
mode=0;data_in=8'b00001111;#10;
mode=1;data_in=8'b00001111;#10;
$stop;
end
endmodule
