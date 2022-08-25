module processInput(clk, reset, in, out);
	input  logic clk, reset, in;
	output logic out;
	
	logic ps, ns;
	
	always_ff @(posedge clk)
		if      (reset)
			ns <=0;
		else 
			ns <= in;
	
	assign out = ~ps & ns;
	
	always_ff @(posedge clk)
		if (reset)
			ps <= 0;
		else
			ps <= ns;
endmodule 

module processInput_testbench();
	logic clk, reset, in, out;
	
	processInput dut(clk, reset, in, out);
	
	parameter CLOCK_PERIOD = 100;
	
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		@(posedge clk); reset <= 1; in <= 0;
		@(posedge clk); reset <= 0;
		@(posedge clk);
		@(posedge clk); in <= 1;
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk); in <= 0;
		@(posedge clk);
		@(posedge clk);
		$stop;
	end
endmodule 