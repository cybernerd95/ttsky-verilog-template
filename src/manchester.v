module manchester(
    input wire clk,
    input wire encode_mode,
    input wire [7:0] data_in,
    output reg data_out
);

reg [2:0] bit_index;
reg phase; // 0 = first half of bit period, 1 = second half

initial begin
    bit_index = 0;
    phase = 0;
    data_out = 0;
end

always @(posedge clk) begin
    if (phase == 0) begin
        // First half of Manchester bit period
        if (encode_mode == 0) begin
            // Manchester encoding (IEEE 802.3): 0 = high-to-low, 1 = low-to-high
            data_out <= data_in[bit_index];
        end else begin
            // Inverse Manchester: 0 = low-to-high, 1 = high-to-low
            data_out <= ~data_in[bit_index];
        end
        phase <= 1;
    end else begin
        // Second half of Manchester bit period (transition)
        data_out <= ~data_out;
        phase <= 0;
        
        // Move to next bit after completing full bit period
        if (bit_index == 7)
            bit_index <= 0;
        else
            bit_index <= bit_index + 1;
    end
end

endmodule