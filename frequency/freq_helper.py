f = open("/Users/adamtaback/Desktop/Courses/Year 2 Fall/ECE241/Project/ECE241_Synth/frequency/freq_test.v", "w")
f.write("""module frequency_getter(input clk, \n
                        input reset, \n
                        input [3:0]note, \n
                        input [2:0]octave, \n
                        output [15:0]frequency); \n
    reg [20:0] table [0:108];\n\n """)

tab = open("/Users/adamtaback/Desktop/Courses/Year 2 Fall/ECE241/Project/ECE241_Synth/frequency/freq_table.txt", "r")

i = 0

for line in tab:
    for word in line.split():
        f.write("\ttable[" + str(i) + "] = 21'd" + word + "; \n")
        i += 1
    
f.write("""\n\tassign frequency = table[note*octave]; \n
endmodule""")

