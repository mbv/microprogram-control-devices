SetActiveLib -work
comp -include "$dsn\src\TrafficLights.vhd" 
comp -include "$dsn\src\TestBench\trafficlights_TB.vhd" 
asim +access +r TESTBENCH_FOR_trafficlights 
wave 
wave -noreg CLK
wave -noreg CWAIT
wave -noreg RST
wave -noreg START
wave -noreg R
wave -noreg Y
wave -noreg G


run 1 us
