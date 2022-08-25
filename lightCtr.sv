module lightCtr(clk, reset, init, in, out, speed);
	input  logic clk, reset, in, init;
	input  logic [7:0] speed;
	output logic out;
	
	logic [31:0] limit;
	assign limit = speed*195313;
	
	logic [31:0] counter;
	
	logic ps, ns;
	
	assign out = ps;
	
	always_comb
		if (counter == limit)
			ns = in;
		else
			ns = ps;
	
	always_ff @(posedge clk)
		if (reset) begin
			counter <=0;
			ps <= init;
			end
		else if (counter == limit) begin
			counter <=0;
			ps <= ns;
			end
		else begin
			counter <= counter + 1;
			ps <= ns;
			end
endmodule

module lightCtr_testbench();
	logic clk, reset, in, init, out;
	logic [7:0] speed;
	
	lightCtr dut(clk, reset, init, in, out, speed);
	
	parameter CLOCK_PERIOD = 100;
	
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		@(posedge clk); reset <= 1; in <= 0; init <= 1;
		@(posedge clk); reset <= 0;
		@(posedge clk); in <= 1;
		@(posedge clk); in <= 0;
		@(posedge clk);
		@(posedge clk); in <= 1;
		@(posedge clk);
		@(posedge clk); in <=0;
		@(posedge clk);
		$stop;
	end
endmodule
