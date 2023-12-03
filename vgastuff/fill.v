fill f0(
		.CLOCK_50,
		.VGA_CLK(VGA_CLK),
		.VGA_HS(VGA_HS),
		.VGA_VS(VGA_VS),
		.VGA_BLANK_N(VGA_BLANK_N),
		.VGA_SYNC_N(VGA_SYNC_N), // VGA SYNC
		.VGA_R(VGA_R),   // VGA Red[9:0]
		.VGA_G(VGA_G), // VGA Green[9:0]
		.VGA_B(VGA_B),   // VGA Blue[9:0]
		.LEDR(LEDR)
);

module fill
CLOCK_50, // On Board 50 MHz
// Your inputs and outputs here
KEY,
SW,
// On Board Keys
// The ports below are for the VGA output.  Do not change.
VGA_CLK,   // VGA Clock
VGA_HS, // VGA H_SYNC
VGA_VS, // VGA V_SYNC
VGA_BLANK_N, // VGA BLANK
VGA_SYNC_N, // VGA SYNC
VGA_R,   // VGA Red[9:0]
VGA_G, // VGA Green[9:0]
VGA_B,   // VGA Blue[9:0]
LEDR
);

input CLOCK_50; // 50 MHz
input [3:0] KEY;
input   [9:0]   SW;
// Declare your inputs and outputs here
// Do not change the following outputs
output VGA_CLK;   // VGA Clock
output VGA_HS; // VGA H_SYNC
output VGA_VS; // VGA V_SYNC
output VGA_BLANK_N; // VGA BLANK
output VGA_SYNC_N; // VGA SYNC
output [7:0] VGA_R;   // VGA Red[7:0] Changed from 10 to 8-bit DAC
output [7:0] VGA_G; // VGA Green[7:0]
output [7:0] VGA_B;   // VGA Blue[7:0]
output [9:0]LEDR;

wire resetn;
wire note_in;
wire [3:0] note;
wire [2:0] octave;
wire octave_plus_plus; // if 1, increment octave by 1, else dont change 
wire octave_minus_minus; // if 1 decrease octave by 1, else dont change
wire [2:0] ADSR_selector; // if 0 - change amplitude/volume
wire ADSR_plus_plus; // if 1, increment selected ADSR by 1
wire ADSR_minus_minus;

// Create the colour, x, y and writeEn wires that are inputs to the controller.

wire [2:0] colour;
wire [7:0] x;
wire [6:0] y;
wire done;
wire writeEn;
wire [3:0]state;

vgadisplay v0(
		.iClock(CLOCK_50),
		.iResetn(reset),
		.note_in(note_in),
		.oColour(colour),
		.oPlot(writeEn),
		.oX(x),
		.oY(y),
		.note(note),
		.octave_minus_minus(octave_minus_minus),
    .octave_plus_plus(octave_plus_plus),
		.ADSR_selector(ADSR_selector),
    .ADSR_minus_minus(ADSR_minus_minus),
		.ADSR_plus_plus(ADSR_plus_plus));
	
	vga_adapter VGA(
		.resetn(resetn),
		.clock(CLOCK_50),
		.colour(colour),
		.x(x),
		.y(y),
		.plot(writeEn),
		.VGA_R(VGA_R),
		.VGA_G(VGA_G),
		.VGA_B(VGA_B),
		.VGA_HS(VGA_HS),
		.VGA_VS(VGA_VS),
		.VGA_BLANK(VGA_BLANK_N),
		.VGA_SYNC(VGA_SYNC_N),
		.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "320x240";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "piano.mif";
  
endmodule
