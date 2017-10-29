SetActiveLib -work
comp -include "$dsn\src\Task\MaxFinder.vhd" 
comp -include "$dsn\src\TestBench\maxfinder_TB.vhd" 
asim +access +r TESTBENCH_FOR_maxfinder 
wave 
wave -noreg CLK
wave -noreg RST
wave -noreg Start
wave -noreg Stop
wave -noreg Res

run 1 us