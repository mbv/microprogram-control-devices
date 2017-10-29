SetActiveLib -work
comp -include "$dsn\src\ALU.vhd" 
comp -include "$dsn\src\TestBench\alu_TB.vhd" 
asim +access +r TESTBENCH_FOR_alu 
wave 
wave -noreg EN
wave -noreg OT
wave -noreg OP1
wave -noreg RES
wave -noreg ZF
wave -noreg SBF


run 1 us
