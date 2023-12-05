module twos_comp_converter(
    input[31:0] wave_in,
    input[30:0] amp,
    output reg[31:0] wave_out
);

    always@(*) begin
        if(wave_in == 32'b0)
            wave_out = ~amp+1;
        else
            wave_out = amp;
    end
endmodule