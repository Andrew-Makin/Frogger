module southSideWalk (clk, reset, up, down, left, right, rl,  gl,  fabove);
	input logic clk, reset, up, down, left, right;
	input reg [15:0] fabove;
	output reg [15:0] rl, gl;
	
	assign gl = 16'b1111111111111111; // green edge light always light up
	
	logic [15:0] ps, ns;
	
	assign rl = ps;
	
	always_comb
		if ((left & right) | (left & (ps == 16'b1000000000000000)) | (right & (ps == 16'b0000000000000001)))
			ns = ps;
		else if (left & ~right)
			ns = ps << 1;
		else if (right & ~left)
			ns = ps >> 1;
		else if (up)
			ns = 16'b0000000000000000;
		else if (down & (fabove != 0))
			ns = fabove;
		else
			ns = ps;
		
	
	always_ff @(posedge clk)
		if (reset)
			ps <= 16'b0000000100000000;
		else
			ps <= ns;
			
endmodule

module southSideWalk_testbench();
	logic clk, reset, up, down, left, right;
	reg[15:0] fabove, rl, gl;
	
	southSideWalk dut(clk, reset, up, down, left, right, rl, gl, fabove);
	
	parameter CLOCK_PERIOD = 100;
	
	initial begin
		clk<=0;
		forever @(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		@(posedge clk); reset <= 1; up <= 0; down <= 0; left <= 0; right <= 0; fabove <= 0;
		@(posedge clk); reset <= 0;
		@(posedge clk); left <= 1;
		@(posedge clk); left <= 0;
		@(posedge clk); right <= 1;
		@(posedge clk); right <= 0;
		@(posedge clk); left <= 1;
		@(posedge clk); left <= 0;
		@(posedge clk); left <= 1;
		@(posedge clk); left <= 0;
		@(posedge clk); left <= 1;
		@(posedge clk); left <= 0;
		@(posedge clk); left <= 1;
		@(posedge clk); left <= 0;
		@(posedge clk); reset <= 1;
		@(posedge clk); reset <= 0;
		@(posedge clk); down <= 1;
		@(posedge clk); down <= 0;
		@(posedge clk); up <= 1;
		@(posedge clk); up <= 0;
		@(posedge clk); fabove <= 16'b0000010000000000;
		@(posedge clk); down <= 1;
		@(posedge clk); down <= 0;
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		$stop;
	end
	
endmodule
	