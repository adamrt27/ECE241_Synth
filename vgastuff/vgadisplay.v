
module vgadisplay(iResetn,iPlotBox,iLoadX,iClock,note,octave_plus_plus,octave_minus_minus,amp_plus_plus,amp_minus_minus,ADSR_selector,
                  ADSR_plus_plus,ADSR_minus_minus,oX,oY,oColour,oPlot,oDone, state);
   // Inputs
   input iResetn, iPlotBox, iLoadX;
   input iClock;
   input note;
   input octave_plus_plus;
   input octave_minus_minus;
   input amp_plus_plus;
   input amp_minus_minus;
   input [2:0] ADSR_selector;
   input ADSR_plus_plus;
   input ADSR_minus_minus;
   
   // Outputs
   output reg [8:0] oX;          // VGA pixel coordinates
   output reg [7:0] oY;
   output reg [2:0] oColour;      // VGA pixel colour (0-7)
   output reg oPlot;              // Pixel draw enable
   output reg oDone;              // Goes high when finished drawing frame
   output reg [3:0] state;        // State information

   // Internal wires
   wire ld_x_reg, ld_y_reg, ld_col_reg, ld_plot, ld_x_out, ld_y_out, ld_col_out, ld_output;
   wire [4:0] counter;

   // Screen dimensions parameters
   parameter X_SCREEN_PIXELS = 8'd320;
   parameter Y_SCREEN_PIXELS = 7'd240;

   assign state = cur_state;

   // Instantiate control module
   control C0(
      .iClock(iClock),
      .iResetn(iResetn),
      .iPlotBox(iPlotBox),
      .iLoadx(iLoadX),
      .ld_x_reg(ld_x_reg),
      .ld_y_reg(ld_y_reg),
      .ld_col_reg(ld_col_reg),
      .ld_plot(ld_plot),
      .ld_x_out(ld_x_out),
      .ld_y_out(ld_y_out),
      .ld_col_out(ld_col_out),
      .ld_output(ld_output),
      .counter(counter),
      .cur_state(cur_state),
      .next_state(next_state)
   );

   // Instantiate datapath module
   datapath D0(
      .iClock(iClock),
      .iResetn(iResetn),
      .ld_x_reg(ld_x_reg),
      .ld_y_reg(ld_y_reg),
      .ld_col_reg(ld_col_reg),
      .ld_plot(ld_plot),
      .ld_x_out(ld_x_out),
      .ld_y_out(ld_y_out),
      .ld_col_out(ld_col_out),
      .ld_output(ld_output),
      .oX(oX),
      .oY(oY),
      .oColour(oColour),
      .oPlot(oPlot),
      .oDone(oDone),
      .counter(counter)
   );

endmodule // part2

