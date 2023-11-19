// This function takes the input of a note and octave and outputs the frequency needed
module frequency_getter(input clk,
                        input reset,
                        input [3:0]note, 
                        input [2:0]octave, 
                        output reg [15:0]frequency);
    // f_n = f_0 * (a)^n
    // f_n: frequency of note in hertz
    // f_0: refrence frequency - 440Hz (A4)
    // a: 2^(1/12)
    // n: positive/negative number determining how many semitones above or below our desired note

    // set f_0 and a
    reg [9150]f_0 = 16'd440;

    // calculate a
    reg [15:0]a;
    reg [3:0]temp = 4'd0;
    Calculate_2_exp_1_div_12 exp(temp,a);

    // make a reg to hold a^n
    reg [15:0] a_power_n;

    // calculate n based on note and octave
    reg [6:0]n = note;

    // make counter
    reg [3:0]counter = 4'd0;

    
    // calculate f_n
    always@(posedge clk)
    begin
        // calcuate a^n
        FixedPointExponentiator exponentiator(
            .base(a), // 2 in fixed-point format
            .exponent(n),
            .counter(counter),
            .result(a_power_n)
        );
        // calculate frequency
        frequency = f_0 * a_power_n;
    end
endmodule

module FixedPointExponentiator (
  input [15:0] base,         // 16-bit fixed-point number (8 bits integer, 8 bits fractional)
  input [7:0] exponent,      // 8-bit unsigned exponent
  input reg [3:0] counter,
  output [15:0] result
);

  reg [15:0] result;

  always @* begin
    // Perform fixed-point exponentiation using binary exponentiation algorithm
    result = 16'b1; // Initialize result to 1 in fixed-point format

    if (counter <= 4'd7) begin
      result = result * result; // Square the result

      if (exponent[counter] == 1) begin
        // Multiply by the base if the corresponding exponent bit is 1
        result = result * base;
      end
      counter = counter+1;
    end
  end

endmodule

module Calculate_2_exp_1_div_12 (
    input reg [3:0]counter,
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
        .counter(counter),
        .result(two_to_power_one_twelfth)
      );

      // Update result for the next iteration
      result = two_to_power_one_twelfth;
    end
  end

endmodule
