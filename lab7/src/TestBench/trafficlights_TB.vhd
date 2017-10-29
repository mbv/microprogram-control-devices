library ieee;
use ieee.STD_LOGIC_UNSIGNED.all;
use ieee.std_logic_1164.all;


entity trafficlights_tb is
end trafficlights_tb;

architecture TB_ARCHITECTURE of trafficlights_tb is
	component trafficlights
		port(
			CLK : in STD_LOGIC;
			CWAIT : in STD_LOGIC;
			RST : in STD_LOGIC;
			START : in STD_LOGIC;
			R : out STD_LOGIC;
			Y : out STD_LOGIC;
			G : out STD_LOGIC );
	end component;
	
	signal CLK : STD_LOGIC;
	signal CWAIT : STD_LOGIC;
	signal RST : STD_LOGIC;
	signal START : STD_LOGIC;
	
	signal R : STD_LOGIC;
	signal Y : STD_LOGIC;
	signal G : STD_LOGIC;
	
	constant CLK_period: time := 10 ns;
begin
	UUT : trafficlights
	port map (
		CLK => CLK,
		CWAIT => CWAIT,
		RST => RST,
		START => START,
		R => R,
		Y => Y,
		G => G
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
		--cwait <= '1';
		wait for 2 * CLK_Period;
		start <= '1';
		wait for 2 * CLK_Period;
		cwait <= '1';
		wait;
	end process;
	
	
end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_trafficlights of trafficlights_tb is
	for TB_ARCHITECTURE
		for UUT : trafficlights
			use entity work.trafficlights(beh);
		end for;
	end for;
end TESTBENCH_FOR_trafficlights;

