module sound (clock, reset, out);
    input clock, reset;
    output out;
parameter bits = 8;
parameter frequencyDivider = 25;

reg [7:0] counter;
reg [31:0] generate;

always@(posedge clock) begin
    if (reset) begin
        counter <= 0;
        generate <=0;
    end else begin
        counter <= counter + 1;
        generate <= generate + frequencyDivider;
        if ((generate[31] == 1))
            out <= 1'b1;
        else 
            out <= 1'b1;
    end
end
endmodule