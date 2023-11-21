// this module gets the frequency of a note, given the note letter and the octave.
// note 0 corresponds with C and octave 0 corresponds octave 0.

module frequency_getter(input clk,
                        input reset,
                        input [3:0]note,
                        input [2:0]octave,
                        output [15:0]frequency);
                        
    reg [20:0] TABLE [0:108];
    
	initial begin 
		TABLE[0] = 21'd16; 
		TABLE[1] = 21'd17; 
		TABLE[2] = 21'd18; 
		TABLE[3] = 21'd19; 
		TABLE[4] = 21'd21; 
		TABLE[5] = 21'd22; 
		TABLE[6] = 21'd23; 
		TABLE[7] = 21'd24; 
		TABLE[8] = 21'd26; 
		TABLE[9] = 21'd28; 
		TABLE[10] = 21'd29; 
		TABLE[11] = 21'd31; 
		TABLE[12] = 21'd33; 
		TABLE[13] = 21'd35; 
		TABLE[14] = 21'd37; 
		TABLE[15] = 21'd39; 
		TABLE[16] = 21'd41; 
		TABLE[17] = 21'd44; 
		TABLE[18] = 21'd46; 
		TABLE[19] = 21'd49; 
		TABLE[20] = 21'd52; 
		TABLE[21] = 21'd55; 
		TABLE[22] = 21'd58; 
		TABLE[23] = 21'd62; 
		TABLE[24] = 21'd65; 
		TABLE[25] = 21'd69; 
		TABLE[26] = 21'd73; 
		TABLE[27] = 21'd78; 
		TABLE[28] = 21'd82; 
		TABLE[29] = 21'd87; 
		TABLE[30] = 21'd92; 
		TABLE[31] = 21'd98; 
		TABLE[32] = 21'd104; 
		TABLE[33] = 21'd110; 
		TABLE[34] = 21'd116; 
		TABLE[35] = 21'd124; 
		TABLE[36] = 21'd131; 
		TABLE[37] = 21'd139; 
		TABLE[38] = 21'd147; 
		TABLE[39] = 21'd156; 
		TABLE[40] = 21'd165; 
		TABLE[41] = 21'd175; 
		TABLE[42] = 21'd185; 
		TABLE[43] = 21'd196; 
		TABLE[44] = 21'd208; 
		TABLE[45] = 21'd220; 
		TABLE[46] = 21'd233; 
		TABLE[47] = 21'd247; 
		TABLE[48] = 21'd262; 
		TABLE[49] = 21'd277; 
		TABLE[50] = 21'd294; 
		TABLE[51] = 21'd311; 
		TABLE[52] = 21'd330; 
		TABLE[53] = 21'd349; 
		TABLE[54] = 21'd370; 
		TABLE[55] = 21'd392; 
		TABLE[56] = 21'd415; 
		TABLE[57] = 21'd440; 
		TABLE[58] = 21'd466; 
		TABLE[59] = 21'd494; 
		TABLE[60] = 21'd523; 
		TABLE[61] = 21'd554; 
		TABLE[62] = 21'd587; 
		TABLE[63] = 21'd622; 
		TABLE[64] = 21'd659; 
		TABLE[65] = 21'd698; 
		TABLE[66] = 21'd740; 
		TABLE[67] = 21'd784; 
		TABLE[68] = 21'd831; 
		TABLE[69] = 21'd880; 
		TABLE[70] = 21'd932; 
		TABLE[71] = 21'd988; 
		TABLE[72] = 21'd1047; 
		TABLE[73] = 21'd1109; 
		TABLE[74] = 21'd1175; 
		TABLE[75] = 21'd1245; 
		TABLE[76] = 21'd1319; 
		TABLE[77] = 21'd1397; 
		TABLE[78] = 21'd1480; 
		TABLE[79] = 21'd1568; 
		TABLE[80] = 21'd1661; 
		TABLE[81] = 21'd1760; 
		TABLE[82] = 21'd1865; 
		TABLE[83] = 21'd1976; 
		TABLE[84] = 21'd2093; 
		TABLE[85] = 21'd2217; 
		TABLE[86] = 21'd2349; 
		TABLE[87] = 21'd2489; 
		TABLE[88] = 21'd2637; 
		TABLE[89] = 21'd2794; 
		TABLE[90] = 21'd2960; 
		TABLE[91] = 21'd3136; 
		TABLE[92] = 21'd3322; 
		TABLE[93] = 21'd3520; 
		TABLE[94] = 21'd3729; 
		TABLE[95] = 21'd3951; 
		TABLE[96] = 21'd4186; 
		TABLE[97] = 21'd4435; 
		TABLE[98] = 21'd4699; 
		TABLE[99] = 21'd4978; 
		TABLE[100] = 21'd5274; 
		TABLE[101] = 21'd5588; 
		TABLE[102] = 21'd5920; 
		TABLE[103] = 21'd6272; 
		TABLE[104] = 21'd6645; 
		TABLE[105] = 21'd7040; 
		TABLE[106] = 21'd7459; 
		TABLE[107] = 21'd7902; 
	end 

	assign frequency = TABLE[note*octave]; 

endmodule