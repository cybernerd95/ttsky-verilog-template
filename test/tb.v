module testbench;
reg clk;
reg mode;
reg [7:0] data_in;
wire [7:0] uo_out;
wire [7:0] uio_out;
wire [7:0] uio_oe;
wire [15:0] encoded_out;
assign encoded_out = {uo_out,uio_out};

<<<<<<< HEAD
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
=======
/* This testbench just instantiates the module and makes some convenient wires
   that can be driven / tested by the cocotb test.py.
*/
module tb;

  // Dump the signals to a VCD file. You can view it with gtkwave.
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #1;
  end

  // Wire up the inputs and outputs:
  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

  // Instantiate the DUT (Device Under Test)
  tt_um_cybernerd_manchester tt_um_manchester (
      // Include power ports for GL test:
`ifdef GL_TEST
      .VPWR(1'b1),
      .VGND(1'b0),
`endif
      .ui_in  (ui_in),    // Dedicated inputs
      .uo_out (uo_out),   // Dedicated outputs
      .uio_in (uio_in),   // IOs: Input path
      .uio_out(uio_out),  // IOs: Output path
      .uio_oe (uio_oe),   // IOs: Enable path (active high: 0=input, 1=output)
      .ena    (ena),      // Enable - goes high when design is selected
      .clk    (clk),      // Clock
      .rst_n  (rst_n)     // Active low reset
  );

endmodule
>>>>>>> 9bb86036635bd36d153be892ff2965545f2126ea
