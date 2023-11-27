module controller(clk,
	reset,

	wait_for_incoming_data,
	start_receiving_data,

	ps2_clk_posedge,
	ps2_clk_negedge,
	ps2_data,

	// Bidirectionals

	// Outputs
	received_data,
	received_data_en			// If 1 - new data has been received
);


input			CLOCK_50;
input			reset;

input	[7:0]	the_command;
input			send_command;

// Bidirectionals
inout			PS2_CLK;
inout		 	PS2_DAT;

// Outputs
output			command_was_sent;
output			error_communication_timed_out;

output	[7:0]	received_data;
output		 	received_data_en;

if(the_command == 2'h1C) 
	//note is A
if(the_command == 2'h1D)
	//note is A+
if(the_command == 2'h1B)