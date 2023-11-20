f = open("freq_test.v", "w")
f.write("""module frequency_getter(input clk, \n
                        input reset, \n
                        input [3:0]note, \n
                        input [2:0]octave, \n
                        output [15:0]frequency); \n
    reg [20:0] table [0:108]; """)

tab = open("freq_table.txt", "r")
for line in tab:
    f.write("table[" + line[0:line.find(" ")] + "] = 6'd" + line[line.find(" ")+1:] + "; \n")
    
f.write("""assign frequency = table[note*octave]; \n
endmodule""")