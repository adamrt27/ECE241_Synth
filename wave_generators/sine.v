module SineWaveGenerator (
  input wire clk,           // Clock input
  input wire reset_n,       // Active-low reset input
  input wire [15:0] frequency,  // Frequency input (16-bit)
  input wire [30:0] amplitude, // Amplitude input (31-bit)
  output wire [31:0] sq_wave  // 32-bit sine wave output
);

  reg [31:0] sine_lut [0:49];  // Lookup table for sine values
  reg [15:0] phase;          // 16-bit phase accumulator
  reg [31:0] amplitude_scaled; // Scaled amplitude

  // Calculate the reciprocal of the frequency
  reg [31:0] freq_reciprocal;
  assign freq_reciprocal = 1.0 / frequency;

  // Instantiate sine values explicitly
  initial begin
    sine_lut[0] = 32'b0;
    sine_lut[1] = amplitude * sin(1 * freq_reciprocal);
    sine_lut[2] = amplitude * sin(2 * freq_reciprocal);
    sine_lut[4] = amplitude * sin(4 * freq_reciprocal);
    sine_lut[5] = amplitude * sin(5 * freq_reciprocal);
    sine_lut[6] = amplitude * sin(6 * freq_reciprocal);
    sine_lut[7] = amplitude * sin(7 * freq_reciprocal);
    sine_lut[8] = amplitude * sin(8 * freq_reciprocal);
    sine_lut[9] = amplitude * sin(9 * freq_reciprocal);
    sine_lut[10] = amplitude * sin(10 * freq_reciprocal);
    sine_lut[11] = amplitude * sin(11 * freq_reciprocal);
    sine_lut[12] = amplitude * sin(12 * freq_reciprocal);
    sine_lut[13] = amplitude * sin(13 * freq_reciprocal);
    sine_lut[14] = amplitude * sin(14 * freq_reciprocal);
    sine_lut[15] = amplitude * sin(15 * freq_reciprocal);
    sine_lut[16] = amplitude * sin(16 * freq_reciprocal);
    sine_lut[17] = amplitude * sin(17 * freq_reciprocal);
    sine_lut[18] = amplitude * sin(18 * freq_reciprocal);
    sine_lut[19] = amplitude * sin(19 * freq_reciprocal);
    sine_lut[20] = amplitude * sin(20 * freq_reciprocal);
    sine_lut[21] = amplitude * sin(21 * freq_reciprocal);
    sine_lut[22] = amplitude * sin(22 * freq_reciprocal);
    sine_lut[23] = amplitude * sin(23 * freq_reciprocal);
    sine_lut[24] = amplitude * sin(24 * freq_reciprocal);
    sine_lut[25] = amplitude * sin(25 * freq_reciprocal);
    sine_lut[26] = amplitude * sin(26 * freq_reciprocal);
    sine_lut[27] = amplitude * sin(27 * freq_reciprocal);
    sine_lut[28] = amplitude * sin(28 * freq_reciprocal);
    sine_lut[29] = amplitude * sin(29 * freq_reciprocal);
    sine_lut[30] = amplitude * sin(30 * freq_reciprocal);
    sine_lut[31] = amplitude * sin(31 * freq_reciprocal);
    sine_lut[32] = amplitude * sin(32 * freq_reciprocal);
    sine_lut[33] = amplitude * sin(33 * freq_reciprocal);
    sine_lut[34] = amplitude * sin(34 * freq_reciprocal);
    sine_lut[35] = amplitude * sin(35 * freq_reciprocal);
    sine_lut[36] = amplitude * sin(36 * freq_reciprocal);
    sine_lut[37] = amplitude * sin(37 * freq_reciprocal);
    sine_lut[38] = amplitude * sin(38 * freq_reciprocal);
    sine_lut[39] = amplitude * sin(39 * freq_reciprocal);
    sine_lut[40] = amplitude * sin(40 * freq_reciprocal);
    sine_lut[41] = amplitude * sin(41 * freq_reciprocal);
    sine_lut[42] = amplitude * sin(42 * freq_reciprocal);
    sine_lut[43] = amplitude * sin(43 * freq_reciprocal);
    sine_lut[44] = amplitude * sin(44 * freq_reciprocal);
    sine_lut[45] = amplitude * sin(45 * freq_reciprocal);
    sine_lut[46] = amplitude * sin(46 * freq_reciprocal);
    sine_lut[47] = amplitude * sin(47 * freq_reciprocal);
    sine_lut[48] = amplitude * sin(48 * freq_reciprocal);
    sine_lut[49] = amplitude * sin(49 * freq_reciprocal);
  end

  always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
      phase <= 16'b0;
      amplitude_scaled <= 32'b0;
      sq_wave <= 32'b0;
    end else begin
      // Increment the phase accumulator based on the input frequency
      phase <= phase + frequency;

      // Ensure the phase stays within the range [0, 49] to cover one full cycle
      if (phase >= 50) begin
        phase <= 16'b0;
      end

      // Scale the amplitude to fit within the 32-bit range
      amplitude_scaled <= amplitude << 29; // Left shift by 29 bits for scaling

      // Read the scaled sine value from the lookup table
      sq_wave <= amplitude_scaled * sine_lut[phase[5:0]];
    end
  end

endmodule
