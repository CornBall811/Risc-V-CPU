module rv32i_alu (
	input [31:0] a, b,		// Operands
	input [3:0] alu_ctrl,		// Control signal from decoder
	output reg [31:0] result,	// ALU result
	output zero			// Zero flag for branching
);
	// Zero flag is high if result is 0 (used for BEQ/BNE)
	assign zero = (result == 32'b0);

	always @(*) begin
		case (alu_ctrl)
			4'b000: result = a + b;			// ADD/ADDI
			4'b1000: result = a - b;		// SUB
			4'b0001: result = a << b[4:0];		// SLL/SLLI
			4'b0010: result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;	// SLT/SLTI
			4'b0011: result = (a < b) ? 32'd1 : 32'd0; // SLTU/SLTIU
			4'b0100: result = a ^ b	;		// XOR/XORI
			4'b0101: result = a >> b[4:0];		// SRL/SRLI
			4'b1101: result = $signed(a) >>> b[4:0];// SRA/SRAI
			4'b0110: result = a | b;		// OR/ORI
			4'b0111: result = a & b;		// AND/ANDI
			default: result = 32'b0;
		endcase
	end
endmodule
