
module vgadisplay(iResetn,iClock,note,note_in,octave_plus_plus,octave_minus_minus,
                  ADSR_plus_plus,ADSR_minus_minus,ADSR_selector,oX,oY,oColour,oPlot,state);
   // Inputs
   input iResetn;
   input iClock;
   input [3:0]note;
	input note_in;
   input octave_plus_plus;
   input octave_minus_minus;
   input [2:0] ADSR_selector;
   input ADSR_plus_plus;
   input ADSR_minus_minus;
   
   // Outputs
   output [8:0] oX;          // VGA pixel coordinates
   output [7:0] oY;
   output [2:0] oColour;      // VGA pixel colour (0-7)
   output oPlot; 
	output [3:0] state;
	// Pixel draw enable

   // Internal wires
   wire ld_draw, ld_piano;
   wire [4:0] counter;
	wire [16:0] address;


   // Instantiate control module
   ctrl C0(
      .iClock(iClock),
      .iResetn(iResetn),
		.note_in(note_in),
		.address(address),
      .ld_draw(ld_draw),
		.ld_piano(ld_piano),
      .counter(counter),
		.state(state)
   );

   // Instantiate datapath module
   data D0(
      .iClock(iClock),
      .iResetn(iResetn),
      .ld_draw(ld_draw),
		.ld_piano(ld_piano),
		.note(note),
		.octave_plus_plus(octave_plus_plus),
		.ADSR_plus_plus(ADSR_plus_plus),
		.octave_minus_minus(octave_minus_minus),
		.ADSR_minus_minus(ADSR_minus_minus),
      .oX(oX),
      .oY(oY),
      .oColour(oColour),
      .oPlot(oPlot),
      .counter(counter),
		.address(address)
   );

				

endmodule // part2

