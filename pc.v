module program_counter (
	input clk,
	input reset,
	input [31:0] next_pc,	// Address to go to
	output reg [31:0] pc	// Current address
);

	always @(posedge clk or posedge reset) begin
		if (reset)
			pc <= 32'h0000_0000; // Start at address 0
		else
			pc <= next_pc;	     // Move to the next address
	end
endmodule
