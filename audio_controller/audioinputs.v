module audioinputs(input CLOCK_50, input [3:0]KEY, input
AUD_ADCDAT,

	// Bidirectionals
	AUD_BCLK,
	AUD_ADCLRCK,
	AUD_DACLRCK,
	output [9:0]LEDR,
    output AUD_XCK,
    output AUD_DACDAT,
//    note_in, note, octave, amplitude, attack, decay, sustain, rel,
    output [6:0] wave
);
	wire reset;
	assign reset = KEY[0];
	wire clock;
	assign clock = CLOCK_50;
	assign LEDR[0] = reset;
wire[6:0] wave_out;
//create a module that has all of ALU inputs
//wire called waveout send the wire into the audio controller to get an output

ALUcontroller a(clock, reset, 1'b1, 4'b0000, 3'b100, 6'b111111, 6'b111111, 6'b000000, 6'b000000, 6'b000000, wave_out);
//feed wave_out into audio controller but before that change wave_out into a 32 bit input because wave_out is currently 7bits add 0's
//take in wave out and feed it in the audio out

    
assign wave = {wave_out, 26'b0};
    

Audio_Controller a1(// Inputs
	.CLOCK_50(clock), //system clock input, must be 50Mhz for the tiing control to work properly
	.reset(~reset),//active high reset

	.clear_audio_in_memory(0),	//clears the audio input buffer WILL BE 0
	.read_audio_in(0), //WILL BE 0 (reads enable signal)
	//placed on the data lines on the next clock cycle

	.clear_audio_out_memory(0),//clear the audio output
	.left_channel_audio_out(wave), //audio data recieved from external source 32BITS
	.right_channel_audio_out(wave),//32 BITS
	.write_audio_out(1),//enable signal for writing the new data -->level-sensitive data is written on every clock edge when this signal is high

//off-chip lines to be connected to the corresponding named pins (FIND THE PINS)

	.AUD_ADCDAT(AUD_ADCDAT),

	// Bidirectionals
	.AUD_BCLK(AUD_BCLK),
	.AUD_ADCLRCK(AUD_ADCLRCK),
	.AUD_DACLRCK(AUD_DACLRCK),

	// Outputs
	//.left_channel_audio_in(33'd0),
	//.right_channel_audio_in(33'd0),
	//.audio_in_available(0),

	//.audio_out_allowed(0), //indicates when the data ma be written. Write will hae no effect unless this signal is high
//
//	.AUD_XCK(AUD_XCK),
//	.AUD_DACDAT(AUD_DACDAT)
);
endmodule
