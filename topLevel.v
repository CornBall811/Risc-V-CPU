module rv32i_cpu (
	input clk,
	input reset
);
	// Internal wires
	wire [31:0] pc_out, next_pc, instr;
	wire [31:0] reg_data1, reg_data2, imm_ext, alu_result;
	wire [31:0] alu_input_b;
	wire [3:0] alu_ctrl;
	wire reg_write, alu_src, zero;

	// Ram wiring
	wire [31:0] ram_data_out;
	wire [31:0] final_write_data;
	wire mem_to_reg;	// 1 if we are loading from ram
	wire mem_write;		// 1 if we are storing to ram
	wire [3:0] byte_we;	// 4 bit mask for the 4 ram banks

	// Program counter
	program_counter pc_unit (
		.clk(clk), .reset(reset), .next_pc(next_pc), .pc(pc_out)
	);

	// Simplep pc + 4 logic
	assign next_pc = pc_out + 4;

	// Instruction memory (basic placeholder)
	instr_mem mem (
		.address(pc_out), .instruction(instr)
	);
	
	// Control unit
	controller dec (
		.opcode(instr[6:0]), .funct3(instr[14:12]), .funct7_5(instr[30]),
		.reg_write(reg_write), .alu_src(alu_src), .alu_ctrl(alu_ctrl),
		.mem_to_reg(mem_to_reg), .mem_write(mem_write)
	);

	// Write enable logic
	assign byte_we = (mem_write) ? 4'b1111 : 4'b0000;

	// 8MB ram instance
	ram system_ram (
		.clk(clk),
		.we(byte_we),
		.addr(alu_result[22:0]),	// Use ALU result as the memory address
		.din(reg_data2),		// Data to store comes from the second register
		.dout(ram_data_out)
	);

	// Register file
	register_file rf (
		.clk(clk), .we(reg_write),
		.rs1(instr[19:15]), .rs2(instr[24:20]), .rd(instr[11:7]),
		.wd(final_write_data),	// Use the muxed data
		.rd1(reg_data1), .rd2(reg_data2)
	);

	// Immediate generator
	imm_gen ig (
		.instruction(instr), .imm_ext(imm_ext)
	);

	// ALU source mux
	// If alu_src is 1, use the immediate. If 0, use register data 2
	assign alu_input_b = (alu_src) ? imm_ext : reg_data2;

	// Alu
	rv32i_alu alu (
		.a(reg_data1), .b(alu_input_b), .alu_ctrl(alu_ctrl),
		.result(alu_result), .zero(zero)
	);
endmodule
