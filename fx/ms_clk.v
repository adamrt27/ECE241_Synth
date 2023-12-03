module ms_clk(clk, reset, pulse);
	input clk; // clock
	input reset; //active low reset
	output pulse; // pulses every millisecond

	RateDivider r0(clk,~reset,2'b0, pulse);

endmodule

module s_clk(clk, reset, pulse;
	input clk; // clock
	input reset; //active low reset
	output pulse; // pulses every second

	RateDivider r0(clk,~reset,2'b01, pulse);
endmodule

module RateDivider
#(parameter CLOCK_FREQUENCY = 50000000) (
	input ClockIn,
	input Reset,
	input [1:0] Speed,
	output Enable
);
// 1. figure out # of clock cycles per pulse
// 2. count down from # to 0
// 3. emit pulse at 0
// 4. reset to counter
	
	reg [$clog2(4*CLOCK_FREQUENCY):0] count;

	always@(posedge ClockIn)
	begin
		if ((Reset == 1) | (count == 0 ))
		begin
			case(Speed)
				2'b00: count <= (CLOCK_FREQUENCY/1000) - 1;
				2'b01: count <= CLOCK_FREQUENCY - 1;
				2'b10: count <= CLOCK_FREQUENCY*2 - 1;
				2'b11: count <= CLOCK_FREQUENCY*4 - 1;
				default: count <= 0;
			endcase
		end 
		else if (count != 0)
			count <= count - 1;
	end

	assign Enable = (count == 'b0) ? 'b1:'b0;
endmodule
	
		
	
