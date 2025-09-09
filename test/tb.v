`default_nettype none
`timescale 1ns / 1ps

/* This testbench just instantiates the module and makes some convenient wires
   that can be driven / tested by the cocotb test.py.
*/
module tb ();

  // Dump the signals to a VCD file. You can view it with gtkwave or surfer.
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
`ifdef GL_TEST
  wire VPWR = 1'b1;
  wire VGND = 1'b0;
`endif

  // Replace tt_um_example with your module name:
  tt_um_symmetry_detector user_project (

      // Include power ports for the Gate Level test:
`ifdef GL_TEST
      .VPWR(VPWR),
      .VGND(VGND),
`endif

      .ui_in  (ui_in),    // Dedicated inputs
      .uo_out (uo_out),   // Dedicated outputs
      .uio_in (uio_in),   // IOs: Input path
      .uio_out(uio_out),  // IOs: Output path
      .uio_oe (uio_oe),   // IOs: Enable path (active high: 0=input, 1=output)
      .ena    (ena),      // enable - goes high when design is selected
      .clk    (clk),      // clock
      .rst_n  (rst_n)     // not reset
  );

  // Testbench stimulus
  initial begin
    // Initialize inputs
    clk = 0;
    rst_n = 0;
    ena = 1;
    ui_in = 8'b0;
    uio_in = 8'b0;
    
    // Release reset after a few cycles
    #20 rst_n = 1;
    
    // Run test cases
    #10 ui_in = 8'b00000000;
    sym;
    
    ui_in = 8'b11010011;
    sym;
    
    ui_in = 8'b11000011;
    sym;
    
    ui_in = 8'b10010110;
    sym;
    
    ui_in = 8'b11111111;
    sym;
  end
    
  task sym;
    #10;
    if (uo_out[0])
      $display("The number %0b is symmetric", ui_in);
    else 
      $display("The number %0b is not symmetric", ui_in);
    
    $display("Number of bits mismatched = %0d", uo_out[3:1]);
    $display("---");
  endtask

endmodule

