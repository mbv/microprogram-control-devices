library ieee;
use ieee.STD_LOGIC_UNSIGNED.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;


entity alu_tb is
end alu_tb;

architecture TB_ARCHITECTURE of alu_tb is
	component alu
		port(
			EN : in STD_LOGIC;
			OT : in STD_LOGIC_VECTOR(3 downto 0);
			OP1 : in STD_LOGIC_VECTOR(7 downto 0);
			RES : out STD_LOGIC_VECTOR(7 downto 0);
			ZF : out STD_LOGIC;
			SBF : out STD_LOGIC );
	end component;
	
	signal EN : STD_LOGIC;
	signal OT : STD_LOGIC_VECTOR(3 downto 0);
	signal OP1 : STD_LOGIC_VECTOR(7 downto 0);
	
	signal RES : STD_LOGIC_VECTOR(7 downto 0);
	signal ZF : STD_LOGIC;
	signal SBF : STD_LOGIC;
	
	constant CLK_period: time := 10 ns;
begin
	
	UUT : alu
	port map (
		EN => EN,
		OT => OT,
		OP1 => OP1,
		RES => RES,
		ZF => ZF,
		SBF => SBF
		);
	
	CLK_Process: process
	begin
		EN <= '0';
		wait for CLK_Period/2;
		EN <= '1';
		wait for CLK_Period/2;
	end process;
	
	main: process
	begin	 
		OP1 <= "00000111";	-- 7  
		OT <= "0000"; -- LOAD
		wait for CLK_Period;
		OP1 <= "00000011"; -- 3	  
		OT <= "0010"; -- ADD
		wait for CLK_Period; 
		OP1 <= "00000010"; -- 2	  
		OT <= "0011"; -- SUB
		wait for CLK_Period;  
		OT <= "0100"; -- INC
		wait for CLK_Period;   
		OT <= "0101"; -- DEC
		wait for CLK_Period;
		wait;
	end process;
	
end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_alu of alu_tb is
	for TB_ARCHITECTURE
		for UUT : alu
			use entity work.alu(beh);
		end for;
	end for;
end TESTBENCH_FOR_alu;

