module instr_mem (
	input [31:0] address,
	output [31:0] instruction
);
	// Create an array of 64 words (32 bit width each)
	reg [31:0] rom [63:0];

	// Initialize the memory with a simple program
	initial begin
		// Address 0: addi x1, x0, 5 -> x1 = 5
		rom[0] = 32'h00500093;

		// Address 4: addi x2, x0, 10 -> x2 = 10
		rom[1] = 32'h00a00113;

		// Address 8: add x3, x1, x2 -> x3 = 5 + 10 = 15
		rom[2] = 32'h002081b3;

		// Address 12: sub x4, x3, x1 -> x4 = 15 - 5 = 10
		rom[3] = 32'h40118233;
		
		// Fill the rest with zeros
		// Typically would use $readmemh to load a file
	end

	// Risc-v uses byte addressing, but this array is word indexed
	// Divide address by 4 (shift right by 2) to get index
	assign instruction = rom[address[31:2]];
endmodule
