library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;


entity ALU is		  
	port(
		EN: in std_logic;
		-- operation
		OT: in std_logic_vector(3 downto 0);
		-- operand
		OP1: in std_logic_vector(7 downto 0);
		RES: out std_logic_vector(7 downto 0);
		-- zero flag
		ZF: out std_logic;
		-- significant bit set flag
		SBF: out std_logic
		);
end ALU;

architecture Beh of ALU is		   
	subtype machine_word is std_logic_vector(7 downto 0);	
	subtype operation_word is std_logic_vector(3 downto 0);
	
	signal ACCUM: machine_word;
	signal res_add: machine_word;
	signal res_sub: machine_word;  
	signal res_inc: machine_word;
	signal res_dec: machine_word;
	signal t_zf, t_sbf: std_logic;
	
	constant LOAD: std_logic_vector(3 downto 0) := "0000";
	constant ADD: std_logic_vector(3 downto 0) := "0010";
	constant SUB: std_logic_vector(3 downto 0) := "0011";	 
	constant INC: std_logic_vector(3 downto 0) := "0100";
	constant DEC: std_logic_vector(3 downto 0) := "0101";
Begin 
	
	res_add <= CONV_STD_LOGIC_VECTOR(CONV_INTEGER(ACCUM) + CONV_INTEGER(OP1), 8);
	res_sub <= CONV_STD_LOGIC_VECTOR(CONV_INTEGER(ACCUM) - CONV_INTEGER(OP1), 8);
	
	res_inc <= CONV_STD_LOGIC_VECTOR(CONV_INTEGER(ACCUM) + 1, 8);
	res_dec <= CONV_STD_LOGIC_VECTOR(CONV_INTEGER(ACCUM) - 1, 8);
	
	REGA: process (EN, OT, OP1, res_add, res_sub, res_inc, res_dec)
	begin
		if rising_edge(EN) then
			case OT is
				when LOAD => ACCUM <= OP1; 
				when ADD => ACCUM <= res_add;
				when SUB => ACCUM <= res_sub;	  
				when INC => ACCUM <= res_inc;
				when DEC => ACCUM <= res_dec;
				when others => null;
			end case;
		end if;
	end process;
	
	FLAGS: process(ACCUM)
	begin
		if ACCUM = (ACCUM'range => '0') then
			t_zf <= '1';
		else
			t_zf <= '0';
		end if;
		if ACCUM(7) = '1' then
			t_sbf <= '1';
		else
			t_sbf <= '0';
		end if;
	end process;
	
	RES <= ACCUM;
	ZF 	<= t_zf;
	SBF <= t_sbf;
End Beh;