module SineWaveGenerator (
  input wire clk,           // Clock input
  input wire reset_n,       // Active-low reset input
  input wire [15:0] frequency,  // Frequency input (16-bit)
  input wire [30:0] amplitude, // Amplitude input (31-bit)
  output wire [31:0] sine_wave  // 32-bit sine wave output
);

  reg [31:0] sine_lut [0:99];  // Lookup table for sine values
  reg [15:0] phase;          // 16-bit phase accumulator
  reg [31:0] amplitude_scaled; // Scaled amplitude
  reg [10:0] counter;

  // Calculate the reciprocal of the frequency
  reg [31:0] freq_reciprocal;
  assign freq_reciprocal = 50000000 / frequency;

  // Instantiate sine values explicitly
  initial begin
    initial begin
        i = 0;
       sine_lut[0] = 0;
                sine_lut[1] = 5;
                sine_lut[2] = 10;
                sine_lut[3] = 15;
                sine_lut[4] = 19;
                sine_lut[5] = 24;
                sine_lut[6] = 29;
                sine_lut[7] = 33;
                sine_lut[8] = 38;
                sine_lut[9] = 42;
                sine_lut[10] = 46;
                sine_lut[11] = 50;
                sine_lut[12] = 53;
                sine_lut[13] = 57;
                sine_lut[14] = 60;
                sine_lut[15] = 63;
                sine_lut[16] = 66;
                sine_lut[17] = 68;
                sine_lut[18] = 71;
                sine_lut[19] = 73;
                sine_lut[20] = 74;
                sine_lut[21] = 76;
                sine_lut[22] = 77;
                sine_lut[23] = 78;
                sine_lut[24] = 78;
                sine_lut[25] = 78;
                sine_lut[26] = 78;
                sine_lut[27] = 78;
                sine_lut[28] = 77;
                sine_lut[29] = 76;
                sine_lut[30] = 74;
                sine_lut[31] = 73;
                sine_lut[32] = 71;
                sine_lut[33] = 68;
                sine_lut[34] = 66;
                sine_lut[35] = 63;
                sine_lut[36] = 60;
                sine_lut[37] = 57;
                sine_lut[38] = 53;
                sine_lut[39] = 50;
                sine_lut[40] = 46;
                sine_lut[41] = 42;
                sine_lut[42] = 38;
                sine_lut[43] = 33;
                sine_lut[44] = 29;
                sine_lut[45] = 24;
                sine_lut[46] = 19;
                sine_lut[47] = 15;
                sine_lut[48] = 10;
                sine_lut[49] = 5;
                sine_lut[50] = 0;
                sine_lut[51] = -5;
                sine_lut[52] = -10;
                sine_lut[53] = -15;
                sine_lut[54] = -19;
                sine_lut[55] = -24;
                sine_lut[56] = -29;
                sine_lut[57] = -33;
                sine_lut[58] = -38;
                sine_lut[59] = -42;
                sine_lut[60] = -46;
                sine_lut[61] = -50;
                sine_lut[62] = -53;
                sine_lut[63] = -57;
                sine_lut[64] = -60;
                sine_lut[65] = -63;
                sine_lut[66] = -66;
                sine_lut[67] = -68;
                sine_lut[68] = -71;
                sine_lut[69] = -73;
                sine_lut[70] = -74;
                sine_lut[71] = -76;
                sine_lut[72] = -77;
                sine_lut[73] = -78;
                sine_lut[74] = -78;
                sine_lut[75] = -78;
                sine_lut[76] = -78;
                sine_lut[77] = -78;
                sine_lut[78] = -77;
                sine_lut[79] = -76;
                sine_lut[80] = -74;
                sine_lut[81] = -73;
                sine_lut[82] = -71;
                sine_lut[83] = -68;
                sine_lut[84] = -66;
                sine_lut[85] = -63;
                sine_lut[86] = -60;
                sine_lut[87] = -57;
                sine_lut[88] = -53;
                sine_lut[89] = -50;
                sine_lut[90] = -46;
                sine_lut[91] = -42;
                sine_lut[92] = -38;
                sine_lut[93] = -33;
                sine_lut[94] = -29;
                sine_lut[95] = -24;
                sine_lut[96] = -19;
                sine_lut[97] = -15;
                sine_lut[98] = -10;
                sine_lut[99] = -5;
    end
  end
  
  localparam CLOCK_FREQUENCY = 50000000;
  reg [31:0] period;
	reg [31:0] sine_wave_reg;
	assign sine_wave = sine_wave_reg;

  always @(posedge clk) begin
		if (!reset_n | frequency == 0) begin
			period <= 32'b0;
			sine_wave_reg	<= 32'b0;
		end
	
		else begin 
			if (period == 32'b0) begin
        counter<=counter+1'b1;
				sine_wave_reg <= (amplitude * sine_lut[counter])/78;
				period <= (CLOCK_FREQUENCY / (frequency*100) - 1);		
			end else period <= period - 1; 
			end
		end
endmodule
