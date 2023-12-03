# set the working dir, where all compiled verilog goes

vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog overdrive.v

#load simulation using mux as the top level simulation module
vsim overdrive

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

# set clock
force {clk} 0 0ns, 1 {5ns} -r 10 ns

# reset
force {reset} 0 0 ns, 1 20 ns
run 40 ns

# TestCases: force a mock sine wave into the module with overdrive

force {cur_amplitude} 31'd16 0ns, 31'd25 20 ns, 31'd30 40 ns, 31'd30 60 ns, 31'd25 80 ns, 31'd16 100 ns, 31'd6 120 ns, 31'd1 140 ns,
31'd1 160 ns, 31'd6 180 ns, 31'd16 200 ns
force {activate} 1 0 ns
force {overdrive} 1 0 ns 
force {threshold} 31'd25 0 ns
force {neg_threshold} 31'd5 0 ns
force {max_amplitude} 31'd30 0 ns
run 200 ns

# TestCases: force a mock sine wave into the module with compression

force {cur_amplitude} 31'd16 0ns, 31'd25 20 ns, 31'd30 40 ns, 31'd30 60 ns, 31'd25 80 ns, 31'd16 100 ns, 31'd6 120 ns, 31'd1 140 ns,
31'd1 160 ns, 31'd6 180 ns, 31'd16 200 ns
force {activate} 1 0 ns
force {overdrive} 0 0 ns 
force {threshold} 31'd25 0 ns
force {neg_threshold} 31'd5 0 ns
force {max_amplitude} 31'd30 0 ns
run 200 ns