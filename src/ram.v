module ram (
	input wire clk,
	input wire [3:0] we,	// Write enable per byte (from decoder)
	input wire [22:0] addr,	// 23 bit address (for 8MB total)
	input wire [31:0] din,	// Data from CPU
	output wire [31:0] dout,// Data to CPU
);
	reg [7:0] bank0 [0:255];
	reg [7:0] bank1 [0:255];
	reg [7:0] bank2 [0:255];
	reg [7:0] bank3 [0:255];

	// Word address
	// Ignore bottom 2 bits for indexing banks. addr[1:0] technically
	// selects the byte within the word.
	wire [20:0] word_addr = addr[22:2];

	// Synchronous writing
	// On rising edge only update the specific bytes enabled by 'we'
	always @(posedge clk) begin
		if (we[0]) bank0[word_addr] <= din[7:0];
		if (we[1]) bank1[word_addr] <= din[15:8];
		if (we[2]) bank2[word_addr] <= din[23:16];
		if (we[3]) bank3[word_addr] <= din[31:24];
	end

	// Combinational reading
	// Merges 4 bytes back into a 32 bit word for the cpu
	assign dout = {bank3[word_addr], bank2[word_addr], bank1[word_addr], bank0[word_addr]};
endmodule
