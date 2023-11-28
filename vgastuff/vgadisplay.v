
module vgadisplay(iResetn,iPlotBox,iColour,iLoadX,iXY_Coord,iClock,oX,oY,oColour,oPlot,oDone, state);
   // Inputs
   input iResetn, iPlotBox, iLoadX;
   input [2:0] iColour;
   input [8:0] iXY_Coord;
   input iClock;
   
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
      .iXY_Coord(iXY_Coord),
      .iColour(iColour),
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
   input [6:0] iXY_Coord,
   input [2:0] iColour,
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
      else begin
         if(ld_x_reg)
            // Limit x to X_SCREEN_PIXELS-1 (from 0 to X_SCREEN_PIXELS-1)
            x <= (iXY_Coord[3:0] >= X_SCREEN_PIXELS) ? (X_SCREEN_PIXELS - 1) : iXY_Coord[3:0];
         if(ld_y_reg)
            // Limit y to Y_SCREEN_PIXELS-1 (from 0 to Y_SCREEN_PIXELS-1)
            y <= (iXY_Coord[6:3] >= Y_SCREEN_PIXELS) ? (Y_SCREEN_PIXELS - 1) : iXY_Coord[6:3];
         if(ld_col_reg)
            col <= iColour;
      end
   end

   always @(posedge iClock) begin
      if(!iResetn) begin
         // Initialization on reset
         oPlot <= 1'b0;
         oColour <= 3'b0;
         oY <= 7'b0;
         oX <= 8'b0;
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

