/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_symmetry_detector (
    input  wire [7:0] ui_in,    // 8 input pins
    output wire [7:0] uo_out,   // 8 output pins
    input  wire [7:0] uio_in,   // unused
    output wire [7:0] uio_out,  // unused
    output wire [7:0] uio_oe,   // unused
    input  wire       ena,      // enable (active high)
    input  wire       clk,      // clock (not used here)
    input  wire       rst_n     // reset (not used here)
);

    wire [5:0] w;

    xor x1(w[0], ui_in[0], ui_in[7]);
    xor x2(w[1], ui_in[1], ui_in[6]);
    xor x3(w[2], ui_in[2], ui_in[5]);
    xor x4(w[3], ui_in[3], ui_in[4]);

    and a1(w[4], ~w[0], ~w[1]);
    and a2(w[5], ~w[2], ~w[3]);

    // Output only on uo_out[0], rest zero
    assign uo_out = {7'b0, (w[4] & w[5])};

    // Unused I/O
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
