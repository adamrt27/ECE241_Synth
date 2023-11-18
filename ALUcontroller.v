// This function takes the input of a note and octave and outputs the frequency needed
module frequency_getter(input [3:0]note, input [2:0]octave, output reg [15:0]frequency);
    // f_n = f_0 * (a)^n
    // f_n: frequency of note in hertz
    // f_0: refrence frequency - 440Hz (A4)
    // a: 2^(1/12)
    // n: positive/negative number determining how many semitones above or below our desired note

    // set f_0 and a
    reg [9150]f_0 = 16'd440;

    // calculate a
    reg [15:0]a;
    Calculate_2_exp_1_div_12 exp(a);

    // make a reg to hold a^n
    reg [15:0] a_power_n;

    // calculate n based on note and octave
    reg [6:0]n = note;

    
    // calculate f_n
    always@(*)
    begin
        // calcuate a^n
        FixedPointExponentiator exponentiator (
            .base(a), // 2 in fixed-point format
            .exponent(n),
            .result(a_power_n)
        );
        // calculate frequency
        frequency = f_0 * a_power_n;
    end
endmodule

module FixedPointExponentiator (
  input [15:0] base,         // 16-bit fixed-point number (8 bits integer, 8 bits fractional)
  input [7:0] exponent,      // 8-bit unsigned exponent
  output [15:0] result
);

  reg [15:0] result;

  always @* begin
    // Perform fixed-point exponentiation using binary exponentiation algorithm
    result = 16'b1; // Initialize result to 1 in fixed-point format

    for (int i = 7; i >= 0; i = i - 1) begin
      result = result * result; // Square the result

      if (exponent[i] == 1) begin
        // Multiply by the base if the corresponding exponent bit is 1
        result = result * base;
      end
    end
  end

endmodule

module Calculate_2_exp_1_div_12 (
  output reg [15:0] result
);
    // calculates 2^(1/12)

  reg [15:0] two_to_power_one_twelfth;
  reg [15:0] fixed_point_exponent;

  initial begin
    // Initialize fixed-point exponent
    fixed_point_exponent = 8'b00000001; // 1/12 in fixed-point format

    // Initialize result to 2
    result = 16'b0000001000000000;

    // Calculate 2^(1/12)
    repeat (11) begin
      // Use the fixed-point exponentiation module from the previous example
      FixedPointExponentiator exponentiator (
        .base(result),
        .exponent(fixed_point_exponent),
        .result(two_to_power_one_twelfth)
      );

      // Update result for the next iteration
      result = two_to_power_one_twelfth;
    end
  end

endmodule



// make it so it can play multiple notes at once
module control(clk, reset, play, ... ); //  need outputs

    input clk;          // clock
    input reset;        // reset

    input play;        // when 1, plays note

    reg [2:0]cur_state; 
    reg [2:0]next_state;

    // state params
    localparam start = 3'b000, play_note = 3'b001;

    always@(*)
    begin: state_table
        case ( cur_state )
            start: begin
                if (play) next_state = play_note;
                else next_state = start;
            end
            play_note: begin
                if (play) next_state = play_note;
                else next_state = start;
            end  
        endcase
    end // state_table


    always @(*)
    begin: enable_signals
        // By default make all our signals 0

        case (cur_state)
            
        endcase
    end // enable_signals

    always @(posedge clk)
    begin: state_FFs
        if(reset == 1'b0) begin
            cur_state <=  start; // Should set reset state to state A
        end
        else begin 
            // fill in
            cur_state <= next_state;
        end
    end // state_FFS

endmodule

module datapath(clk, reset, note, octave, ...);
    input clk;          // clock
    input reset;        // reset

    input [3:0] note;   // the note input (i.e. A, Bflat, Gsharp)
    input [2:0] octave; // the octave of the note (7 total octaves)
                        // octave 4 corresponds with middle C

    // note params
    localparam A = 4'b0000, A# = 4'b0001, B = 4'b0010, 
                C = 4'b0011, C# = 4'b0100, D = 4'b0101,
                D# = 4'b0110, E = 4'b0111, F = 4'b1000,
                F# = 4'b1001, G = 4'b1010, G# = 4'b1011,
                null = 4'b1111;
endmodule