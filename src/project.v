/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_symmetry_detector (
    input  wire [7:0] ui_in,    // dedicated inputs
    output wire [7:0] uo_out,   // dedicated outputs
    input  wire [7:0] uio_in,   // bidirectional inputs (unused)
    output wire [7:0] uio_out,  // bidirectional outputs (unused)
    output wire [7:0] uio_oe,   // bidirectional enables (unused)
    input  wire       clk,
    input  wire       rst_n
);

    // Map control + data
    wire        load    = ui_in[0];   // LSB = load pulse
    wire [7:0]  data_in = ui_in;      // use all 8 bits as input word

    wire symmetry, done, busy;

    // Instantiate core
    trial_symmetry_detector #(
        .N(8)
    ) core (
        .clk(clk),
        .rst_n(rst_n),
        .load(load),
        .data_in(data_in),
        .symmetry(symmetry),
        .done(done),
        .busy(busy)
    );

    // Map outputs
    assign uo_out[0]   = symmetry;
    assign uo_out[1]   = done;
    assign uo_out[2]   = busy;
    assign uo_out[7:3] = 5'b00000; // unused

    assign uio_out = 8'b00000000; // no bidir used
    assign uio_oe  = 8'b00000000;

endmodule
