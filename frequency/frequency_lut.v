module frequency_getter(input clk,
                        input reset,
                        input [3:0]note, 
                        input [2:0]octave, 
                        output [15:0]frequency);
    
    reg [20:0] table [0:108];

    //initial $readmemb("freq_table.hex", table);

    table[0] = 6'd1635;

    assign frequency = table[note*octave];
endmodule