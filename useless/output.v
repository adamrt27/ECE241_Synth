module sound (clock, reset, outs);
    input clock, reset;
    output reg outs;
parameter bits = 8;
parameter frequencyDivider = 25;

reg [7:0] counter;
reg [5:0] generates;

always@(posedge clock) begin
    if (reset) begin
        counter <= 0;
        generates <=0;
    end else begin
        counter <= counter + 1;
        generates <= generates + frequencyDivider;
        if ((generates[5] == 1))
            outs <= 1'b1;
        else 
            outs <= 1'b0;
	end
end
endmodule