// Control Module
module control(
   input iClock,
   input iResetn,
   input iPlotBox,
   input iLoadx,
   output reg ld_x_reg, ld_y_reg, ld_col_reg, ld_plot, ld_x_out, ld_y_out, ld_col_out, ld_output,
   output reg [3:0] cur_state,
   output reg [3:0] next_state
);

   // Define states
   localparam A = 4'b0000, B = 4'b0001, C = 4'b0010, D = 4'b0011, E = 4'b0100, F = 4'b0101, B_WAIT = 4'b1000;

   always @(*)
   begin: state_table
      // State transition logic
      case (cur_state)
         A : begin
            if (iLoadx) next_state = B ;
            else next_state = A;
         end
         B : begin
            if (!iLoadx) next_state = B_WAIT;
            else next_state = B;
         end
         B_WAIT: begin
            if(iPlotBox) next_state = C;
            else next_state = B_WAIT;
         end
         C : begin
            if (!iPlotBox) next_state = D;
            else next_state = C;
         end
         D : begin
            next_state = E;
         end
         E: begin // Loads starting location and color
            next_state = (counter <= 5'b01111) ? E : A;
         end
         default: next_state = A;
      endcase
   end // state_table

   always @(*)
   begin: enable_signals
      // Initialize signals to 0 by default
      ld_x_reg = 1'b0;
      ld_y_reg = 1'b0;
      ld_col_reg = 1'b0;
      ld_x_out = 1'b0;
      ld_y_out = 1'b0;
      ld_col_out = 1'b0;
      ld_plot = 1'b0;

      // Output control based on the current state
      case (cur_state)
         B : begin
            ld_x_reg = 1'b1;
         end
         C : begin
            ld_y_reg = 1'b1;
            ld_col_reg = 1'b1;
         end
         D : begin
            ld_x_out = 1'b1;
            ld_y_out = 1'b1;
            ld_col_out = 1'b1;
         end
         E: begin
            ld_plot = 1'b1;
         end
      endcase
   end // enable_signals

   always @(posedge iClock)
   begin: state_FFs
      if(iResetn == 1'b0) begin
         cur_state <= A; // Set reset state to state A
         ld_output <= 0;
      end
      else begin
         cur_state <= next_state;
      end
   end // state_FFs

endmodule

// Datapath Module
module datapath(
   input iClock,
   input iResetn,
   input ld_x_reg, ld_y_reg, ld_col_reg, ld_plot, ld_x_out, ld_y_out, ld_col_out, ld_output,
   output reg [8:0] oX,         // VGA pixel coordinates
   output reg [7:0] oY,
   output reg [2:0] oColour,     // VGA pixel colour (0-7)
   output reg oPlot,       // Pixel draw enable
   output reg oDone,
   output reg [4:0] counter
);

   // Internal registers
   reg [7:0] x;
   reg [6:0] y;
   reg [2:0] col;

   always @(posedge iClock) begin
      if(!iResetn) begin
         x <= 8'b0;
         y <= 7'b0;
         col <= 3'b0;
      end
   end

// Internal wires for VGA pixel coordinates based on note
wire [8:0] vga_x_position;
wire [7:0] vga_y_position;

// Logic to determine VGA pixel coordinates based on note
always @* begin
    case (note)
        4'b0000: begin
            vga_x_position = 9'd66;
            vga_y_position = 8'd124;
        end
        4'b0001: begin
            vga_x_position = 9'd81;
            vga_y_position = 8'd96;
        end
        4'b0010: begin
            vga_x_position = 9'd99;
            vga_y_position = 8'd124;
        end
        4'b0011: begin
            vga_x_position = 9'd112;
            vga_y_position = 8'd96;
        end
        4'b0100: begin
            vga_x_position = 9'd131;
            vga_y_position = 8'd124;
        end
        4'b0101: begin
            vga_x_position = 9'd161;
            vga_y_position = 8'd124;
        end
        4'b0110: begin
            vga_x_position = 9'd174;
            vga_y_position = 8'd96;
        end
        4'b0111: begin
            vga_x_position = 9'd192;
            vga_y_position = 8'd124;
        end
        4'b1000: begin
            vga_x_position = 9'd209;
            vga_y_position = 8'd96;
        end
        4'b1001: begin
            vga_x_position = 9'd224;
            vga_y_position = 8'd124;
        end
        4'b1010: begin
            vga_x_position = 9'd245;
            vga_y_position = 8'd96;
        end
        4'b1011: begin
            vga_x_position = 9'd254;
            vga_y_position = 8'd124;
        end
        default: begin
            vga_x_position = 9'd0;
            vga_y_position = 8'd0;
        end

    endcase
     default: begin
           // Default state
            state <= 4'd0;
             oDone <= 1'b0;
                    
           // Octave adjustments
           if (octave_plus_plus)
             vga_x_position = 9'd103;
             vga_y_position = 8'd169;
           if (octave_minus_minus)
               vga_x_position = 9'd71;
               vga_y_position = 8'd169;
                    
                    // Amplitude adjustments
            if (amp_plus_plus)
               vga_x_position = 9'd64;
               vga_y_position = 8'd64;
            if (amp_minus_minus)
                vga_x_position = 9'd64;
                vga_y_position = 8'd64;
            
                    
                    // ADSR adjustments
                    case (ADSR_selector)
                        3'b001: if (ADSR_plus_plus) 
                        vga_x_position = 9'd153;
                        vga_y_position = 8'd169;
                        ADSR_plus_plus <= 1;
                        3'b010: if (ADSR_minus_minus)
                        vga_x_position = 9'd183;
                        vga_y_position = 8'd169;
                    endcase
     end
end
   always @(posedge iClock) begin
      if(!iResetn) begin
         // Initialization on reset
         oPlot <= 1'b0;
         oColour <= 3'b0;
         oX <= vga_x_position; // Set VGA pixel X-coordinate based on note
         oY <= vga_y_position; // Set VGA pixel Y-coordinate based on note
         oDone <= 1'b0;
         counter <= 5'd0;
      end
      else if(ld_plot) begin
         // Logic for drawing in yellow
         oPlot <= 1'b1;
         if (counter <= 5'b01111) begin
            oColour <= 3'b001; // Set the color to yellow (RGB: 001)
            counter <= counter + 1'b1;
            oX <= x + counter[1:0];
            oY <= y + counter[3:2];
         end
         else begin
            oX <= oX;
            oY <= oY;
            oColour <= 3'b001; // Set the color to yellow (RGB: 001)
            counter <= 0;
         end
      end
      if(ld_col_out)
         oColour <= col;
      if(ld_output)
         oDone <= 1'b1;
      if(ld_x_out)
         oX <= x;
      if(ld_y_out)
         oY <= y;
   end

endmodule

