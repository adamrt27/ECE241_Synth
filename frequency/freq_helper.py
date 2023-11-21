f = open("/Users/adamtaback/Desktop/Courses/Year 2 Fall/ECE241/Project/ECE241_Synth/frequency/frequency_getter.v", "w")
f.write("""// this module gets the frequency of a note, given the note letter and the octave.
// note 0 corresponds with C and octave 0 corresponds octave 0.

module frequency_getter(input [3:0]note,
                        input [2:0]octave,
                        output [15:0]frequency);
                        
    wire [16:0] num;
                        
    reg [20:0] TABLE [0:108];
    
""")

tab = open("/Users/adamtaback/Desktop/Courses/Year 2 Fall/ECE241/Project/ECE241_Synth/frequency/freq_table.txt", "r")

i = 0

f.write("\tinitial begin \n")
for line in tab:
    for word in line.split():
        f.write("\t\tTABLE[" + str(i) + "] = 21'd" + str(round(float(str(word)))) + "; \n")
        i += 1
f.write("\tend \n")
    
f.write("""
    assign num = note + (octave * 12);
    assign frequency = TABLE[note*octave];
    
endmodule""")

