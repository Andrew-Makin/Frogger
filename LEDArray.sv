module LEDArray(RST, r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15,
							g0, g1, g2, g3, g4, g5, g6, g7, g8, g9, g10, g11, g12, g13, g14, g15,
				         red, green);
	input logic RST;
	input logic [15:0] r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15,
							 g0, g1, g2, g3, g4, g5, g6, g7, g8, g9, g10, g11, g12, g13, g14, g15;
	output reg  [15:0][15:0] red;
	output reg  [15:0][15:0] green;
	
	always_comb
		if (RST) begin
			red = '0;
			green = '0;
			end
			
		else begin
			red[00] = r15;
			red[01] = r14;
			red[02] = r13;
			red[03] = r12;
			red[04] = r11;
			red[05] = r10;
			red[06] = r9;
			red[07] = r8;
			red[08] = r7;
			red[09] = r6;
			red[10] = r5;
			red[11] = r4;
			red[12] = r3;
			red[13] = r2;
			red[14] = r1;
			red[15] = r0;
		  
			green[00] = g15;
			green[01] = g14;
			green[02] = g13;
			green[03] = g12;
			green[04] = g11;
			green[05] = g10;
			green[06] = g9;
			green[07] = g8;
			green[08] = g7;
			green[09] = g6;
			green[10] = g5;
			green[11] = g4;
			green[12] = g3;
			green[13] = g2;
			green[14] = g1;
			green[15] = g0;
		end
		
endmodule
