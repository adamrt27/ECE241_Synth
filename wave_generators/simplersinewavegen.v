
module sine_wave_generator (
  input wire clock,      
  input wire reset,      
  input wire [15:0] frequency, 
  output wire [15:0] sine_wave 
);

// Parameters
parameter LUT_WIDTH = 256;  // Width of output sine wave
parameter CLOCK_FREQ = 50000000; 

// Internal signals and registers
reg [15:0] counter = 0;
reg [15:0] sine_out;

// Phase increment calculation
reg [15:0] phase_increment;

always @(*) begin
  // Calculate the phase increment based on input frequency
  phase_increment = (CLOCK_FREQ / frequency) / 2;
end

// Sine wave generation process
always @(posedge clock or posedge reset) begin
  if (reset) begin
    counter <= 0;
    sine_out <= 0;
  end else begin
    counter <= counter + 1;
    if (counter >= phase_increment) begin
      counter <= counter - phase_increment;
      sine_out <= sine_out ^ ((1 << LUT_WIDTH) - 1); // XOR operation to generate sine wave
    end
  end
end

assign sine_wave = sine_out;

endmodule
