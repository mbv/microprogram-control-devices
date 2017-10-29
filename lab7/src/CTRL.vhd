library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_UNSIGNED.all;

entity CTRL is
	port(
		CLK, RST, Start: in std_logic;
		Stop: out std_logic;
		
		-- ПЗУ
		ROM_re: out std_logic;
		ROM_adr: out std_logic_vector(5 downto 0);
		ROM_dout: in std_logic_vector(9 downto 0);
		
		-- ОЗУ
		RAM_rw: out std_logic;
		RAM_adr: out std_logic_vector(5 downto 0);
		RAM_din: out std_logic_vector(7 downto 0);
		RAM_dout: in std_logic_vector(7 downto 0);
		--datapath
		ALU_op1: out std_logic_vector(7 downto 0);
		ALU_ot: out std_logic_vector(3 downto 0);
		ALU_en: out std_logic;
		ALU_res: in std_logic_vector(7 downto 0);
		ALU_zf: in std_logic;
		ALU_sbf: in std_logic;
		
		--Debug
		D_FSR: out std_logic_vector(7 downto 0)
		);
end CTRL;
-- Adress for spec registers
-- INDF 100000 
-- FSR  100001
architecture Beh of CTRL is								 
	subtype machine_word is std_logic_vector(7 downto 0);	
	subtype operation_word is std_logic_vector(3 downto 0);		
	subtype address_word is std_logic_vector(5 downto 0);
	type states is (I, F, D, R, L, S, A, SB, SINC, SDEC, H, SJMP, SJNZ, SJZ, SJSB);
	--I - idle -
	--F - fetch
	--D - decode
	--R - read
	--L - load
	--S - store
	--A - add
	--SB - sub	 
	--INC - add
	--DEC - sub
	--H - halt	   
	--JNZ - jump if not zero flag set
	--JZ - jump if zero flag set
	--JSB - jump if not sign bit set
	signal nxt_state, cur_state: states;
	--регистр выбранной инструкции
	signal RI: std_logic_vector(9 downto 0);
	--регистр счетчика инструкций
	signal IC: address_word;
	--регистр типа операции
	signal RO: operation_word;
	--регистр адреса памяти
	signal RA: address_word;
	--регистр данных
	signal RD: machine_word;
	
	signal SPEC_REG: std_logic;
	
	--регистр FSR
	signal FSR: machine_word;
	
	constant LOAD : operation_word := "0000";
	constant STORE: operation_word := "0001";
	constant ADD  : operation_word := "0010";
	constant SUB  : operation_word := "0011";
	constant INC  : operation_word := "0100";
	constant DEC  : operation_word := "0101";
	constant JNZ  : operation_word := "0110";
	constant JZ   : operation_word := "0111";
	constant JNSB : operation_word := "1000";
	constant JMP  : operation_word := "1001";
	constant HALT : operation_word := "1010";
