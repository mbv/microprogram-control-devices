SetActiveLib -work
comp -include "$dsn\src\Task\ZeroCounter.vhd" 
comp -include "$dsn\src\TestBench\zerocounter_TB.vhd" 
asim +access +r TESTBENCH_FOR_zerocounter 
wave 
wave -noreg CLK
wave -noreg RST
wave -noreg Start
wave -noreg Stop
wave -noreg Res	 

run 1 us
