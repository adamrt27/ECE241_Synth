module IO_controller(input clk, input reset, output [6:0] HEX);

    // setting up PS2 inputs

    // setting up ALUcontroller
    
    // wire inputs to ALUcontroller
    wire note_in;
    wire [3:0] note;
    wire [2:0] octave;
    wire [5:0] amplitude;
    wire [5:0] attack;
    wire [5:0] decay;
    wire [5:0] sustain;
    wire [5:0] rel;

    // wire ouputs from ALUcontroller
    wire [6:0] wave_out;

    // reg inputs for changing "slider" values (ie values that are not set absolutely, but adjusted via slider, eg octave, amplitude)
    reg octave_plus_plus; // if 1, increment octave by 1, else dont change
    reg octave_minus_minus; // if 1 decrease octave by 1, else dont change
    reg amp_plus_plus; // if 1 increase amplitude by 1, else dont change
    reg amp_minus_minus; // if 1 decrease amplitude by 1
    reg [1:0] ADSR_selector; // if 0 - change attack
                              //    1 - change decay
                              //    2 - change sustain
                              //    3 - change release
    reg ADSR_plus_plus; // if 1, increment selected ADSR by 1
    reg ADSR_minus_minus;  // if 1, decrease selected ADSR by 1
    
    // the following values are stored in reg so they can be changed via +/- buttons instead of absolute values
    reg [2:0] octave_reg;
    reg [5:0] amplitude_reg;
    reg [5:0] attack_reg;
    reg [5:0] decay_reg;
    reg [5:0] sustain_reg;
    reg [5:0] release_reg;

    always@(posedge clk) begin
        if (!reset) begin // setting defaults
                          // octave: 4 (if note is 0 then plays middle c)
                          // amplitude: 63 (max amplitude)
                          // attack: 63 (plays instantly)
                          // decay: 0 (no decay)
                          // sustain: 63 (same as max amplitude)
                          // release: 63 (no release)
            octave_reg <= 3'd4;
            amplitude_reg <= 6'd63;
            attack_reg <= 6'd63;
            decay_reg <= 0;
            sustain_reg <= 6'd63;
            release_reg <= 6'd63;
        end
        else // updating values of octave, amplitude, and ADSR
            octave_reg <= octave_reg + octave_plus_plus - octave_minus_minus;
            amplitude_reg <= amplitude_reg + amp_plus_plus - amp_minus_minus;
            case (ADSR_selector) 
                0: // attack
                    attack_reg <= attack_reg + ADSR_plus_plus - ADSR_minus_minus;
                1: // decay
                    decay_reg <= decay_reg + ADSR_plus_plus - ADSR_minus_minus;
                2: // sustain
                    sustain_reg <= sustain_reg + ADSR_plus_plus - ADSR_minus_minus;
                3: // release
                    release_reg <= release_reg + ADSR_plus_plus - ADSR_minus_minus;
            endcase
    end

    // assigning the reg's to wires so they can be fed into ALU controller
    assign octave = octave_reg;
    assign amplitude = amplitude_reg;
    assign attack = attack_reg;
    assign decay = decay_reg;
    assign sustain = sustain_reg;
    assign rel = release_reg;

    ALUcontroller a(clk, reset, note_in, note, octave, amplitude, attack, decay, sustain, rel, wave_out);

    // setting up audio ouput

    // setting up video ouput

    // setting up HEX and LEDR output

    // we want octave on hex0, amplitude on hex1, attack on hex2, decay on hex3, sustain on hex4, release on hex5

    // octave
    hex_decoder hex_octave(octave, HEX[0]);

    // amplitude, have to make into a 4 bit, so shift by two bits right
    wire [3:0] amplitude_hex;
    assign amplitude_hex = amplitude >> 2;

    hex_decoder hex_amplitude(amplitude_hex, HEX[1]);

    // attack, same as amplitude
    wire [3:0] attack_hex;
    assign attack_hex = attack >> 2;

    hex_decoder hex_amplitude(attack_hex, HEX[2]);

    // decay, same as amplitude
    wire [3:0] decay_hex;
    assign decay_hex = decay >> 2;

    hex_decoder hex_amplitude(decay_hex, HEX[3]);

    // sustain, same as amplitude
    wire [3:0] sustain_hex;
    assign sustain_hex = sustain >> 2;

    hex_decoder hex_amplitude(sustain_hex, HEX[4]);

    // release, same as amplitude
    wire [3:0] rel_hex;
    assign rel_hex = rel >> 2;

    hex_decoder hex_amplitude(rel_hex, HEX[5]);

endmodule