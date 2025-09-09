`default_nettype none
`timescale 1ns/1ps

module tb;

    reg  [7:0] ui_in;
    wire [7:0] uo_out;
    reg  [7:0] uio_in;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;
    reg        ena;
    reg        clk;
    reg        rst_n;

    // DUT instantiation
    tt_um_symmetry_detector dut (
        .ui_in(ui_in),
        .uo_out(uo_out),
        .uio_in(uio_in),
        .uio_out(uio_out),
        .uio_oe(uio_oe),
        .ena(ena),
        .clk(clk),
        .rst_n(rst_n)
    );

    // Clock generation (10ns period)
    always #5 clk = ~clk;

    // Task for self-checking test cases
    task check_case(
        input [7:0] din,
        input expected_sym,
        input [2:0] expected_mismatch
    );
    begin
        ui_in = din;
        #20; // wait for DUT to process

        if (uo_out[0] !== expected_sym || uo_out[3:1] !== expected_mismatch) begin
            $display("❌ ERROR: Input=%b | Expected sym=%b mismatch=%0d | Got sym=%b mismatch=%0d",
                     din, expected_sym, expected_mismatch,
                     uo_out[0], uo_out[3:1]);
            $fatal; // Fail immediately
        end else begin
            $display("✅ PASS: Input=%b | Sym=%b, Mismatch=%0d",
                     din, uo_out[0], uo_out[3:1]);
        end
    end
    endtask

    initial begin
        // Dump VCD
        $dumpfile("tb.vcd");
        $dumpvars(0, tb);

        // Init signals
        clk = 0;
        ena = 1;
        uio_in = 0;
        ui_in = 0;
        rst_n = 0;

        // Apply reset
        #20 rst_n = 1;

        // Test cases
        check_case(8'b10011001, 1, 3'b000); // symmetric
        check_case(8'b10100101, 1, 3'b000); // symmetric
        check_case(8'b11001010, 0, 3'b010); // not symmetric
        check_case(8'b11111111, 1, 3'b000); // all ones symmetric
        check_case(8'b01101001, 0, 3'b011); // not symmetric

        $display("🎉 All test cases passed!");
        $finish;
    end

endmodule
