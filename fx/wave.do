# set the working dir, where all compiled verilog goes

vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog envelop_filter.v ms_clk.v

#load simulation using mux as the top level simulation module
vsim envelop_filter

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

# set clock
force {clk} 0 0ns, 1 {5ns} -r 10 ns

# TestCases: test with all params at 4 (100 in binary)
force {reset} 0 0 ms, 1 5 ms
force {note_in} 0 0 ms, 1 10 ms, 0 25 ms
force {attack} 6'd4 
force {decay} 6'd4
force sustain 6'd4
force rel 6'd1
force max_amplitude 6'd31 0 ns
run 40 ms