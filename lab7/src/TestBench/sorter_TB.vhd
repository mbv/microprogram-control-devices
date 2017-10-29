library ieee;
use ieee.STD_LOGIC_UNSIGNED.all;
use ieee.std_logic_1164.all;

entity sorter_tb is
end sorter_tb;

architecture TB_ARCHITECTURE of sorter_tb is
	component sorter
		port(
			CLK : in STD_LOGIC;
			RST : in STD_LOGIC;
			Start : in STD_LOGIC;
			Stop : out STD_LOGIC;			   
			Res : out STD_LOGIC_VECTOR(7 downto 0);
			Res0 : out STD_LOGIC_VECTOR(7 downto 0);
			Res1 : out STD_LOGIC_VECTOR(7 downto 0);
			Res2 : out STD_LOGIC_VECTOR(7 downto 0);
			Res3 : out STD_LOGIC_VECTOR(7 downto 0);
			Res4 : out STD_LOGIC_VECTOR(7 downto 0);
			RomAdr: out std_logic_vector(5 downto 0);
			D_FSR: out std_logic_vector(7 downto 0);
			D_ACCUM: out std_logic_vector(7 downto 0)
			);
	end component;
	
	signal CLK: std_logic := '0';
	signal RST: std_logic := '0';
	signal Start: std_logic := '0';	 	
	
	signal Stop: std_logic := '0'; 	 
	signal Res: std_logic_vector(7 downto 0);
	
	signal Res0: std_logic_vector(7 downto 0);
	signal Res1: std_logic_vector(7 downto 0);
	signal Res2: std_logic_vector(7 downto 0);
	signal Res3: std_logic_vector(7 downto 0);
	signal Res4: std_logic_vector(7 downto 0);
	signal RomAdr: std_logic_vector(5 downto 0);
	
	signal Dfsr: std_logic_vector(7 downto 0);
	signal Daccum: std_logic_vector(7 downto 0);
	
	constant CLK_period: time := 10 ns;
begin
	UUT : sorter
	port map (
		CLK => CLK,
		RST => RST,
		Start => Start,
		Stop => Stop,
		Res => Res,
		Res0 => Res0,	
		Res1 => Res1,
		Res2 => Res2,
		Res3 => Res3,
		Res4 => Res4,
		RomAdr => RomAdr,
		D_FSR => Dfsr,
		D_ACCUM => Daccum
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

configuration TESTBENCH_FOR_sorter of sorter_tb is
	for TB_ARCHITECTURE
		for UUT : sorter
			use entity work.sorter(beh);
		end for;
	end for;
end TESTBENCH_FOR_sorter;

