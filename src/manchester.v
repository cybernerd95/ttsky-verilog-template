<<<<<<< HEAD
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
ieee_encoded=16'b0;
thomas_encoded=16'b0;
for(i=0;i<8;i=i+1) begin
ieee_encoded[(15-2*i)-:2]=(data_in[7-i])?2'b10:2'b01;
thomas_encoded[(15-2*i)-:2]=(data_in[7-i])?2'b01:2'b10;
end
end
always @(posedge clk) begin
if(mode==1'b0)
encoded_out<=ieee_encoded;
else
encoded_out<=thomas_encoded;
end
endmodule
=======
`default_nettype none

module manchester(
    input wire clk,
    input wire rst_n,
    input wire encode_mode,
    input wire [7:0] data_in,
    output reg data_out
);

    reg [2:0] bit_index;
    reg phase;

    always @(posedge clk) begin
        if (!rst_n) begin
            bit_index <= 3'd0;
            phase <= 1'b0;
            data_out <= 1'b0;
        end else begin
            if (phase == 1'b0) begin
                // First half of bit period
                if (encode_mode == 1'b0) begin
                    data_out <= data_in[bit_index];
                end else begin
                    data_out <= ~data_in[bit_index];
                end
                phase <= 1'b1;
            end else begin
                // Second half - transition
                data_out <= ~data_out;
                phase <= 1'b0;
                
                if (bit_index == 3'd7)
                    bit_index <= 3'd0;
                else
                    bit_index <= bit_index + 3'd1;
            end
        end
    end

endmodule
>>>>>>> 9bb86036635bd36d153be892ff2965545f2126ea
