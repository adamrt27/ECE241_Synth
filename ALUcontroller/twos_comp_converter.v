module twos_comp_converter(
    input[6:0] wave_in,
    input[5:0] amp,
    output reg[6:0] wave_out
);

    always@(*) begin
        if(wave_in == 7'b0000000)
            wave_out = ~amp+1;
        else
            wave_out = amp;
    end
endmodule