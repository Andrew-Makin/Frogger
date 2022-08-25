module DE1_SoC(HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, SW, LEDR, GPIO_1, CLOCK_50);
	// inputs and outputs
	output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0]  LEDR;
	input  logic [3:0]  KEY;
	input  logic [9:0]  SW;
	output logic [35:0] GPIO_1;
	input  logic        CLOCK_50;
	
	assign HEX4 = 7'b1111111;
	assign HEX5 = 7'b1111111;
	
	// clock
	logic [31:0] clk;
	logic our_clock;
	
	clock_divider d(.clock(CLOCK_50), .divided_clocks(clk));
	
	assign our_clock = clk[10];// change clock speed here
	
	// led board
	logic [15:0][15:0] RedPixels;
	logic [15:0][15:0] GrnPixels;
	logic RST;
	assign RST = SW[8];
	
	
	LEDDriver driver(.CLK(our_clock), .RST, .EnableCount(1), .RedPixels, .GrnPixels, .GPIO_1);
	
	// frogger game
	logic  reset;
	assign reset = SW[9];
	logic up, down, left, right;
	
	// key bindings are the same as vim text editor
	processInput k0 (.clk(CLOCK_50), .reset(reset), .in(KEY[0]), .out(down));
	processInput k1 (.clk(CLOCK_50), .reset(reset), .in(KEY[1]), .out(up));
	processInput k2 (.clk(CLOCK_50), .reset(reset), .in(KEY[2]), .out(right));
	processInput k3 (.clk(CLOCK_50), .reset(reset), .in(KEY[3]), .out(left));
	
	
	// rows of lights
	logic [15:0] rl0, rl1, rl2, rl3, rl4, rl5, rl6, rl7, rl8, rl9, rl10, rl11, rl12, rl13, rl14, rl15;
	logic [15:0] gl0, gl1, gl2, gl3, gl4, gl5, gl6, gl7, gl8, gl9, gl10, gl11, gl12, gl13, gl14, gl15;
	
	// game end conditions
	logic win;
	logic  lose, f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12, f13, f14;
	assign lose = f1| f2| f3| f4| f5| f6| f7|	f8| f9| f10| f11| f12| f13| f14;
	logic  newGameOut, newGameIn;
	assign newGameIn = reset | newGameOut;
	logic  [7:0] speed;
	assign speed = SW[7:0];
	
	northSideWalk lane15(.clk(CLOCK_50), .reset(newGameIn), .up(up), .down(down), .left(left), .right(right), .rl(rl15), .gl(gl15), 					  .fbelow(rl14), .win(win));
	laneLeft      lane14(.clk(CLOCK_50), .reset(newGameIn), .up(up), .down(down), .left(left), .right(right), .rl(rl14), .gl(gl14), .fabove(rl15), .fbelow(rl13), .lose(f14), .init(16'b0011100000111111), .speed(speed));//14 L
	laneRight     lane13(.clk(CLOCK_50), .reset(newGameIn), .up(up), .down(down), .left(left), .right(right), .rl(rl13), .gl(gl13), .fabove(rl14), .fbelow(rl12), .lose(f13), .init(16'b1110001100100001), .speed(speed));//13 R
	laneLeft      lane12(.clk(CLOCK_50), .reset(newGameIn), .up(up), .down(down), .left(left), .right(right), .rl(rl12), .gl(gl12), .fabove(rl13), .fbelow(rl11), .lose(f12), .init(16'b1110000111000001), .speed(speed));//12 L
	laneLeft      lane11(.clk(CLOCK_50), .reset(newGameIn), .up(up), .down(down), .left(left), .right(right), .rl(rl11), .gl(gl11), .fabove(rl12), .fbelow(rl10), .lose(f11), .init(16'b1110001111000011), .speed(speed));//11 L
	laneRight     lane10(.clk(CLOCK_50), .reset(newGameIn), .up(up), .down(down), .left(left), .right(right), .rl(rl10), .gl(gl10), .fabove(rl11), .fbelow(rl9),  .lose(f10), .init(16'b1111111111111110), .speed(speed));//10 R
	laneLeft      lane9 (.clk(CLOCK_50), .reset(newGameIn), .up(up), .down(down), .left(left), .right(right), .rl(rl9),  .gl(gl9),  .fabove(rl10), .fbelow(rl8),  .lose(f9) , .init(16'b0000000000000000), .speed(speed));//9  L
	laneRight     lane8 (.clk(CLOCK_50), .reset(newGameIn), .up(up), .down(down), .left(left), .right(right), .rl(rl8),  .gl(gl8),  .fabove(rl9),  .fbelow(rl7),  .lose(f8) , .init(16'b0111001100011000), .speed(speed));//8  R
	laneRight     lane7 (.clk(CLOCK_50), .reset(newGameIn), .up(up), .down(down), .left(left), .right(right), .rl(rl7),  .gl(gl7),  .fabove(rl8),  .fbelow(rl6),  .lose(f7) , .init(16'b0011100110001100), .speed(speed));//7  R
	laneLeft      lane6 (.clk(CLOCK_50), .reset(newGameIn), .up(up), .down(down), .left(left), .right(right), .rl(rl6),  .gl(gl6),  .fabove(rl7),  .fbelow(rl5),  .lose(f6) , .init(16'b1001111000110000), .speed(speed));//6  L
	laneRight     lane5 (.clk(CLOCK_50), .reset(newGameIn), .up(up), .down(down), .left(left), .right(right), .rl(rl5),  .gl(gl5),  .fabove(rl6),  .fbelow(rl4),  .lose(f5) , .init(16'b0010011110001100), .speed(speed));//5  R
	laneLeft      lane4 (.clk(CLOCK_50), .reset(newGameIn), .up(up), .down(down), .left(left), .right(right), .rl(rl4),  .gl(gl4),  .fabove(rl5),  .fbelow(rl3),  .lose(f4) , .init(16'b0000000000000000), .speed(speed));//4  L
	laneRight     lane3 (.clk(CLOCK_50), .reset(newGameIn), .up(up), .down(down), .left(left), .right(right), .rl(rl3),  .gl(gl3),  .fabove(rl4),  .fbelow(rl2),  .lose(f3) , .init(16'b1000000011100001), .speed(speed));//3  R
	laneLeft      lane2 (.clk(CLOCK_50), .reset(newGameIn), .up(up), .down(down), .left(left), .right(right), .rl(rl2),  .gl(gl2),  .fabove(rl3),  .fbelow(rl1),  .lose(f2) , .init(16'b0001000110000000), .speed(speed));//2  L
	laneRight     lane1 (.clk(CLOCK_50), .reset(newGameIn), .up(up), .down(down), .left(left), .right(right), .rl(rl1),  .gl(gl1),  .fabove(rl2),  .fbelow(rl0),  .lose(f1) , .init(16'b0111110000001100), .speed(speed));//1  R
	southSideWalk lane0 (.clk(CLOCK_50), .reset(newGameIn), .up(up), .down(down), .left(left), .right(right), .rl(rl0),  .gl(gl0),  .fabove(rl1));
	
	gameEnd over(.clk(CLOCK_50), .reset(reset), .newGameOut(newGameOut), .up(up), .down(down), .left(left), .right(right), .win(win), .lose(lose), .hex0(HEX0), .hex1(HEX1), .hex2(HEX2), .hex3(HEX3));
	
	LEDArray a(.RST(RST), .r0(rl0), .r1(rl1), .r2(rl2), .r3(rl3), .r4(rl4), .r5(rl5), .r6(rl6), .r7(rl7), .r8(rl8), .r9(rl9), .r10(rl10), .r11(rl11), .r12(rl12), .r13(rl13), .r14(rl14), .r15(rl15),
								 .g0(gl0), .g1(gl1), .g2(gl2), .g3(gl3), .g4(gl4), .g5(gl5), .g6(gl6), .g7(gl7), .g8(gl8), .g9(gl9), .g10(gl10), .g11(gl11), .g12(gl12), .g13(gl13), .g14(gl14), .g15(gl15),
				             .red(RedPixels), .green(GrnPixels));
endmodule 

module clock_divider(clock, divided_clocks);
	input logic clock;
	output logic [31:0] divided_clocks = 0;
	
	always_ff @(posedge clock)
		divided_clocks <= divided_clocks +1;
endmodule 