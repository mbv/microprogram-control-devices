library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_UNSIGNED.all;

-- LOAD    0000
-- STORE   0001
-- ADD     0010
-- SUB     0011
-- INC     0100
-- DEC     0101
-- JNZ     0110
-- JZ      0111
-- JNSB    1000
-- JMP     1001
-- HALT    1010

entity MROM is 
	port (
		RE: in std_logic;
		ADR: in std_logic_vector(5 downto 0);
		DOUT: out std_logic_vector(9 downto 0)
		);
end MROM;

architecture Beh_Max of MROM is
	subtype instruction_word is std_logic_vector(9 downto 0);
	type tROM is array (0 to 63) of instruction_word;
	constant ROM: tROM :=(
	--	OP_CODE | RAM ADR |  N Hex  | N DEC | instruction
	"0000" & "000001", -- 000000 | 00 	|LOAD a[0]
	"0001" & "000110", -- 000001 | 01 	|STORE res
	"0011" & "000010", -- 000010 | 02 	|SUB a[1]
	"1000" & "000110", -- 000011 | 03 	|JNSB m1
	"0000" & "000010", -- 000100 | 04 	|LOAD a[1]
	"0001" & "000110", -- 000101 | 05 	|STORE res
	"0000" & "000110", -- 000110 | 06 	|LOAD res	: m1
	"0011" & "000011", -- 000111 | 07 	|SUB a[2]
	"1000" & "001011", -- 001000 | 08 	|JNSB m2
	"0000" & "000011", -- 001001 | 09 	|LOAD a[2]
	"0001" & "000110", -- 001010 | 10 	|STORE res
	"0000" & "000110", -- 001011 | 11 	|LOAD res	: m2
	"0011" & "000100", -- 001100 | 12 	|SUB a[3]
	"1000" & "010000", -- 001101 | 13 	|JNSB m3
	"0000" & "000100", -- 001110 | 14 	|LOAD a[3]
	"0001" & "000110", -- 001111 | 15 	|STORE res
	"0000" & "000110", -- 010000 | 16 	|LOAD res	: m3
	"0011" & "000101", -- 010001 | 17 	|SUB a[4]
	"1000" & "010101", -- 010010 | 18 	|JNSB m4
	"0000" & "000101", -- 010011 | 19 	|LOAD a[4]
	"0001" & "000110", -- 010100 | 20 	|STORE res
	"0000" & "000110", -- 010101 | 21 	|LOAD res	: m4
	"1010" & "000000", -- 010110 | 22 	|HALT
	others => "1010" & "000000"
	);
	signal data: instruction_word;
begin
	data <= ROM(conv_integer(adr));
	zbufs: process (RE, data)
	begin
		if (RE = '1') then
			DOUT <= data;
		else
			DOUT <= (others => 'Z');
		end if;
	end process;
end Beh_Max;

architecture Beh_Zer of MROM is
	subtype instruction_word is std_logic_vector(9 downto 0);
	type tROM is array (0 to 63) of instruction_word;
	constant ROM: tROM :=(
	--	OP_CODE | RAM ADR |  N Hex  | N DEC | instruction
	"0000" & "000001", -- 000000 | 00 	| LOAD a[0]
	"0110" & "000101", -- 000001 | 01	| JNZ m1
	"0000" & "000110", -- 000010 | 02	| LOAD res
	"0100" & "000000", -- 000011 | 03	| ADD 1
	"0001" & "000110", -- 000100 | 04	| STORE res
	"0000" & "000010", -- 000101 | 05 	| LOAD a[1] : m1
	"0110" & "001010", -- 000110 | 06	| JNZ m2
	"0000" & "000110", -- 000111 | 07	| LOAD res
	"0100" & "000000", -- 001000 | 08	| ADD 1
	"0001" & "000110", -- 001001 | 09	| STORE res
	"0000" & "000011", -- 001010 | 10 	| LOAD a[2] : m2
	"0110" & "001111", -- 001011 | 11	| JNZ m3
	"0000" & "000110", -- 001100 | 12	| LOAD res
	"0100" & "000000", -- 001101 | 13	| ADD 1
	"0001" & "000110", -- 001110 | 14	| STORE res
	"0000" & "000100", -- 001111 | 15 	| LOAD a[3] : m3
	"0110" & "010100", -- 010000 | 16	| JNZ m4
	"0000" & "000110", -- 010001 | 17	| LOAD res
	"0100" & "000000", -- 010010 | 18	| ADD 1
	"0001" & "000110", -- 010011 | 19	| STORE res
	"0000" & "000101", -- 010100 | 20 	| LOAD a[4] : m4
	"0110" & "011001", -- 010101 | 21	| JNZ m5
	"0000" & "000110", -- 010110 | 22	| LOAD res
	"0100" & "000000", -- 010111 | 23	| ADD 1
	"0001" & "000110", -- 011000 | 24	| STORE res
	"1010" & "000000", -- 011001 | 25 	| HALT : m5
	others => "1010" & "000000"
	);
	signal data: instruction_word;
