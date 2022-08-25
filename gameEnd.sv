module gameEnd(clk, reset, newGameOut, up, down, left, right, win, lose, hex0, hex1, hex2, hex3);
	input  logic clk, reset, up, down, left, right, win, lose;
	output logic newGameOut;
	output logic [6:0] hex0, hex1, hex2, hex3;
	
	logic [27:0] ps, ns;
	
	assign hex0 = ps[6:0];
	assign hex1 = ps[13:7];
	assign hex2 = ps[20:14];
	assign hex3 = ps[27:21];
	
	
	always_comb
		if (win) begin
			ns = 28'b0001100000100000100100010010;
			newGameOut = 1;
			end
		else if (lose) begin
			ns = 28'b0100001000010000010000100001;
			newGameOut = 1;
			end
		else if (((ps == 28'b0001100000100000100100010010) | (ps == 28'b0100001000010000010000100001)) & (up | down | left | right)) begin
			ns = 28'b0001100100011100010000010001;
			newGameOut = 0;
			end
		else begin 
			ns = ps;
			newGameOut = 0;
			end
	
	always_ff @(posedge clk)
		if (reset) 
			ps <= 28'b0001100100011100010000010001;
		else
			ps <= ns;
endmodule 

module gameEnd_testbench();
	logic clk, reset, newGameOut, up, down, left, right, win, lose;
	reg [6:0] hex0, hex1, hex2, hex3;
	
	success dut (clk, reset, newGameOut, up, down, left, right, win, lose, hex0, hex1, hex2, hex3);
	
	parameter CLOCK_PERIOD = 100;
	
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		@(posedge clk); reset <= 1; up <= 0; down <= 0; left <= 0; right <= 0; win <= 0; lose <= 0;
		@(posedge clk); reset <= 0;
		@(posedge clk); win <= 1;
		@(posedge clk); win <= 0;
		@(posedge clk); down <= 1;
		@(posedge clk); down <= 0;
		@(posedge clk); lose <= 1;
		@(posedge clk); lose <= 0;
		@(posedge clk); right <= 1;
		@(posedge clk); right <= 0;
		@(posedge clk); left <= 1;
		@(posedge clk); left <= 0;
		$stop;
	end
	
endmodule