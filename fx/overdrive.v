module overdrive(clk, activate, overdrive, threshold, neg_threshold, max_amplitude, cur_amplitude, adj_cur_amplitude);

    input clk; // clock
    input activate; // 1 - use clipping, 0 - dont
    input overdrive; // 1 - use overdrive (clipping + amplification), 0 - compression (clipping only)
    input [30:0] threshold; // the level at which to clip on positive side
    input [30:0] neg_threshold; // the level at which to clip on negative side
    input [30:0] max_amplitude; // the max amplitude (basically the current volume)
    input [31:0] cur_amplitude; // the current amplitude of the sine wave

    output reg [31:0] adj_cur_amplitude; // output multiplier that changes wave shape

    // clipping
    always@(posedge clk)
    begin
        if (activate) begin
            if(cur_amplitude > threshold && overdrive)
                adj_cur_amplitude <= (threshold * max_amplitude)/threshold;
            else if (cur_amplitude > threshold && ~overdrive)
                adj_cur_amplitude <= threshold;
            else if (cur_amplitude < neg_threshold && overdrive)
                adj_cur_amplitude <= 0;
            else if (cur_amplitude < neg_threshold && ~overdrive)
                adj_cur_amplitude <= neg_threshold;
            else if (overdrive)
                adj_cur_amplitude <= cur_amplitude * amp_factor;
            else
                adj_cur_amplitude <= cur_amplitude;
        end
        else
            adj_cur_amplitude <= cur_amplitude;
    end
endmodule