begin
	data <= ROM(conv_integer(adr));
	zbufs: process (RE, data)
	begin
		if (RE = '1') then
			DOUT <= data;
		else
			DOUT <= (others => 'Z');
		end if;
	end process;
end Beh_Zer;	

architecture Beh_Sort of MROM is
	subtype instruction_word is std_logic_vector(9 downto 0);
	type tROM is array (0 to 63) of instruction_word;
	constant ROM: tROM :=(
	--	OP_CODE | RAM ADR |  N Bin  | N DEC | instruction
	"0000" & "000000", -- 000000 | 00 | LOAD array length
	"0101" & "111111", -- 000001 | 01 | DEC 
	"0001" & "000011", -- 000010 | 02 | STORE loop main
	"0000" & "000011", -- 000011 | 03 | LOAD loop main; m:MAIN_LOOP
	"0001" & "000100", -- 000100 | 04 | STORE loop inner
	"0000" & "000101", -- 000101 | 05 | LOAD array base
	"0101" & "111111", -- 000110 | 06 | DEC 
	"0001" & "100001", -- 000111 | 07 | STORE to FSR
	"0000" & "100001", -- 001000 | 08 | LOAD FSR; m:INNER_LOOP
	"0100" & "111111", -- 001001 | 09 | INC 
	"0001" & "100001", -- 001010 | 0a | STORE to FSR
	"0000" & "100000", -- 001011 | 0b | LOAD from INDF
	"0001" & "000001", -- 001100 | 0c | STORE previous
	"0000" & "100001", -- 001101 | 0d | LOAD FSR
	"0100" & "111111", -- 001110 | 0e | INC 
	"0001" & "100001", -- 001111 | 0f | STORE to FSR
	"0000" & "100000", -- 010000 | 10 | LOAD from INDF
	"0011" & "000001", -- 010001 | 11 | SUB previous
	"1000" & "011111", -- 010010 | 12 | JNSB GOTO SKIP
	"0000" & "100000", -- 010011 | 13 | LOAD from INDF
	"0001" & "000010", -- 010100 | 14 | STORE tmp
	"0000" & "000001", -- 010101 | 15 | LOAD previous
	"0001" & "100000", -- 010110 | 16 | STORE to INDF
	"0000" & "100001", -- 010111 | 17 | LOAD FSR
	"0101" & "111111", -- 011000 | 18 | DEC 
	"0001" & "100001", -- 011001 | 19 | STORE to FSR
	"0000" & "000010", -- 011010 | 1a | LOAD tmp
	"0001" & "100000", -- 011011 | 1b | STORE to INDF
	"0000" & "100001", -- 011100 | 1c | LOAD FSR
	"0100" & "111111", -- 011101 | 1d | INC 
	"0001" & "100001", -- 011110 | 1e | STORE to FSR
	"0000" & "100001", -- 011111 | 1f | LOAD FSR; m:SKIP
	"0101" & "111111", -- 100000 | 20 | DEC 
	"0001" & "100001", -- 100001 | 21 | STORE to FSR
	"0000" & "000100", -- 100010 | 22 | LOAD loop inner
	"0101" & "111111", -- 100011 | 23 | DEC 
	"0001" & "000100", -- 100100 | 24 | STORE loop inner
	"0110" & "001000", -- 100101 | 25 | JNZ GOTO INNER_LOOP
	"0000" & "000011", -- 100110 | 26 | LOAD loop main
	"0101" & "111111", -- 100111 | 27 | DEC 
	"0001" & "000011", -- 101000 | 28 | STORE loop main
	"0110" & "000011", -- 101001 | 29 | JNZ GOTO MAIN_LOOP
	"1010" & "111111", -- 101010 | 2a | HALT 
	others => "1010" & "000000"
	);
	signal data: instruction_word;
begin
	data <= ROM(conv_integer(adr));
	zbufs: process (RE, data)
	begin
		if (RE = '1') then
			DOUT <= data;
		else
			DOUT <= (others => 'Z');
		end if;
	end process;
end Beh_Sort;
