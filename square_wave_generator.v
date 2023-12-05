module square_wave_generator(
	input clk,
	input reset_n,
    input [15:0]frequency,
	input [30:0] amplitude, // amplitude from 0 to peak (not peak to peak)
	output [31:0] sq_wave
);

	localparam CLOCK_FREQUENCY = 50000000;
	
    reg [31:0] period;
	reg [31:0] sq_wave_reg;
	assign sq_wave = sq_wave_reg;

 	always @(posedge clk) begin
		if (!reset_n | frequency == 0) begin
			period <= 32'b0;
			sq_wave_reg	<= 32'b0;
		end
	
		else begin 
			if (period == 32'b0) begin
				if (sq_wave_reg == 0)
					sq_wave_reg <= amplitude * 2;
				else 
					sq_wave_reg <= 0;
				period <= CLOCK_FREQUENCY / frequency - 1;		
			end else period <= period - 1; 
			end
		end
		
endmodule