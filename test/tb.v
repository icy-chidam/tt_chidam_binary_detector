`default_nettype none
`timescale 1ns/1ps

module tb;

  reg [7:0] i;
  wire sym;
  wire [2:0] mismatch;

  // DUT instantiation
  symmetry_detector dut (
    .i(i),
    .out(sym),
    .mismatch_count(mismatch)
  );

  // Task for checking symmetry
  task check_case;
    input [7:0] in_val;
    reg expected_sym;
    reg [2:0] expected_mismatch;
    integer j;
    begin
      i = in_val;
      #1; // combinational propagation

      // Compute expected values
      expected_sym = 1'b1;
      expected_mismatch = 3'b0;
      for (j=0; j<4; j=j+1) begin
        if (in_val[j] !== in_val[7-j]) begin
          expected_sym = 1'b0;
          expected_mismatch = expected_mismatch + 1;
        end
      end

      // Display result
      if (sym !== expected_sym || mismatch !== expected_mismatch) begin
        $display("ERROR: Input=%b | Expected sym=%0d mismatch=%0d | Got sym=%0d mismatch=%0d",
                  in_val, expected_sym, expected_mismatch, sym, mismatch);
        $fatal;
      end else begin
        $display("PASS:  Input=%b | Sym=%0d Mismatch=%0d", in_val, sym, mismatch);
      end
    end
  endtask

  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);

    $display("Starting Symmetry Detector Test...");

    check_case(8'b10011001); // symmetric
    check_case(8'b01101001); // not symmetric
    check_case(8'b11111111); // symmetric
    check_case(8'b00000000); // symmetric
    check_case(8'b10101010); // not symmetric
    check_case(8'b11001100); // not symmetric
    check_case(8'b10000001); // symmetric

    $display("All test cases passed!");
    $finish;
  end

endmodule

