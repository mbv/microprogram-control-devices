library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_UNSIGNED.all;

entity MRAM is
	port (
		RW: in std_logic;
		ADR: in std_logic_vector(5 downto 0);
		DIN: in std_logic_vector (7 downto 0);
		DOUT: out std_logic_vector (7 downto 0);
		DEBUG_RES: out std_logic_vector (7 downto 0);
		DEBUG_RES0: out std_logic_vector (7 downto 0);
		DEBUG_RES1: out std_logic_vector (7 downto 0);
		DEBUG_RES2: out std_logic_vector (7 downto 0);
		DEBUG_RES3: out std_logic_vector (7 downto 0);
		DEBUG_RES4: out std_logic_vector (7 downto 0)
		);
end MRAM;

architecture Beh_Max of MRAM is
	subtype machine_word is std_logic_vector(7 downto 0);
	type tRAM is array (0 to 63) of machine_word;
	signal RAM : tRAM :=(
		"00000101",	-- 5 | 000000 | array length
		"00000011", -- 3 | 000001 | a[0]
		"00000001", -- 1 | 000010 | a[1]
		"00000010", -- 2 | 000011 | a[2]
		"00000100", -- 4 | 000100 | a[3]
		"00000101", -- 5 | 000101 | a[4]
		"00000000", -- 0 | 000110 |	result
		others => "00000000"
	);
	signal data_in: machine_word;
	signal data_out: machine_word;
Begin
	data_in <= Din;
	WRITE: process (RW, ADR, data_in)
	begin
		if (RW = '0') then
			RAM(conv_integer(adr)) <= data_in;
		end if;
	end process; 
	
	data_out <= RAM (conv_integer(adr));
	DEBUG_RES <= RAM(6);
	
	ZBUFS: process (RW, data_out)
	begin
		if (RW = '1') then
			DOUT <= data_out;
		else
			DOUT <= (others => 'Z');
		end if;
	end process;
end Beh_Max;

architecture Beh_Zer of MRAM is
	subtype machine_word is std_logic_vector(7 downto 0);
	type tRAM is array (0 to 63) of machine_word;
	signal RAM : tRAM :=(
		"00000101",	-- 5 | 000000 | array length
		"00000000", -- 0 | 000001 | a[0]
		"00000001", -- 1 | 000010 | a[1]
		"00000000", -- 0 | 000011 | a[2]
		"00000100", -- 4 | 000100 | a[3]
		"00000000", -- 5 | 000101 | a[4]
		"00000000", -- 0 | 000110 |	result
		others => "00000000"
	);
	signal data_in: machine_word;
	signal data_out: machine_word;
Begin
	data_in <= Din;
	WRITE: process (RW, ADR, data_in)
	begin
		if (RW = '0') then
			RAM(conv_integer(adr)) <= data_in;
		end if;
	end process; 
	
	data_out <= RAM (conv_integer(adr)); 
	DEBUG_RES <= RAM(6);
	
	ZBUFS: process (RW, data_out)
	begin
		if (RW = '1') then
			DOUT <= data_out;
		else
			DOUT <= (others => 'Z');
		end if;
	end process;
end Beh_Zer;   

architecture Beh_Sort of MRAM is
	subtype machine_word is std_logic_vector(7 downto 0);
	type tRAM is array (0 to 63) of machine_word;
	signal RAM : tRAM :=(
		"00000101",	-- 5 | 000000 | array length
		"00000000", -- 0 | 000001 | previous
		"00000000", -- 0 | 000010 | tmp
		"00000000", -- 0 | 000011 | loop main
		"00000000", -- 0 | 000100 | loop inner
		"00000110", -- 0 | 000101 | array base(000110)
		"00000100", -- 4 | 000110 |	a[0]
		"00000010", -- 2 | 000111 |	a[1]
		"00000011", -- 3 | 001000 |	a[2]
		"00001001", -- 9 | 001001 |	a[3]
		"00000001", -- 1 | 001010 |	a[4]
		others => "00000000"
	);
	signal data_in: machine_word;
	signal data_out: machine_word;
Begin
	data_in <= Din;
	WRITE: process (RW, ADR, data_in)
	begin
		if (RW = '0') then
			RAM(conv_integer(adr)) <= data_in;
		end if;
	end process; 
	
	data_out <= RAM (conv_integer(adr));
	DEBUG_RES <= RAM(0);
	
	DEBUG_RES0 <= RAM(6);  
	DEBUG_RES1 <= RAM(7);
	DEBUG_RES2 <= RAM(8);
	DEBUG_RES3 <= RAM(9);
	DEBUG_RES4 <= RAM(10);
	
	ZBUFS: process (RW, data_out)
	begin
		if (RW = '1') then
			DOUT <= data_out;
		else
			DOUT <= (others => 'Z');
		end if;
	end process;
end Beh_Sort;