module hex_decoder(c, display);
	
	// setting inputs and outputs
	input[3:0]c;
	output[6:0]display;
	
	// creating wires
	wire M0, M1, M2, M3, M4, M5, M6, M7, M8, M9, MA, Mb, MC, Md, ME, MF;

	// assigning hexadecimal
	assign M0 = ~(c[3] | c[2] | c[1] | c[0]);
	assign M1 = ~(c[3] | c[2] | c[1] | ~c[0]);
	assign M2 = ~(c[3] | c[2] | ~c[1] | c[0]);
	assign M3 = ~(c[3] | c[2] | ~c[1] | ~c[0]);
	assign M4 = ~(c[3] | ~c[2] | c[1] | c[0]);
	assign M5 = ~(c[3] | ~c[2] | c[1] | ~c[0]);
	assign M6 = ~(c[3] | ~c[2] | ~c[1] | c[0]);
	assign M7 = ~(c[3] | ~c[2] | ~c[1] | ~c[0]);
	assign M8 = ~(~c[3] | c[2] | c[1] | c[0]);
	assign M9 = ~(~c[3] | c[2] | c[1] | ~c[0]);
	assign MA = ~(~c[3] | c[2] | ~c[1] | c[0]);
	assign Mb = ~(~c[3] | c[2] | ~c[1] | ~c[0]);
	assign MC = ~(~c[3] | ~c[2] | c[1] | c[0]);
	assign Md = ~(~c[3] | ~c[2] | c[1] | ~c[0]);
	assign ME = ~(~c[3] | ~c[2] | ~c[1] | c[0]);
	assign MF = ~(~c[3] | ~c[2] | ~c[1] | ~c[0]);

	// assigning outputs
	assign display[0] = (M1 | M4 | Mb | Md);
	assign display[1] = (M5 | M6 | MC | ME | MF);
	assign display[2] = (M2 | MC | ME | MF);
	assign display[3] = (M1 | M4 | M7 | M9 | MA | MF);
	assign display[4] = (M1 | M3 | M4 | M5 | M7 | M9);
	assign display[5] = (M1 | M2 | M3 | M7 | Md);
	assign display[6] = (M0 | M1 | M7 | MC);

endmodule
