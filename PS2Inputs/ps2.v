module ps2(input CLOCK_50,
input		[3:0]	KEY,

// Bidirectionals
inout				PS2_CLK,
inout				PS2_DAT,
    output reg [3:0] note,
    output reg octave_minus_minus,
    output reg octave_plus_plus,
    output reg note_in, 
    output reg ADSR_minus_minus,
    output reg ADSR_plus_plus,
    output reg [2:0] ADSR_selector
    //[2:0]ADSR: if you click key 1 it gives 0, 2 gives you 1, 3 gives you 2 etc.
    );
    wire [7:0] eightbit;//this was changed from original
	wire temp_note_in;
	 
    PS2_Demo a(.CLOCK_50(CLOCK_50), .KEY(KEY), .PS2_CLK(PS2_CLK), .PS2_DAT(PS2_DAT), .ps2_key_pressed(temp_note_in), 
    .last_data_received(eightbit));
	 

   
    always@(posedge PS2_CLK) begin
	 	 note_in = temp_note_in;
        if (~KEY[0]) begin // setting defaults
            note <= 4'b0000;
            octave_minus_minus <= 0;
            octave_plus_plus <= 0;
            ADSR_minus_minus <= 0;
            ADSR_plus_plus <= 0;
            ADSR_selector <= 0;
            note_in <= 0;
        end
        else begin // updating values of octave, amplitude, and ADSR
            note_in <= 0;
            octave_minus_minus <= 0;
            octave_plus_plus <= 0;
            ADSR_minus_minus <= 0;
            ADSR_plus_plus <= 0;
            case (eightbit) 
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
                    note_in <= 0;
                end
                8'h22: //oxtavplusplus is x
                begin
                    octave_plus_plus <= 1;
                    note_in <= 0;
                end
                8'h16: //ASDR1 is 0 which is volume key 1(number)
                begin
                    ADSR_selector <= 3'b000;
                    note_in <= 0;
                end
                8'h1E: //ASDR2 is 1 which is attack which is key 2(number)
                begin
                    ADSR_selector <= 3'b001;
                    note_in <= 0;
                end
                8'h26: //D which is key 3
                begin
                    ADSR_selector <= 3'b010;
                    note_in <= 0;
                end
                8'h25: //S which is key 4
                begin
                    ADSR_selector <= 3'b011;
                    note_in <= 0;
                end
                8'h2E: //R which is key 5
                begin
                    ADSR_selector <= 3'b100;
                    note_in <= 0;
                end
                8'h21: //c which is key minus for ADSR
                begin
                    note_in <= 0;
                    ADSR_minus_minus <= 1;
                end
                8'h2A: //v which is key plus for ADSR
                begin
                    note_in <= 0;
                    ADSR_plus_plus <= 1;
                end
            
        endcase
        end
    end
    endmodule
