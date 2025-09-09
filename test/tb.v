`default_nettype none
`timescale 1ns/1ps

module tb;

  reg [7:0] i;
  wire sym;
  wire [2:0] mismatch_count; // MUST connect this output

  // DUT instantiation
  symmetry_detector dut (
    .i(i),
    .out(sym),
    .mismatch_count(mismatch_count) // connect all outputs
  );

  // Task for checking symmetry
  task check_case;
    input [7:0] in_val;
    reg expected_sym;
    integer j;
    begin
      i = in_val;
      #10; // wait for propagation

      // Compute expected symmetry
      expected_sym = 1'b1;
      for (j=0; j<4; j=j+1) begin
        if (in_val[j] !== in_val[7-j]) begin
          expected_sym = 1'b0;
        end
      end

      // Display result
      if (sym !== expected_sym) begin
        $display("ERROR: Input=%b | Expected sym=%0d | Got sym=%0d | Mismatch=%0d", in_val, expected_sym, sym, mismatch_count);
        $fatal;
      end else begin
        $display("PASS:  Input=%b | Sym=%0d | Mismatch=%0d", in_val, sym, mismatch_count);
      end
    end
  endtask

  // Test sequence
  initial begin
    $display("Starting Symmetry Detector Test...");

    check_case(8'b10011001); // symmetric → should PASS
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

