vlib work
vlog -timescale 1ns/1ns duck_hunt2.v
vsim duck_hunt -sv_seed random
log {/*}
add wave {/*}



force {CLOCK_50} 0 0, 1 1 -r 2
force {KEY[1:0]} 0
run 8000ns