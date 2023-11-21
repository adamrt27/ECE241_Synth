// this module gets the frequency of a note, given the note letter and the octave. 
// note 0 corresponds with C and octave 0 corresponds octave 0.

module frequency_getter(input [3:0]note,  			// note value: c = 0, c#/dflat = 1, d = 2, etc
						input [2:0]octave, 			// octave value
						output [15:0]frequency);	// frequency output, with fixed point after second L
													// SB bit, i.e. 1635 = 16.35

	// LUT to store frequency values
    reg [20:0] table [0:108];

	// setting up LUT
 	table[0] = 21'd1635; 
	table[1] = 21'd1732; 
	table[2] = 21'd1835; 
	table[3] = 21'd1945; 
	table[4] = 21'd2060; 
	table[5] = 21'd2183; 
	table[6] = 21'd2312; 
	table[7] = 21'd2450; 
	table[8] = 21'd2596; 
	table[9] = 21'd2750; 
	table[10] = 21'd2914; 
	table[11] = 21'd3087; 
	table[12] = 21'd3270; 
	table[13] = 21'd3465; 
	table[14] = 21'd3671; 
	table[15] = 21'd3889; 
	table[16] = 21'd4120; 
	table[17] = 21'd4365; 
	table[18] = 21'd4625; 
	table[19] = 21'd4900; 
	table[20] = 21'd5191; 
	table[21] = 21'd5500; 
	table[22] = 21'd5827; 
	table[23] = 21'd6174; 
	table[24] = 21'd6541; 
	table[25] = 21'd6930; 
	table[26] = 21'd7342; 
	table[27] = 21'd7778; 
	table[28] = 21'd8241; 
	table[29] = 21'd8731; 
	table[30] = 21'd9250; 
	table[31] = 21'd9800; 
	table[32] = 21'd10380; 
	table[33] = 21'd11000; 
	table[34] = 21'd11650; 
	table[35] = 21'd12350; 
	table[36] = 21'd13080; 
	table[37] = 21'd13860; 
	table[38] = 21'd14680; 
	table[39] = 21'd15560; 
	table[40] = 21'd16480; 
	table[41] = 21'd17460; 
	table[42] = 21'd18500; 
	table[43] = 21'd19600; 
	table[44] = 21'd20770; 
	table[45] = 21'd22000; 
	table[46] = 21'd23310; 
	table[47] = 21'd24690; 
	table[48] = 21'd26160; 
	table[49] = 21'd27720; 
	table[50] = 21'd29370; 
	table[51] = 21'd31110; 
	table[52] = 21'd32960; 
	table[53] = 21'd34920; 
	table[54] = 21'd37000; 
	table[55] = 21'd39200; 
	table[56] = 21'd41530; 
	table[57] = 21'd44000; 
	table[58] = 21'd46620; 
	table[59] = 21'd49390; 
	table[60] = 21'd52330; 
	table[61] = 21'd55440; 
	table[62] = 21'd58730; 
	table[63] = 21'd62230; 
	table[64] = 21'd65930; 
	table[65] = 21'd69850; 
	table[66] = 21'd74000; 
	table[67] = 21'd78400; 
	table[68] = 21'd83060; 
	table[69] = 21'd88000; 
	table[70] = 21'd93230; 
	table[71] = 21'd98780; 
	table[72] = 21'd104700; 
	table[73] = 21'd110900; 
	table[74] = 21'd117500; 
	table[75] = 21'd124500; 
	table[76] = 21'd131900; 
	table[77] = 21'd139700; 
	table[78] = 21'd148000; 
	table[79] = 21'd156800; 
	table[80] = 21'd166100; 
	table[81] = 21'd176000; 
	table[82] = 21'd186500; 
	table[83] = 21'd197600; 
	table[84] = 21'd209300; 
	table[85] = 21'd221700; 
	table[86] = 21'd234900; 
	table[87] = 21'd248900; 
	table[88] = 21'd263700; 
	table[89] = 21'd279400; 
	table[90] = 21'd296000; 
	table[91] = 21'd313600; 
	table[92] = 21'd332200; 
	table[93] = 21'd352000; 
	table[94] = 21'd372900; 
	table[95] = 21'd395100; 
	table[96] = 21'd418600; 
	table[97] = 21'd443500; 
	table[98] = 21'd469900; 
	table[99] = 21'd497800; 
	table[100] = 21'd527400; 
	table[101] = 21'd558800; 
	table[102] = 21'd592000; 
	table[103] = 21'd627200; 
	table[104] = 21'd664500; 
	table[105] = 21'd704000; 
	table[106] = 21'd745900; 
	table[107] = 21'd790200; 

	// assigning frequency output
	assign frequency = table[note*octave]; 

endmodule