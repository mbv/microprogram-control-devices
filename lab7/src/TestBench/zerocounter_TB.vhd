library ieee;
use ieee.STD_LOGIC_UNSIGNED.all;
use ieee.std_logic_1164.all;

entity zerocounter_tb is
end zerocounter_tb;

architecture TB_ARCHITECTURE of zerocounter_tb is
	component zerocounter
		port(
			CLK : in STD_LOGIC;
			RST : in STD_LOGIC;
			Start : in STD_LOGIC;
			Stop : out STD_LOGIC;
			Res : out STD_LOGIC_VECTOR(7 downto 0) );
	end component;
	
	signal CLK: std_logic := '0';
	signal RST: std_logic := '0';
	signal Start: std_logic := '0';	 	
	
	signal Stop: std_logic := '0'; 	 
	signal Res: std_logic_vector(7 downto 0);
	
	constant CLK_period: time := 10 ns;
begin
	UUT : zerocounter
	port map (
		CLK => CLK,
		RST => RST,
		Start => Start,
		Stop => Stop,
		Res => Res
		);
	
	CLK_Process: process
	begin
		CLK <= '0';
		wait for CLK_Period/2;
		CLK <= '1';
		wait for CLK_Period/2;
	end process;
	
	main: process
	begin
		rst <= '1';
		wait for 1 * CLK_PERIOD;
		rst <= '0';
		start <= '1';
		wait for 100 * CLK_PERIOD;
		wait;
	end process;
	
end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_zerocounter of zerocounter_tb is
	for TB_ARCHITECTURE
		for UUT : zerocounter
			use entity work.zerocounter(beh);
		end for;
	end for;
end TESTBENCH_FOR_zerocounter;

