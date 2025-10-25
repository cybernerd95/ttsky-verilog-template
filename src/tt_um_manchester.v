/*
 * Copyright (c) 2025 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_cybernerd_manchester (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // All output pins must be assigned. If not used, assign to 0.
  wire data_out;
  wire encode_mode;
  wire [7:0] data_in;
  
  // Suppress lint warnings for unused signals
  wire _unused = &{ena, ui_in[7:1], 1'b0};
  
  // Map inputs
  assign encode_mode = ui_in[0];  // Use input bit 0 for encode_mode
  assign data_in = uio_in[7:0];   // Use bidirectional pins as inputs for data
  
  // Set bidirectional pins as inputs
  assign uio_oe = 8'b00000000;    // All bidirectional pins are inputs
  assign uio_out = 8'b00000000;   // Not used as outputs
  
  // Map output
  assign uo_out[0] = data_out;    // Manchester encoded output on bit 0
  assign uo_out[7:1] = 7'b0;      // Unused outputs set to 0
  
  // Instantiate the Manchester encoder - NOW WITH rst_n!
  manchester encoder (
      .clk(clk),
      .rst_n(rst_n),              // ← THIS WAS MISSING!
      .encode_mode(encode_mode),
      .data_in(data_in),
      .data_out(data_out)
  );

endmodule