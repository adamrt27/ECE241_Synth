# set the working dir, where all compiled verilog goes

vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog frequency_getter.v, ALUcontroller.v, square_wave_generator.v

#load simulation using mux as the top level simulation module
vsim ALUcontroller

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

# set clock
force {clk} 0 0ms, 1 {5ms} -r 10 ms

# TestCases: reset, play middle c (c4)
force {reset} 0 0 ms, 1 10 ms
force {note_in} 0 0 ms, 1 10 ms, 0 20 ms
force {note} 4'd0 0 ns, 4'd0 10 ns
force {octave} 3'd0 0 ns, 3'd4 10 ns
run 1000 ms