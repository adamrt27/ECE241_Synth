module sound (clock, reset, outs);
    input clock, reset;
    output reg outs;
parameter bits = 8;
parameter frequencyDivider = 25;

reg [7:0] counter;
reg [31:0] generates;

always@(posedge clock) begin
    if (reset) begin
        counter <= 0;
        generates <=0;
    end else begin
        counter <= counter + 1;
        generates <= generates + frequencyDivider;
        if ((generates[31] == 1))
            outs <= 1'b1;
        else 
            outs <= 1'b0;
	end
end
endmodule
