# set the working dir, where all compiled verilog goes

vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog frequency_lut.v

#load simulation using mux as the top level simulation module
vsim frequency_getter

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

#first test case
force {note} 0 0 ns
force {octave} 0 0 ns
run 50 ns

