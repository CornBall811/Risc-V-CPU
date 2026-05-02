module register_file (
	input clk,
	input we,		// Write enable
	input [4:0] rs1,	// Address of first source register
	input [4:0] rs2,	// Address of second source register
	input [4:0] rd,		// Address of destination register
	input [31:0] wd,	// Write data
	output [31:0] rd1,	// Read data 1
	output [31:0] rd2	// Read data 2
);
	// Create the storage; 32 registers, each 32 bits wide
	reg [31:0] rf [31:0];

	// Read logic
	// If address is 0, output 0, otherwise output reg value
	assign rd1 = (rs1 == 5'b0) ? 32'b0 : rf[rs1];
	assign rd2 = (rs2 == 5'b0) ? 32'b0 : rf[rs2];

	// Write logic
	always @(posedge clk) begin
		if (we && (rd != 5'b0)) begin
			rf[rd] <= wd;
		end
	end

endmodule
