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