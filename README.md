![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/test/badge.svg) ![](../../workflows/fpga/badge.svg)

# Symmetry Detector for 8-bit Binary Numbers

## Project Overview
This project implements a symmetry detector for 8-bit binary numbers using Verilog HDL. The symmetry detector checks whether the input 8-bit number is symmetric around its center, meaning the bits at symmetric positions from the ends match. The module also counts the number of bit mismatches that break the symmetry.

The checker compares corresponding bits from the start and end of the input (bit 0 with bit 7, bit 1 with bit 6, etc.) using XOR gates. If all pairs match, the number is symmetric; otherwise, it is not. The mismatch count reports how many pairs do not match.

## Files
- symmetry_detector.v: The main Verilog module defining the symmetry detection logic.
- symmetry_detector_tb.v: Testbench to simulate and verify the symmetry detector functionality.
- Simulation output showing test results for various 8-bit numbers including symmetric and non-symmetric cases.

## How It Works
- The input is an 8-bit vector.
- XOR gates compare pairs of bits from both ends (i[0] vs i[7], i[1] vs i[6], etc.).
- The resulting mismatch bits are summed to yield the mismatch count.
- An AND gate combines the complementary mismatch bits to produce a single output flag indicating symmetry (1 if symmetric, 0 otherwise).
- The testbench runs multiple examples and displays whether each number is symmetric along with the mismatch count.

## Sample Bit Comparison Table

| Bit Position | Bit Compared Pair | Match (0=match, 1=mismatch) |
|--------------|-------------------|-----------------------------|
| 0 and 7      | i[0] vs i[7]      | w[0] (XOR result)           |
| 1 and 6      | i[1] vs i[6]      | w[1] (XOR result)           |
| 2 and 5      | i[2] vs i[5]      | w[2] (XOR result)           |
| 3 and 4      | i[3] vs i[4]      | w[3] (XOR result)           |

## Example Symmetry Detection Results

| Input (8-bit) | Symmetric? | Number of Bits Mismatched |
|---------------|------------|---------------------------|
| 00000000      | Yes        | 0                         |
| 11010011      | No         | 1                         |
| 11000011      | Yes        | 0                         |
| 10010110      | No         | 4                         |
| 11111111      | Yes        | 0                         |

## Applications
- *Digital Signal Processing:* Detect symmetric bit patterns or palindromic bit sequences in data streams.
- *Error Detection:* Identify data integrity issues where symmetric properties are expected.
- *Pattern Recognition:* Useful in hardware accelerators that process symmetric or palindromic codes.
- *Data Compression:* Detect symmetrical patterns to optimize storage.
- *Computer Graphics & Imaging:* Check symmetric patterns in pixel data or image processing hardware.

## Usage
- Compile the Verilog code using a compatible simulator (e.g., Xcelium).
- Run the testbench to verify functionality.
- Integrate the symmetry detector module into larger digital systems where symmetric bit detection is required.

---

This project demonstrates simple combinational logic implementation for bit-level pattern detection and is useful for learning Verilog HDL, simulation, and digital circuit design.
