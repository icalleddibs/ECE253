# set the working dir, where all compiled verilog goes
vlib work

# compile all system verilog modules in mux.sv to working dir
# could also have multiple verilog files
vlog part3.sv

#load simulation using mux as the top level simulation module
vsim hex_decoder

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

#testing all possible cases :)
force {c[3]} 1
force {c[2]} 1
force {c[1]} 0
force {c[0]} 1
run 80ns

force {c[3]} 1
force {c[2]} 1
force {c[1]} 1
force {c[0]} 0
run 50ns

force {c[3]} 1
force {c[2]} 1
force {c[1]} 1
force {c[0]} 1
run 50ns

