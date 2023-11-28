module envelop_filter(clk, reset, note_in, attack, decay, sustain, rel, max_amplitude, cur_amplitude);

    input clk; // clock
    input reset; // low active reset
    input note_in; // tells use when the note is on
    input [30:0] attack; // how much attack
    input [30:0] decay;
    input [30:0] sustain;
    input [30:0] rel; // release, but cant be called that cuz its a keyword
    input [30:0] max_amplitude; // the max amplitude (basically the current volume)

    output reg [30:0] cur_amplitude; // output multiplier that changes wave shape

    // CONTROL PATH

    reg [2:0]cur_state; 
    reg [2:0]next_state;

    // state params
    localparam start = 3'b000, att = 3'b001, dec = 3'b010, sus = 3'b011, re = 3'b100;

    always@(*)
    begin: state_table
        case ( cur_state )
            start: begin // starting state, when reset
                if (note_in) next_state = att;
                else next_state = start;
            end
            att: begin // state to load in note to waveform
                if (cur_amplitude == max_amplitude) next_state = dec;
                else if (note_in == 0) next_state = re;
                else next_state = att;
            end
            dec: begin // state to play note
                if (cur_amplitude == sustain) next_state = sus;
                else if (note_in == 0) next_state = re;
                else next_state = dec;
            end  
            sus: begin
                if (!note_in) next_state = re;
                else next_state = sus;
            end
            re: begin
                if (cur_amplitude <= 0) next_state = start;
                else next_state = re;
            end
        endcase
    end // state_table

    always @(posedge clk)
    begin: state_FFs
        if(!reset) begin
            cur_state <=  start; // Should set reset state to state A
        end
        else begin 
            // fill in
            cur_state <= next_state;
        end
    end // state_FFS

    // DATAPATH

    // get milisecond clock, so that these effects are noticable
    wire ms_pulse;
    ms_clk c0(clk, reset, ms_pulse);

    always@(posedge clk) begin
        if(ms_pulse) begin
            case (cur_state)
                start: begin
                    cur_amplitude = 6'b0;
                end
                att: begin
                    cur_amplitude = cur_amplitude + attack;
                    if(cur_amplitude > max_amplitude) begin
                        cur_amplitude = max_amplitude;
                    end
                end
                dec: begin
                    cur_amplitude = cur_amplitude - decay;
                    if(cur_amplitude <= sustain) begin
                        cur_amplitude = sustain;
                    end
                end
                sus: begin
                    cur_amplitude = sustain;
                end
                re: begin
                    if (cur_amplitude == 0 | cur_amplitude <= rel) 
                        cur_amplitude = 0;
                    else 
                    cur_amplitude = cur_amplitude - rel;
                end
            endcase
        end
    end
endmodule