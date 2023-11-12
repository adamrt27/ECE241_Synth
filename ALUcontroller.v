
module control(clk, reset, note, octave, ... ) //  need outputs

    input clk;          // clock
    input reset;        // reset

    input [3:0] note;   // the note input (i.e. A, Bflat, Gsharp)
    input [2:0] octave; // the octave of the note (7 total octaves)
                        // octave 4 corresponds with middle C

    reg [2:0]cur_state;
    reg [2:0]next_state;

    // note params
    localparam A = 4'b0000, A# = 4'b0001, B = 4'b0010, 
                C = 4'b0011, C# = 4'b0100, D = 4'b0101,
                D# = 4'b0110, E = 4'b0111, F = 4'b1000,
                F# = 4'b1001, G = 4'b1010, G# = 4'b1011;

    // state params
    localparam start = 3'b000;

    always@(*)
    begin: state_table
        case ( cur_state )
           
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