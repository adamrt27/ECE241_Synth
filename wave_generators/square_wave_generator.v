module square_wave_generator(
	input clk,
	input reset_n,
    input [15:0]frequency,
	input [5:0] amplitude; // amplitude from 0 to peak (not peak to peak)
	output [6:0] sq_wave
);

	localparam CLOCK_FREQUENCY = 50000000;
	
    reg [15:0] period;
	reg [6:0] sq_wave_reg;
	assign sq_wave = sq_wave_reg;

 	always @(posedge clk) begin
		if (!reset_n | frequency == 0) begin
			period <= 16'b0;
			sq_wave_reg	<= 7'b0;
            period <= 16'b0;
		end
	
		else begin 
			if (period == 16'b0) begin
				if (sq_wave_reg == 0)
					sq_wave_reg <= amplitude * 2;
				else 
					sq_wave_reg <= 0;
				period <= CLOCK_FREQUENCY / frequency - 1;		
			end else period <= period - 1; 
			end
		end
		
endmodule