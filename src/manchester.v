module manchester(
input clk,
input mode,
input [7:0] data_in,
output reg [15:0] encoded_out
);
reg [15:0] ieee_encoded;
reg [15:0] thomas_encoded;
integer i;
always @(posedge clk) begin
    ieee_encoded = 16'b0;
    thomas_encoded = 16'b0;
    for (i = 0; i < 8; i = i + 1) begin
        // explicit bit addressing for Yosys compatibility
        ieee_encoded[15 - 2*i]     = (data_in[7 - i]) ? 1'b1 : 1'b0;
        ieee_encoded[15 - 2*i - 1] = (data_in[7 - i]) ? 1'b0 : 1'b1;

        thomas_encoded[15 - 2*i]     = (data_in[7 - i]) ? 1'b0 : 1'b1;
        thomas_encoded[15 - 2*i - 1] = (data_in[7 - i]) ? 1'b1 : 1'b0;
    end
end
always @(posedge clk) begin
    if (mode == 1'b0)
        encoded_out <= ieee_encoded;
    else
        encoded_out <= thomas_encoded;
end
endmodule
