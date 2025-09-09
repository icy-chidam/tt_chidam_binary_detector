/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_symmetry_detector (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // Internal wires
  wire symmetry_out;
  wire [2:0] mismatch_count;
  
  // Instantiate the symmetry detector
  symmetry_detector sym_det (
    .out(symmetry_out),
    .mismatch_count(mismatch_count),
    .i(ui_in)
  );
  
  // Assign outputs
  assign uo_out = {4'b0, mismatch_count, symmetry_out};  // [7:4] = 0, [2:0] = mismatch_count, [0] = symmetry_out
  assign uio_out = 0;
  assign uio_oe = 0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, uio_in, 1'b0};

endmodule

// Symmetry detector module
module symmetry_detector(out, mismatch_count, i);
  output out;
  output [2:0] mismatch_count;
  input [7:0] i;
  wire [5:0] w;
 
  xor x1(w[0], i[0], i[7]);
  xor x2(w[1], i[1], i[6]);
  xor x3(w[2], i[2], i[5]);
  xor x4(w[3], i[3], i[4]);
  and a1(w[4], ~w[0], ~w[1]);
  and a2(w[5], ~w[2], ~w[3]);
  and a3(out, w[4], w[5]);
  
  assign mismatch_count = w[0] + w[1] + w[2] + w[3];
  
endmodule
