module square_wave_generator(
	input clk,
	input reset_n,
    input [15:0]frequency,
	output sq_wave
);

	localparam CLOCK_FREQUENCY = 50000000;
	
     reg [15:0] period;
	reg sq_wave_reg = 0;
	assign sq_wave = sq_wave_reg;

 	always @(posedge clk) begin
		if (!reset_n | frequency == 0) begin
			period <= 16'b0;
			sq_wave_reg	<= 1'b0;
            period <= 16'b0;
		end
	
		else begin 
			if (period == 16'b0) begin
				sq_wave_reg <= ~sq_wave_reg;
				period <= CLOCK_FREQUENCY / frequency - 1;		
			end else period <= period - 1; 
			end
		end
		
endmodule