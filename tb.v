`timescale 1ns / 1ps

module cpu_tb();
	reg clk;
	reg reset;

	// Instantiate cpu
	rv32i_cpu uut (
		.clk(clk),
		.reset(reset)
	);

	// Generate clock: toggle every 5ns(100MHz)
	always #5 clk = ~clk;
	
	initial begin
		$dumpfile("simulation.vcd");	// Names the file
		$dumpvars(0, cpu_tb);		// Tells it to record everything in 'cpu_tb'
		// Initialize signals
		clk = 0;
		reset = 1;

		// Hold reset for 20ns
		#20 reset = 0;

		// Let the simulation run for 100ns
		#100;

		// End simulation
		$display("Simulation finished. Check waveforms to view registers.");
		$finish;
	end
	// Monitor results in the console
	initial begin
		$monitor("Time=%0t | PC=%h | Instr=%h | ALU_Res=%d",
			$time, uut.pc_out, uut.instr, uut.alu_result);
	end
endmodule
