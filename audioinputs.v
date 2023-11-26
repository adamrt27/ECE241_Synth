module audio(input clock, reset, 
AUD_ADCDAT,

	// Bidirectionals
	AUD_BCLK,
	AUD_ADCLRCK,
	AUD_DACLRCK,
    output AUD_XCK,
    output AUD_DACDAT,
    note_in, note, octave, amplitude, attack, decay, sustain, rel,
    output [6:0] wave
);
wire reg[6:0] wave_out
//create a module that has all of ALU inputs
//wire called waveout send the wire into the audio controller to get an output
ALUcontroller a(clock, reset, note_in, note, octave, amplitude, attack, decay, sustain, rel, wave_out);
//feed wave_out into audio controller but before that change wave_out into a 32 bit input because wave_out is currently 7bits add 0's
//take in wave out and feed it in the audio out
always @(posedge clock) begin
    
        wave_out <= {26'b0, wave_out};
    
end
assign wave = wave_out;
Audio_Controller a(// Inputs
	.CLOCK_50(clock), //system clock input, must be 50Mhz for the tiing control to work properly
	.reset(reset),//active high reset

	.clear_audio_in_memory(0),	//clears the audio input buffer WILL BE 0
	.read_audio_in(0), //WILL BE 0 (reads enable signal)
	//placed on the data lines on the next clock cycle

	.clear_audio_out_memory(0),//clear the audio output
	.left_channel_audio_out(wave_out), //audio data recieved from external source 32BITS
	.right_channel_audio_out(wave_out),//32 BITS
	.write_audio_out(0),//enable signal for writing the new data -->level-sensitive data is written on every clock edge when this signal is high

//off-chip lines to be connected to the corresponding named pins (FIND THE PINS)

	.AUD_ADCDAT(AUD_ADCDAT),

	// Bidirectionals
	.AUD_BCLK(AUD_BCLK),
	.AUD_ADCLRCK(AUD_ADCLRCK),
	.AUD_DACLRCK(AUD_DACLRCK),

	// Outputs
	.left_channel_audio_in(33d'0),
	.right_channel_audio_in(33d'0),
	.audio_in_available(0),

	.audio_out_allowed(0), //indicates when the data ma be written. Write will hae no effect unless this signal is high

	.AUD_XCK(AUD_XCK),
	.AUD_DACDAT(AUD_DACDAT)
);