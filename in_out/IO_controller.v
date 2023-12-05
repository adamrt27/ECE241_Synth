
module IO_controller(
    // general inputs
    input CLOCK_50, 
    input [3:0] KEY, 
    input [9:0] SW,

    // Inputs (audio & ps2)
	input				AUD_ADCDAT,

	// Bidirectionals (audio)
	inout				AUD_BCLK,
	inout				AUD_ADCLRCK,
	inout				AUD_DACLRCK,

	inout				FPGA_I2C_SDAT,

	// Outputs(audio)
	output				AUD_XCK,
	output				AUD_DACDAT,

	output				FPGA_I2C_SCLK,
	// bidirectionals(ps2)
	inout				PS2_CLK,
	inout				PS2_DAT,

    // hex display & lights
	output [6:0] HEX0, 
	output [6:0] HEX1, 
	output [6:0] HEX2, 
	output [6:0] HEX3, 
	output [6:0] HEX4, 
	output [6:0] HEX5, 
	output [9:0] LEDR,

	output VGA_CLK,
	output VGA_HS,
	output VGA_VS,
	output VGA_BLANK_N,
	output VGA_SYNC_N,
	output [7:0] VGA_R,
	output [7:0] VGA_G,
	output [7:0] VGA_B
    );
	
	
	// wires for general stuff

    wire clk;
    assign clk = CLOCK_50;
    wire reset;
    assign reset = KEY[0];
	 
	// ************************************************************************************************************************************ 
    // setting up PS2 inputs
	 
    //call the PS2 inputs module
    ps2 p0(.CLOCK_50(CLOCK_50),
    .KEY(KEY),

    // Bidirectionals
    .PS2_CLK(PS2_CLK),
    .PS2_DAT(PS2_DAT),
            .note(note),
            .octave_minus_minus(octave_minus_minus),
            .octave_plus_plus(octave_plus_plus),
            .note_in(note_in), 
            .ADSR_minus_minus(ADSR_minus_minus),
            .ADSR_plus_plus(ADSR_plus_plus),
            .ADSR_selector(ADSR_selector)
    );

    // feed into: note_in, note, octave_plus_plus, octave_minus_minus, ADSR_selector, ADSR_plus_plus, ADSR_minus_minus

    // ************************************************************************************************************************************ 
    // setting up switches inputs

	 wire note_in_override;
	 
    assign sine = SW[0];
    assign overdrive = SW[2:1];
	 assign note_in_override = SW[3];

    // ************************************************************************************************************************************
    // setting up ALUcontroller
    // inputs needed for this!
    // wire inputs to ALUcontroller
    
    wire note_in;
    wire [3:0] note;
    wire [2:0] octave;
    wire [30:0] amplitude;
    wire [30:0] attack;
    wire [30:0] decay;
    wire [30:0] sustain;
    wire [30:0] rel;    
    wire sine;
    wire [1:0] overdrive;

    // wire ouputs from ALUcontroller
    wire [31:0] wave_out;

    // wire inputs for changing "slider" values (ie values that are not set absolutely, but adjusted via slider, eg octave, amplitude)
    wire octave_plus_plus; // if 1, increment octave by 1, else dont change 
    wire octave_minus_minus; // if 1 decrease octave by 1, else dont change
    wire [2:0] ADSR_selector; // if 0 - change amplitude/volume
                              //    1 - change attack
                              //    2 - change decay
                              //    3 - change sustain
                              //    4 - change release
    wire ADSR_plus_plus; // if 1, increment selected ADSR by 1
    wire ADSR_minus_minus;  // if 1, decrease selected ADSR by 1
    
    // the following values are stored in reg so they can be changed via +/- buttons instead of absolute values
    reg [2:0] octave_reg;
    reg [30:0] amplitude_reg;
    reg [30:0] attack_reg;
    reg [30:0] decay_reg;
    reg [30:0] sustain_reg;
    reg [30:0] release_reg;

    // creating a clk that pulses every second for octave
    wire second_clk;
    s_clk clk_second(clk, reset, second_clk);

    always@(posedge clk) begin
        if (~reset) begin // setting defaults
                          // octave: 4 (if note is 0 then plays middle c)
                          // amplitude: max (max amplitude)
                          // attack: max (plays instantly)
                          // decay: 0 (no decay)
                          // sustain: max (same as max amplitude)
                          // release: max (no release)
            octave_reg <= 3'd4;
            amplitude_reg <= 31'd1073741824; // setting to max value
            attack_reg <= 31'd1073741824;
            decay_reg <= 0;
            sustain_reg <= 31'd1073741824;
            release_reg <= 31'd1073741824;
        end
        else // updating values of octave, amplitude, and ADSR
            if (second_clk)
                octave_reg <= octave_reg + (octave_plus_plus) - (octave_minus_minus);
            // purpose of 1 << 24 is to make each setting essentially 8 bits, instead of 32.
            case (ADSR_selector) 
                0: // amplitude
                    amplitude_reg <= amplitude_reg + (ADSR_plus_plus * (10)) - (ADSR_minus_minus * (10));
                1: // attack
                    attack_reg <= attack_reg + (ADSR_plus_plus * (10)) - (ADSR_minus_minus * (10));
                2: // decay
                    decay_reg <= decay_reg + (ADSR_plus_plus * (10)) - (ADSR_minus_minus * (10));
                3: // sustain
                    sustain_reg <= sustain_reg + (ADSR_plus_plus * (10)) - (ADSR_minus_minus * (10));
                4: // release
                    release_reg <= release_reg + (ADSR_plus_plus * (10)) - (ADSR_minus_minus * (10));
            endcase
    end

    // assigning the reg's to wires so they can be fed into ALU controller
    assign octave = octave_reg;
    assign amplitude = amplitude_reg;
    assign attack = attack_reg;
    assign decay = decay_reg;
    assign sustain = sustain_reg;
    assign rel = release_reg;

    // loading everything into ALUcontroller
    ALUcontroller a(.clk(clk), 
        .reset(reset), 
        .note_in(note_in || note_in_override), 
        .note(note), 
        .octave(octave), 
        .amplitude(amplitude), 
        .attack(attack), 
        .decay(decay), 
        .sustain(sustain), 
        .rel(rel),  
        .sine(sine),
        .overdrive(overdrive),
        .wave_out(wave_out)
    );

    // ************************************************************************************************************************************
    // setting up audio ouput
    DE1_SoC_Audio_Example aud(
        // Inputs
        .CLOCK_50(CLOCK_50),
        .KEY(KEY),
        .wave_out(wave_out),
        .AUD_ADCDAT(AUD_ADCDAT),
        // Bidirectionals
        .AUD_BCLK(AUD_BCLK),
        .AUD_ADCLRCK(AUD_ADCLRCK),
        .AUD_DACLRCK(AUD_DACLRCK),

        .FPGA_I2C_SDAT(FPGA_I2C_SDAT),

        // Outputs
        .AUD_XCK(AUD_XCK),
        .AUD_DACDAT(AUD_DACDAT),

        .FPGA_I2C_SCLK(FPGA_I2C_SCLK)
        //SW was deleted
    );
    //call the audio module with an input called wave_out and add all of the inputs and outputs from that necessarry into 
    //this module
    // DE1_SoC_Audio_Example (s)

    //make another module that inputs all of his inputs
    //and use each variable accordingly

    // ************************************************************************************************************************************
    // setting up video ouput

    //VGA
	wire [2:0] colour;
	wire [8:0] x;
	wire [7:0] y;
	wire writeEn;

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
			.resetn(reset),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
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
		defparam VGA.BACKGROUND_IMAGE = "piano1.mif";

    // ************************************************************************************************************************************
    // setting up HEX and LEDR output

    // HEX
    // we want octave on hex0, amplitude on hex1, attack on hex2, decay on hex3, sustain on hex4, release on hex5

    // octave
    hex_decoder hex_octave(octave, HEX0);

    // amplitude, have to make into a 4 bit, so shift by two bits right
    wire [3:0] amplitude_hex;
    assign amplitude_hex = amplitude[30:27];

    hex_decoder hex_amplitude(amplitude_hex, HEX1);

    // attack, same as amplitude
    wire [3:0] attack_hex;
    assign attack_hex = attack[30:27];

    hex_decoder hex_attack(attack_hex, HEX2);

    // decay, same as amplitude
    wire [3:0] decay_hex;
    assign decay_hex = decay[30:27];

    hex_decoder hex_decay(decay_hex, HEX3);

    // sustain, same as amplitude
    wire [3:0] sustain_hex;
    assign sustain_hex = sustain[30:27];

    hex_decoder hex_sustain(sustain_hex, HEX4);

    // release, same as amplitude
    wire [3:0] rel_hex;
    assign rel_hex = rel[30:27];

    hex_decoder hex_release(rel_hex, HEX5);

    // LEDR
    // set note_in to LEDR 0, and note to LEDR 1-4 for testing
    assign LEDR[0] = note_in || note_in_override;
    assign LEDR[4:1] = note;
	 assign LEDR[7:5] = {overdrive, sine};
	 
	 
endmodule