// Control Module
module ctrl(
   input iClock,
   input iResetn,
   input note_in,
	input [16:0] address,
   input [4:0] counter,
   output reg ld_draw,
	output reg ld_piano,
	output [3:0] state
);
reg [3:0] next_state = 4'b0000;
 reg [3:0] cur_state = 4'b0000;
 assign state = cur_state;


   // Define states
   localparam A = 4'b0000, B = 4'b0001, C = 4'b0010, D = 4'b0011;
   always @(*)
   begin: state_table

      // State transition logic
      case (cur_state)
         A: begin
            if (note_in) next_state = B;
            else next_state = A;
         end
         B: begin // draw
            next_state = (counter <= 5'b01111) ? B : C;
         end
         C: begin // wait for note release
            next_state = (note_in) ? C : D;
         end
         D: begin // erase
            next_state = (address <= 17'd76800) ? D : A;
         end
			
         default: next_state = A;
      endcase
   end // state_table

   always @(*)
   begin: enable_signals
      // Initialize signals to 0 by default
      ld_draw = 0;
		ld_piano = 0;

      // Output control based on the current state
      case (cur_state)
         B: begin
            ld_draw = 1;
				ld_piano = 0;
         end
			D: begin
				ld_draw=0;
				ld_piano = 1;
			end
         default: begin
            ld_draw = 0;
				ld_piano = 0;
         end
      endcase
   end // enable_signals

   always @(posedge iClock)
   begin: state_FFs
      if(iResetn == 1'b0) begin
         cur_state <= A; // Set reset state to state A
      end
      else begin
         cur_state <= next_state;
      end
   end // state_FFs

endmodule


// Datapath Module
module data(
   input iClock,
   input iResetn,
   input ld_draw, ld_piano,
	input [3:0] note,
	input octave_plus_plus,
	input octave_minus_minus,
	input ADSR_plus_plus,
	input ADSR_minus_minus,
   output reg [8:0] oX,         // VGA pixel coordinates
   output reg [7:0] oY,
   output reg [2:0] oColour,     // VGA pixel colour (0-7)
   output reg oPlot,       // Pixel draw enable
   output reg [4:0] counter,
	output reg [16:0] address
);

//Counters to re-print piano on screen
reg [8:0] xCount;
reg [7:0] yCount;


// Internal wires for VGA pixel coordinates based on note
reg [8:0] vga_x_position;
reg [7:0] vga_y_position;

// Logic to determine VGA pixel coordinates based on note
always @* begin
    case (note)
        4'b0000: begin
            vga_x_position <= 9'd66;
            vga_y_position <= 8'd124;
        end
        4'b0001: begin
            vga_x_position <= 9'd81;
            vga_y_position <= 8'd96;
        end
        4'b0010: begin
            vga_x_position <= 9'd99;
            vga_y_position <= 8'd124;
        end
        4'b0011: begin
            vga_x_position <= 9'd112;
            vga_y_position <= 8'd96;
        end
        4'b0100: begin
            vga_x_position <= 9'd131;
            vga_y_position <= 8'd124;
        end
        4'b0101: begin
            vga_x_position <= 9'd161;
            vga_y_position <= 8'd124;
        end
        4'b0110: begin
            vga_x_position <= 9'd174;
            vga_y_position <= 8'd96;
        end
        4'b0111: begin
            vga_x_position <= 9'd192;
            vga_y_position <= 8'd124;
        end
        4'b1000: begin
            vga_x_position <= 9'd209;
            vga_y_position <= 8'd96;
        end
        4'b1001: begin
            vga_x_position <= 9'd224;
            vga_y_position <= 8'd124;
        end
        4'b1010: begin
            vga_x_position <= 9'd245;
            vga_y_position <= 8'd96;
        end
        4'b1011: begin
            vga_x_position <= 9'd254;
            vga_y_position <= 8'd124;
        end
        default: begin
            vga_x_position <= 9'd0;
            vga_y_position <= 8'd0;
        end

    endcase
                    
		  // Octave adjustments
		  if (octave_plus_plus) begin
			 vga_x_position <= 9'd103;
			 vga_y_position <= 8'd169;
		 end
		  if (octave_minus_minus) begin
				vga_x_position <= 9'd71;
				vga_y_position <= 8'd169;
			end
					  
					  
			// ADSR adjustments
					  
			if (ADSR_plus_plus) begin
				 vga_x_position <= 9'd183;
				 vga_y_position <= 8'd169;
			end
		 
			if (ADSR_minus_minus) begin
				vga_x_position <= 9'd153;
				vga_y_position <= 8'd169;
		  end

end

	wire [2:0] piano_col;
	memory m0(.address(address), .clock(iClock), .q(piano_col));
	
	always @(posedge iClock) begin
	    if(!ld_piano)
		     address <= 0;
		 else if(ld_piano && address <= 17'd76800)
		     address <= address + 17'd1;
	end
	
		
   always @(posedge iClock) begin
   if(~iResetn) begin
      // Initialization on reset
      oPlot <= 1'b0;
      oColour <= 3'b000;
      oX <= 9'b000000000; // Set VGA pixel X-coordinate based on note
      oY <= 8'b00000000; // Set VGA pixel Y-coordinate based on note
      counter <= 5'd00000;
		xCount <= 9'd0;
		yCount <= 8'd0;
   end
   else if(ld_draw) begin
      // Logic for drawing in yellow
      oPlot = 1'b1;
      if (counter <= 5'b01111) begin
         oColour <= 3'b110;
		counter <= counter + 1;
         // Set initial values during the first cycle
         if (counter == 5'd0) begin
            oX <= vga_x_position + counter[1:0]; // Adjust based on your requirements
            oY <= vga_y_position + counter[3:2]; // Adjust based on your requirements
         end
      end
      else begin
         // Reset counter when not drawing
         counter <= 5'd0;
      end
   end
  else if(ld_piano) begin
      oPlot = 1'b1;
      if (xCount <= 9'd319 && yCount <= 8'd239) begin
         //oColour <= 3'b110; // Set the color to yellow (RGB: 001)
         // Set initial values during the first cycle
			
			
			if(xCount == 9'd319) begin
				xCount = 0;
			    yCount = yCount + 8'd1;
			 end
			else if(xCount == 9'd319 && yCount == 8'd239)begin
			    xCount = xCount + 9'd1;
				yCount = yCount + 8'd1;
			end
			xCount = xCount + 9'd1;
         if (address < 17'd76800) begin
            oX <= xCount; // Adjust based on your requirements
            oY <= yCount;
			   oColour <= piano_col;	// Adjust based on your requirements
         end
      end
  end
  else if(!ld_piano)begin
      xCount <= 9'd0;
		yCount <= 8'd0;
  end
end


endmodule
