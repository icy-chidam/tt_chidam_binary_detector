/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_chidam_symmetry_detector(out,i);
  output out;
  input [7:0]i;
  wire [5:0]w;
 
  xor x1(w[0],i[0],i[7]);
  xor x2(w[1],i[1],i[6]);
  xor x3(w[2],i[2],i[5]);
  xor x4(w[3],i[3],i[4]);
  and a1(w[4],~w[0],~w[1]);
  and a2(w[5],~w[2],~w[3]);
  and a3(out,w[4],w[5]);
  
endmodule
