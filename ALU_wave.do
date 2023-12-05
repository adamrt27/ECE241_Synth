# set the working dir, where all compiled verilog goes

vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog frequency_getter.v ALUcontroller.v square_wave_generator.v twos_comp_converter.v ms_clk.v envelop_filter.v overdrive.v sine.v

#load simulation using mux as the top level simulation module
vsim ALUcontroller

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

add wave -position insertpoint sim:/ALUcontroller/d0/env0/*

# set clock
force {clk} 0 0ns, 1 {5ns} -r 10 ns

# TestCases: reset, play middle c (c4), square
force {reset} 0 0 ms, 1 10 ms
force {note_in} 0 0 ms, 1 10 ms, 0 30 ms
force {note} 4'd0 0 ns, 4'd0 10 ns
force {octave} 3'd0 0 ns, 3'd4 10 ns
force sine 1 0ns
force amplitude 6'd63 0 ns
force attack 6'd3 0ns
force decay 6'd3 0ns
force sustain 6'd31 0ns
force rel 6'd3 0ns
force overdrive 2'd3 0ns
run 100 ms
