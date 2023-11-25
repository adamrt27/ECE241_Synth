module converter(
    input[6:0] wave_in,
    output reg[6:0] wave_out
);

always@(*) begin
if(wave_in == d'0)
    wav_out = wave_in/2;
else
    wave_out = $signed(wave_in/2);
end
endmodule