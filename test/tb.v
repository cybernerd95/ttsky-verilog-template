`timescale 1ns/1ps
module tb_manchester_system;
reg clk;
reg mode;
reg [7:0] data_in;
wire [15:0] encoded_out;
wire [7:0] decoded_out;

manchester_system uut(
.clk(clk),
.mode(mode),
.data_in(data_in),
.encoded_out(encoded_out),
.decoded_out(decoded_out)
);

initial begin
clk = 1;
forever #5 clk = ~clk;
end

initial begin
$display("Time\tMode\tData In\t\tEncoded Out\t\tDecoded Out");
$monitor("%0t\t%b\t%b\t%b\t%b", $time, mode, data_in, encoded_out, decoded_out);
mode = 0; data_in = 8'b10110010; #20;
mode = 1; data_in = 8'b10110010; #20;
mode = 0; data_in = 8'b11110000; #20;
mode = 1; data_in = 8'b11110000; #20;
mode = 0; data_in = 8'b10101010; #20;
mode = 1; data_in = 8'b10101010; #50;
$stop;
end
endmodule
