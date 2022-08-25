module laneLeft(clk, reset, up, down, left, right, rl,  gl,  fabove,  fbelow,  lose, init, speed);
	input  logic clk, reset, up, down, left, right;
	output logic lose;
	input  reg  [15:0] fabove, fbelow;
	output reg  [15:0] rl, gl;
	logic       [15:0] ps, ns;
	input logic [15:0] init;
	input logic [7:0]  speed;
		
	assign rl = ps;
	
	lightCtr l15(.clk(clk), .reset(reset), .init(init[15]), .in(gl[14]), .out(gl[15]), .speed(speed));
	lightCtr l14(.clk(clk), .reset(reset), .init(init[14]), .in(gl[13]), .out(gl[14]), .speed(speed));
	lightCtr l13(.clk(clk), .reset(reset), .init(init[13]), .in(gl[12]), .out(gl[13]), .speed(speed));
	lightCtr l12(.clk(clk), .reset(reset), .init(init[12]), .in(gl[11]), .out(gl[12]), .speed(speed));
	lightCtr l11(.clk(clk), .reset(reset), .init(init[11]), .in(gl[10]), .out(gl[11]), .speed(speed));
	lightCtr l10(.clk(clk), .reset(reset), .init(init[10]), .in(gl[9]),  .out(gl[10]), .speed(speed));
	lightCtr l9 (.clk(clk), .reset(reset), .init(init[9]),  .in(gl[8]),  .out(gl[9]) , .speed(speed));
	lightCtr l8 (.clk(clk), .reset(reset), .init(init[8]),  .in(gl[7]),  .out(gl[8]) , .speed(speed));
	lightCtr l7 (.clk(clk), .reset(reset), .init(init[7]),  .in(gl[6]),  .out(gl[7]) , .speed(speed));
	lightCtr l6 (.clk(clk), .reset(reset), .init(init[6]),  .in(gl[5]),  .out(gl[6]) , .speed(speed));
	lightCtr l5 (.clk(clk), .reset(reset), .init(init[5]),  .in(gl[4]),  .out(gl[5]) , .speed(speed));
	lightCtr l4 (.clk(clk), .reset(reset), .init(init[4]),  .in(gl[3]),  .out(gl[4]) , .speed(speed));
	lightCtr l3 (.clk(clk), .reset(reset), .init(init[3]),  .in(gl[2]),  .out(gl[3]) , .speed(speed));
	lightCtr l2 (.clk(clk), .reset(reset), .init(init[2]),  .in(gl[1]),  .out(gl[2]) , .speed(speed));
	lightCtr l1 (.clk(clk), .reset(reset), .init(init[1]),  .in(gl[0]),  .out(gl[1]) , .speed(speed));
	lightCtr l0 (.clk(clk), .reset(reset), .init(init[0]),  .in(gl[15]), .out(gl[0]) , .speed(speed));
	
	always_comb
		if((rl&gl)!=0) begin
			lose = 1;
			ns = ps;
			end
		else if ((left & right) | (left & (ps == 16'b1000000000000000)) | (right & (ps == 16'b0000000000000001))) begin
			lose = 0;
			ns = ps;
			end
		else if (left & ~right) begin
			lose = 0;
			ns = ps << 1;
			end
		else if (right & ~left) begin
			lose = 0;
			ns = ps >> 1;
			end
		else if (up & (fbelow != 0)) begin
			lose = 0;
			ns = fbelow;
			end
		else if (down & (fabove != 0)) begin
			lose = 0;
			ns = fabove;
			end
		else if ((down | up) & (ps != 0)) begin
			lose= 0;
			ns = 16'b0000000000000000;
			end
		else begin
			lose = 0;
			ns = ps;
			end
		
	always_ff @(posedge clk)
		if (reset)
			ps <= 16'b0000000000000000;
		else
			ps <= ns;
endmodule 

module laneLeft_testbench();
	logic clk, reset, up, down, left, right, lose;
	logic [15:0] fabove, fbelow, rl, gl, ps, ns, init;
	logic [7:0]  speed;
	
	laneLeft dut(clk, reset, up, down, left, right, rl,  gl,  fabove,  fbelow, lose, init, speed);
	
initial begin
		@(posedge clk); reset <= 1; up <= 0; down <= 0; left <= 0; right <= 0; fabove <= 0; fbelow <= 0; init <= 16'b0110001101011001; speed<= 7'b0000001;
		@(posedge clk); reset <= 0;
		@(posedge clk); fabove <= 16'b0000010000000000;
		@(posedge clk); down <= 1;
		@(posedge clk); down <= 0; fabove <= 0;
		@(posedge clk); left <= 1;
		@(posedge clk); left <= 0;
		@(posedge clk); right <= 1;
		@(posedge clk); right <= 0;
		@(posedge clk); left <= 1;
		@(posedge clk); left <= 0;
		@(posedge clk); right <= 1;
		@(posedge clk); right <= 0;
		@(posedge clk); reset <= 1;
		@(posedge clk); reset <= 0;
		@(posedge clk); fabove <= 16'b0000010000000000;
		@(posedge clk); down <= 1;
		@(posedge clk); down <= 0; fabove <= 0;
		@(posedge clk); right <= 1;
		@(posedge clk); right <= 0;
		@(posedge clk); right <= 1;
		@(posedge clk); right <= 0;
		@(posedge clk); right <= 1;
		@(posedge clk); right <= 0;
		@(posedge clk); reset <= 1;
		@(posedge clk); reset <= 0;
		@(posedge clk); down <= 1;
		@(posedge clk); down <= 0;
		@(posedge clk); up <= 1;
		@(posedge clk); up <= 0;
		@(posedge clk); fabove <= 16'b0000010000000000;
		@(posedge clk); down <= 1;
		@(posedge clk); down <= 0;
		@(posedge clk); reset <= 1;
		@(posedge clk); reset <= 0; fbelow <= 16'b0000000001000000;
		@(posedge clk); up <= 1;
		@(posedge clk); up <= 0;
		@(posedge clk);
		@(posedge clk);
		$stop;
	end
	
endmodule