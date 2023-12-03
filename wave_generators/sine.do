# set the working dir, where all compiled verilog goes

vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog sine.v

#load simulation using mux as the top level simulation module
vsim sine

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

force {clk} 0 0 ns, 1 5ns -r 10ns

# TestCases: C0 (16.35), B6 (1975.53), A#7 (3729.31)
force {reset_n} 0 0 ns, 1 10 ns
force {frequency} 16'd10000 0 ns
force {amplitude} 6'd31;
run 20 ms