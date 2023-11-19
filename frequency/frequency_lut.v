module frequency_getter(input clk,
                        input reset,
                        input [3:0]note, 
                        input [2:0]octave, 
                        output [15:0]frequency);
    
    reg [6:0] table [0:108];

    initial $readmemb("freq_table.hex", table);

    assign frequency = table[note*octave];
endmodule