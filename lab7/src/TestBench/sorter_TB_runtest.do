SetActiveLib -work
comp -include "$dsn\src\Task\Sorter.vhd" 
comp -include "$dsn\src\TestBench\sorter_TB.vhd" 
asim +access +r TESTBENCH_FOR_sorter 
wave 
wave -noreg CLK
wave -noreg RST
wave -noreg Start
wave -noreg Stop  
wave -noreg Res
wave -noreg Res0	
wave -noreg Res1
wave -noreg Res2
wave -noreg Res3
wave -noreg Res4
wave -noreg RomAdr
wave -noreg Dfsr
wave -noreg Daccum

run 15 us
