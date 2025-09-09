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
    input  wire       ena,      // ignore
    input  wire       clk,      // ignore
    input  wire       rst_n     // ignore
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
  assign uo_out = {4'b0, mismatch_count, symmetry_out};  // [7:4]=0, [3:1]=mismatch_count, [0]=symmetry_out
  assign uio_out = 8'b0;
  assign uio_oe  = 8'b0;

  // Prevent warnings
  wire _unused = &{ena, clk, rst_n, uio_in, 1'b0};

endmodule


// Fully combinational symmetry detector
module symmetry_detector(
    output out,
    output [2:0] mismatch_count,
    input  [7:0] i
);

  wire w0, w1, w2, w3;
  wire a0, a1;

  // XOR each mirrored bit pair
  assign w0 = i[0] ^ i[7];
  assign w1 = i[1] ^ i[6];
  assign w2 = i[2] ^ i[5];
  assign w3 = i[3] ^ i[4];

  // AND to check symmetry
  assign a0 = ~w0 & ~w1;
  assign a1 = ~w2 & ~w3;
  assign out = a0 & a1;

  // Count mismatches
  assign mismatch_count = w0 + w1 + w2 + w3;

endmodule

