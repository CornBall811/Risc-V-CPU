module controller (
    input  [6:0] opcode,     // Instruction bits [6:0]
    input  [2:0] funct3,     // Instruction bits [14:12]
    input        funct7_5,   // Instruction bit 30
    output reg   reg_write,  // Write to Register File?
    output reg   alu_src,    // ALU Input B: 0=reg, 1=imm
    output reg   mem_to_reg, // Register Input: 0=ALU, 1=Mem
    output reg   mem_write,  // Write to Data Memory?
    output reg   branch,     // Is this a branch instruction?
    output reg [3:0] alu_ctrl // Operation signal for ALU
);

    always @(*) begin
        // Default values
        reg_write  = 0;
        alu_src    = 0;
        mem_to_reg = 0;
        mem_write  = 0;
        branch     = 0;
        alu_ctrl   = 4'b0000;

        case (opcode)
            // R type
            7'b0110011: begin
                reg_write = 1;
                case (funct3)
                    3'b000: alu_ctrl = (funct7_5) ? 4'b1000 : 4'b0000; // sub : add
                    3'b010: alu_ctrl = 4'b0010; // slt
                    3'b110: alu_ctrl = 4'b0110; // or
                    3'b111: alu_ctrl = 4'b0111; // and
                    default: alu_ctrl = 4'b0000;
                endcase
            end

            // I type
            7'b0010011: begin
                reg_write = 1;
                alu_src   = 1;
                case (funct3)
                    3'b000: alu_ctrl = 4'b0000; // addi
                    3'b010: alu_ctrl = 4'b0010; // slti
                    3'b111: alu_ctrl = 4'b0111; // andi
                    default: alu_ctrl = 4'b0000;
                endcase
            end

            // LOAD (lw)
            7'b0000011: begin
                reg_write  = 1;
                alu_src    = 1;
                mem_to_reg = 1;
                alu_ctrl   = 4'b0000; // ALU calculates address (Base + Imm)
            end

            // STORE (sw)
            7'b0100011: begin
                alu_src    = 1;
                mem_write  = 1;
                alu_ctrl   = 4'b0000; // ALU calculates address (Base + Imm)
            end

            // BRANCH (beq)
            7'b1100011: begin
                branch   = 1;
                alu_ctrl = 4'b1000; // ALU does subtraction to check equality
            end

            default: ; 
        endcase
    end
endmodule
