module ps2(CLOCK_50,
	KEY,

	// Bidirectionals
	PS2_CLK,
	PS2_DAT,
    output reg [3:0] note,
    output reg octave_minus_minus,
    output reg octave_plus_plus,
    output reg note_in, 
    output reg amp_minus_minus,
    output reg amp_plus_plus
    );
    wire [7:0] 8bit;//this was changed from original

    PS2_Demo a(.CLOCK_50(CLOCK_50), .KEY(KEY), .PS2_CLK(PS2_CLK), .PS2_DAT(PS2_DAT), .ps2_key_pressed(note_in), 
    .last_data_received(8bit));

    always@(posedge PS2_CLK) begin
        if (!KEY) begin // setting defaults
            note <= 4'b0000;
            octave_minus_minus <= 0;
            octave_plus_plus <= 0;
            note_in <= 0;
        end
        else // updating values of octave, amplitude, and ADSR
            case (8bit) 
                8'h1C: //c letter a
                begin
                    note <= 4'b0000;
                    note_in <= 1;
                end
                8'h1D: //c# letter w
                begin
                    note <= 4'b0001;
                    note_in <= 1;
                end
                8'h1B: //D letter s
                begin
                    note <= 4'b0010;
                    note_in <= 1;
                end
                8'h24: //D# letter e
                begin
                    note <= 4'b0011;
                    note_in <= 1;
                end
                8'h23: //E letter d
                begin
                    note <= 4'b0100;
                    note_in <= 1;
                end
                8'h2B: //F letter f
                begin
                    note <= 4'b0101;
                    note_in <= 1;
                end
                8'h2C: //F# letter t
                begin
                    note <= 4'b0110;
                    note_in <= 1;
                end
                8'h34: //G letter g
                begin
                    note <= 4'b0111;
                    note_in <= 1;
                end
                8'h35: //G# letter y
                begin
                    note <= 4'b1000;
                    note_in <= 1;
                end
                8'h33: //A letter h
                begin
                    note <= 4'b1001;
                    note_in <= 1;
                end
                8'h3C: //A# letter u
                begin
                    note <= 4'b1010;
                    note_in <= 1;
                end
                8'h3B: //B letter j
                begin
                    note <= 4'b1011;
                    note_in <= 1;
                end
                8'h1A: //oxtavminusminus is z
                begin
                    octave_minus_minus <= 1;
                    note_in <= 1;
                end
                8'h22: //oxtavplusplus is x
                begin
                    octave_plus_plus <= 1;
                    note_in <= 1;
                end
                8'h16: //ampminus is 1
                begin
                    amp_minus_minus <= 1;
                    note_in <= 1;
                end
                8'h1E: //ampminus is 2
                begin
                    amp_plus_plus <= 1;
                    note_in <= 1;
                end
            endcase
    end
    endmodule