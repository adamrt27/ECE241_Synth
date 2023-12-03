module overdrive(clk, reset, activate, overdrive, threshold, max_amplitude, cur_amplitude, adj_cur_amplitude);

    input clk; // clock
    input activate; // 1 - use clipping, 0 - dont
    input overdrive; // 1 - use overdrive (clipping + amplification), 0 - compression (clipping only)
    input [30:0] threshold; // the level at which to clip on positive side
    input [30:0] neg_threshold; // the level at which to clip on negative side
    input [30:0] max_amplitude; // the max amplitude (basically the current volume)
    input [30:0] cur_amplitude; // the current amplitude of the sine wave

    output reg [30:0] adj_cur_amplitude; // output multiplier that changes wave shape

    // amplification factor
    reg [30:0] amp_factor;

    // clipping
    always@(posedge clk)
    begin
        if (activate) begin
            if (overdrive)
                amp_factor = max_amplitude/threshold;
            else 
                amp_factor = 1;
            if(cur_amplitude > threshold) 
                adj_cur_amplitude <= threshold * amp_factor;
            else if (cur_amplitude < neg_threshold && overdrive)
                adj_cur_amplitude <= 0;
            else if (cur_amplitude < neg_threshold && ~overdrive)
                adj_cur_amplitude <= neg_threshold;
            else
                adj_cur_amplitude <= cur_amplitude * amp_factor;
        end else
            adj_cur_amplitude <= cur_amplitude;
    end
endmodule