begin
	--синхронная память
	FSM: process(CLK, RST, nxt_state)
	begin
		if (RST = '1') then
			cur_state <= I;
		elsif rising_edge(CLK) then
			cur_state <= nxt_state;
		end if;
	end process;
	
	-- Комбинационная часть. Выработка след. состояния
	COMB: process(cur_state, start, RO)
	begin
		case cur_state is 
			when I => 
				if (start = '1') then 
					nxt_state <= F;
				else
					nxt_state <= I;
			end if;
			when F => nxt_state <= D;
			when D => 
				if (RO = HALT) then
					nxt_state <= H;
				elsif (RO = STORE) then
					nxt_state <= S;
				elsif (RO = JMP) then
					nxt_state <= SJMP;
				elsif (RO = JZ) then
					nxt_state <= SJZ;
				elsif (RO = JNZ) then
					nxt_state <= SJNZ;
				elsif (RO = JNSB) then
					nxt_state <= SJSB;
				else
					nxt_state <= R;
			end if;
			when R => 
				if (RO = LOAD) then 
					nxt_state <= L;
				elsif (RO = ADD) then
					nxt_state <= A;
				elsif (RO = SUB) then
					nxt_state <= SB;
				elsif (RO = INC) then
					nxt_state <= SINC;
				elsif (RO = DEC) then
					nxt_state <= SDEC;
				else
					nxt_state <= I;
			end if;
			when L | S | A | SB | SINC | SDEC | SJMP | SJZ | SJNZ | SJSB => nxt_state <= F;
			when H => nxt_state <= H;
			when others => nxt_state <= I;
		end case;
	end process;
	
	--выработка сигнала stop
	PSTOP: process (cur_state)
	begin
		if (cur_state = H) then
			stop <= '1';
		else
			stop <= '0';
		end if;
	end process;
	
	-- счетчик инструкций
	PMC: process (CLK, RST, cur_state)
	begin
		if (RST = '1') then
			IC <= "000000";
		elsif falling_edge(CLK) then
			if (cur_state = D) then
				IC <= IC + 1;
			elsif (cur_state = SJZ and ALU_ZF = '1') then
				IC <= RA;		 
			elsif (cur_state = SJNZ and ALU_ZF = '0') then
				IC <= RA;
			elsif (cur_state = SJSB and  ALU_SBF = '0') then
				IC <= RA; 
			elsif (cur_state = SJMP) then
				IC <= RA;
			end if;
		end if;
	end process;
	
	ROM_adr <= IC;
	
	--сигнал чтения из памяти ROM
	PROMREAD: process (nxt_state, cur_state)
	begin
		if (nxt_state = F or cur_state = F) then
			ROM_re <= '1';
		else
			ROM_re <= '0';
		end if;
	end process;
	
	--чтение выбранного значения инструкций и запись его в RI
	PROMDAT: process (RST, cur_state, ROM_dout)
	begin
		if (RST = '1') then
			RI <= "0000000000";
		elsif (cur_state = F) then
			RI <= ROM_dout;
		end if;
	end process;
	
	-- схема управления регистрами RO и RA
	PRORA: process (RST, nxt_state, RI)
	begin
		if (RST = '1') then
			RO <= "0000";
			RA <= "000000";
		elsif (nxt_state = D) then
			RO <= RI (9 downto 6);
			RA <= RI (5 downto 0);
		end if;
	end process;
	
	PRAMST: process (RA)
	begin
		if (cur_state /= SJMP and cur_state /= SJNZ and cur_state /= SJZ and cur_state /= SJSB) then
			if (RA = "100000") then -- write to INDF
				RAM_adr <= FSR(5 downto 0);
			elsif (RA /= "100001") then -- not write to FSR
				RAM_adr <= RA;	  
			end if;
		end if;
	end process;
	
	--управляющий сигнал чтения/записи в RAM
	PRAMREAD: process (cur_state)
	begin
		if (cur_state = S and RA /= "100001") then	 -- No write to FSR
			RAM_rw <= '0';
		else
			RAM_rw <= '1';
		end if;
	end process; 
	
	WRITE_TO_FSR: process (cur_state)
	begin
		if (cur_state = S and RA = "100001") then
			FSR <= ALU_res;
		end if;
	end process;
	
	--запись значения из памяти RAM в регистр RD
	PRAMDAR: process (cur_state)
	begin
		if (cur_state = R) then
			if (RA = "100001") then
				RD <= FSR;
			else 
				RD <= RAM_dout;
			end if;
		end if;
	end process;
	
	--передача результирующего значения тракта обработки данных на входную шину памяти RAM
	RAM_din <= ALU_res;
	--передача значения регистра RD на вход первого операнда
	ALU_op1 <= RD;
	--передача значения регистра RO на входную шину типа операций
	ALU_ot <= RO;  
	
	paddsuben: process (cur_state)
	begin
		if (cur_state = A or cur_state = SB or cur_state = SINC or cur_state = SDEC or cur_state = L) then
			ALU_en <= '1';
		else
			ALU_en <= '0';
		end if;
	end process; 
	
	
	--Debug
	
	D_FSR <= FSR;
end Beh;