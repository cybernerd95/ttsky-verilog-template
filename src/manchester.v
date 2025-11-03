`timescale 1ns/1ps
`default_nettype none

module manchester (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        mode,          // 0=IEEE, 1=Thomas
    input  wire [7:0]  data_in,
    output reg  [15:0] encoded_out
);

    integer i;
    reg [15:0] ieee_encoded;
    reg [15:0] thomas_encoded;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            encoded_out <= 16'b0;
        end else begin
            ieee_encoded   = 16'b0;
            thomas_encoded = 16'b0;

            // Bit-by-bit encoding
            for (i = 0; i < 8; i = i + 1) begin
                if (data_in[7 - i]) begin
                    // Bit = 1
                    ieee_encoded[(15 - 2*i) -: 2]   = 2'b10; // IEEE: high->low
                    thomas_encoded[(15 - 2*i) -: 2] = 2'b01; // Thomas: low->high
                end else begin
                    // Bit = 0
                    ieee_encoded[(15 - 2*i) -: 2]   = 2'b01;
                    thomas_encoded[(15 - 2*i) -: 2] = 2'b10;
                end
            end

            // Choose encoding mode
            if (mode == 1'b0)
                encoded_out <= ieee_encoded;
            else
                encoded_out <= thomas_encoded;

        end
    end

endmodule

`default_nettype wire
