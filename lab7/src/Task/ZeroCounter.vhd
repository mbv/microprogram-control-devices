library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_UNSIGNED.all;

entity ZeroCounter is 
	port (
		CLK, RST, Start: in std_logic;
		Stop: out std_logic;	 
		Res: out std_logic_vector(7 downto 0)
		);
end ZeroCounter;

architecture Beh of ZeroCounter is
	component MROM is
		port (
			RE: in std_logic;
			ADR: in std_logic_vector(5 downto 0);
			DOUT: out std_logic_vector(9 downto 0)
			);
	end component;
	
	component MRAM is
		port (
			RW: in std_logic;
			ADR: in std_logic_vector(5 downto 0);
			DIN: in std_logic_vector (7 downto 0);
			DOUT: out std_logic_vector (7 downto 0);
			DEBUG_RES: out std_logic_vector (7 downto 0)
			);
	end component;
	
	component ALU is
		port(
			EN: in std_logic;
			OT: in std_logic_vector(3 downto 0);
			OP1: in std_logic_vector(7 downto 0);
			RES: out std_logic_vector(7 downto 0);
			ZF: out std_logic;
			SBF: out std_logic
			);
	end component;
	
	component CTRL is
		port(
			CLK, RST, Start: in std_logic;
			Stop: out std_logic;
			
			ROM_re: out std_logic;
			ROM_adr: out std_logic_vector(5 downto 0);
			ROM_dout: in std_logic_vector(9 downto 0);
			
			RAM_rw: out std_logic;
			RAM_adr: out std_logic_vector(5 downto 0);
			RAM_din: out std_logic_vector(7 downto 0);
			RAM_dout: in std_logic_vector(7 downto 0);
			
			ALU_op1: out std_logic_vector(7 downto 0);
			ALU_ot: out std_logic_vector(3 downto 0);
			ALU_en: out std_logic;
			ALU_res: in std_logic_vector(7 downto 0);
			ALU_zf: in std_logic;
			ALU_sbf: in std_logic
			);
	end component;
	
	signal rom_re: std_logic;
	signal rom_adr: std_logic_vector(5 downto 0);
	signal rom_dout: std_logic_vector(9 downto 0);
	signal ram_rw: std_logic;
	signal ram_adr: std_logic_vector(5 downto 0);
	signal ram_din: std_logic_vector(7 downto 0);
	signal ram_dout: std_logic_vector(7 downto 0);
	signal alu_op1: std_logic_vector(7 downto 0);
	signal alu_ot: std_logic_vector(3 downto 0);
	signal alu_en: std_logic;
	signal alu_res: std_logic_vector(7 downto 0);
	signal alu_zf: std_logic;
	signal alu_sbf: std_logic;
	
	signal dres: std_logic_vector(7 downto 0);	 -- debug
	
begin
	UMRAM: entity MRAM (Beh_Zer) port map(
		RW => ram_rw,
		ADR => ram_adr,
		DIN => ram_din,
		DOUT => ram_dout,
		DEBUG_RES => dres
		);
	UMROM: entity MROM (Beh_Zer) port map (
		RE => rom_re,
		ADR => rom_adr,
		DOUT => rom_dout
		);
	UALU: ALU port map(
		EN => alu_en,
		OT => alu_ot,
		OP1 => alu_op1,
		RES => alu_res,
		ZF => alu_zf,
		SBF => alu_sbf
		);
	UCTRL: CTRL port map(
		CLK => CLK,
		RST => RST,
		START => Start,
		STOP => STOP,
		ROM_RE => rom_re,
		ROM_ADR => rom_adr,
		ROM_DOUT => rom_dout,
		RAM_RW => ram_rw,
		RAM_ADR => ram_adr,
		RAM_DIN => ram_din,
		RAM_DOUT => ram_dout,
		ALU_EN => alu_en,
		ALU_OT => alu_ot,
		ALU_OP1 => alu_op1,
		ALU_RES => alu_res,
		ALU_ZF => alu_zf,
		ALU_SBF => alu_sbf
		);
	Res <= dres;
end Beh;