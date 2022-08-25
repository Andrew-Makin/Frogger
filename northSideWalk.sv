module northSideWalk(clk, reset, up, down, left, right, rl, gl, fbelow, win);
	input  logic      clk, reset, up, down, left, right;
	input  reg [15:0] fbelow;
	output logic      win;
	output reg [15:0] rl, gl;
	logic      [15:0] ps, ns;
	
	assign gl = 16'b1111111111111111;
	
	assign rl = ps;
	
	always_comb
		if (up && fbelow!=0) begin
			win = 1;
			ns = fbelow;
		end
		else begin
			win = 0;
			ns = ps;
		end
	
	always_ff @(posedge clk)
		if (reset)
			ps <= 0;
		else
			ps <= ns;
endmodule

module northSideWalk_testbench();
	logic clk, reset, up, down, left, right, win;
	reg [15:0] fbelow;
	reg [15:0] rl, gl;
	
	northSideWalk dut(clk, reset, up, down, left, right, rl, gl, fbelow, win);
	
	parameter CLOCK_PERIOD = 100;
	
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		@(posedge clk); reset  <= 1; up <= 0; down <= 0; left <= 0; right <= 0; fbelow <= 0;
		@(posedge clk); reset  <= 0;
		@(posedge clk); down   <= 1;
		@(posedge clk); down   <= 0;
		@(posedge clk); up     <= 1;
		@(posedge clk); up     <= 0; 
		@(posedge clk); left   <= 1;
		@(posedge clk); left   <= 0;
		@(posedge clk); right  <= 1;
		@(posedge clk); right  <= 0;
		@(posedge clk); reset  <= 1; up <= 0; down <= 0; left <= 0; right <= 0; fbelow <= 0;
		@(posedge clk); reset  <= 0;
		@(posedge clk); fbelow <= 16'b0000100000000000;
		@(posedge clk); reset  <= 0;
		@(posedge clk); down   <= 1;
		@(posedge clk); down   <= 0;
		@(posedge clk); up     <= 1;
		@(posedge clk); up     <= 0; 
		@(posedge clk); left   <= 1;
		@(posedge clk); left   <= 0;
		@(posedge clk); right  <= 1;
		@(posedge clk); right  <= 0;
		$stop;
	end
endmodule
		