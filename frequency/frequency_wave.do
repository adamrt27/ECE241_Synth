# set the working dir, where all compiled verilog goes

vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog frequency_getter.v

#load simulation using mux as the top level simulation module
vsim frequency_getter

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

# TestCases: C0 (16.35), B6 (1975.53), A#7 (3729.31)
force {note} 4'd0 0 ns, 4'd11 10 ns, 4'd10 20 ns
force {octave} 3'd0 0 ns, 3'd6 10 ns, 3'd7 20 ns
run 30 ns