module manchester_system(
input clk,
input mode,
input [7:0] data_in,
output reg [15:0] encoded_out,
output reg [7:0] decoded_out
);
reg [15:0] ieee_encoded;
reg [15:0] thomas_encoded;
integer i;
always @(*) begin
ieee_encoded = 16'b0;
thomas_encoded = 16'b0;
for (i = 0; i < 8; i = i + 1) begin
if (data_in[7 - i]) begin
ieee_encoded[15 - (2*i)] = 1'b1;
ieee_encoded[15 - (2*i) - 1] = 1'b0;
thomas_encoded[15 - (2*i)] = 1'b0;
thomas_encoded[15 - (2*i) - 1] = 1'b1;
end else begin
ieee_encoded[15 - (2*i)] = 1'b0;
ieee_encoded[15 - (2*i) - 1] = 1'b1;
thomas_encoded[15 - (2*i)] = 1'b1;
thomas_encoded[15 - (2*i) - 1] = 1'b0;
end
end
end
always @(posedge clk) begin
if (mode == 1'b0)
encoded_out <= ieee_encoded;
else
encoded_out <= thomas_encoded;
end
always @(*) begin
for (i = 0; i < 8; i = i + 1) begin
if (mode == 1'b0) begin
if (encoded_out[15 - (2*i)] == 1'b1 && encoded_out[15 - (2*i) - 1] == 1'b0)
decoded_out[7 - i] = 1'b1;
else
decoded_out[7 - i] = 1'b0;
end else begin
if (encoded_out[15 - (2*i)] == 1'b0 && encoded_out[15 - (2*i) - 1] == 1'b1)
decoded_out[7 - i] = 1'b1;
else
decoded_out[7 - i] = 1'b0;
end
end
end
endmodule
