----------------------------------------------------------------------------------
-- Company: LED - Universidad Catolica "Nuestra Senhora de la Asuncion"
-- Engineer: Vicente Gonzalez Ayala
-- 
-- Create Date:    08:41:02 04/16/2010 
-- Design Name: MIPS - Clase de Micro 2
-- Module Name:    control1 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY control1 IS
	PORT (
		op : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
		jr_detect : IN STD_LOGIC;
		reset : IN STD_LOGIC;

		tipoAcc : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
		regdst : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
		branch : OUT STD_LOGIC;
		bne : OUT STD_LOGIC;
		memread : OUT STD_LOGIC;
		memtoreg : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
		aluop : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
		memwrite : OUT STD_LOGIC;
		alusrc : OUT STD_LOGIC;
		lui : OUT STD_LOGIC;
		jump : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
		regwrite : OUT STD_LOGIC;
		Zero_extend : OUT STD_LOGIC);
END control1;

ARCHITECTURE Behavioral OF control1 IS
	CONSTANT R_OP : STD_LOGIC_VECTOR(5 DOWNTO 0) := "000000"; -- ADD, SUB, AND, OR, SLT, SLL, SRL y SRA
	CONSTANT ADDI_OP : STD_LOGIC_VECTOR(5 DOWNTO 0) := "001000";
	CONSTANT ADDIU_OP : STD_LOGIC_VECTOR(5 DOWNTO 0) := "001001";
	CONSTANT ORI_OP : STD_LOGIC_VECTOR(5 DOWNTO 0) := "001101";
	CONSTANT XORI_OP : STD_LOGIC_VECTOR(5 DOWNTO 0) := "001110";
	CONSTANT ANDI_OP : STD_LOGIC_VECTOR(5 DOWNTO 0) := "001100";
	CONSTANT SLTI_OP : STD_LOGIC_VECTOR(5 DOWNTO 0) := "001010";
	CONSTANT SLTIU_OP : STD_LOGIC_VECTOR(5 DOWNTO 0) := "001011";
	CONSTANT JUMP_OP : STD_LOGIC_VECTOR(5 DOWNTO 0) := "000010";
	CONSTANT BNE_OP : STD_LOGIC_VECTOR(5 DOWNTO 0) := "000101";
	CONSTANT BEQ_OP : STD_LOGIC_VECTOR(5 DOWNTO 0) := "000100";
	CONSTANT LW_OP : STD_LOGIC_VECTOR(5 DOWNTO 0) := "100011";
	CONSTANT LH_OP : STD_LOGIC_VECTOR(5 DOWNTO 0) := "100001";
	CONSTANT LHU_OP : STD_LOGIC_VECTOR(5 DOWNTO 0) := "100101";
	CONSTANT LB_OP : STD_LOGIC_VECTOR(5 DOWNTO 0) := "100000";
	CONSTANT LBU_OP : STD_LOGIC_VECTOR(5 DOWNTO 0) := "100100";
	CONSTANT SW_OP : STD_LOGIC_VECTOR(5 DOWNTO 0) := "101011";
	CONSTANT SH_OP : STD_LOGIC_VECTOR(5 DOWNTO 0) := "101001";
	CONSTANT SB_OP : STD_LOGIC_VECTOR(5 DOWNTO 0) := "101000";
	CONSTANT LUI_OP : STD_LOGIC_VECTOR(5 DOWNTO 0) := "001111";
	CONSTANT JAL_OP : STD_LOGIC_VECTOR(5 DOWNTO 0) := "000011";
BEGIN
	regdst <= "01" WHEN op = R_OP AND jr_detect = '0' AND reset = '0' ELSE -- en instrucciones formato R
		"10" WHEN op = JAL_OP AND reset = '0' ELSE -- en instrucciones JAL
		--'11' when else -- combinacion que no se usa
		"00"; -- en todas las demas, incluido el caso de que reset sea '1'
	branch <= '1' WHEN (op = BEQ_OP OR op = BNE_OP) AND reset = '0' ELSE -- en beq o bne
		'0';
	bne <= '1' WHEN op = BNE_OP AND reset = '0' ELSE
		'0';
	memread <= '1' WHEN (op = LW_OP OR op = LB_OP OR op = LBU_OP OR op = LH_OP OR op = LHU_OP) AND reset = '0' ELSE -- en lw o lb o lbu o lh o lhu
		'0';
	memtoreg <= "01" WHEN (op = LW_OP OR op = LB_OP OR op = LBU_OP OR op = LH_OP OR op = LHU_OP) AND reset = '0' ELSE -- en lw o lb o lbu o lh o lhu
		"10" WHEN op = LUI_OP AND reset = '0' ELSE -- en lui
		"11" WHEN op = JAL_OP AND reset = '0' ELSE -- en JAL
		"00"; -- para todos los demas casos
	aluop <= "000" WHEN (op = LW_OP OR op = LB_OP OR op = LBU_OP OR op = LH_OP OR op = LHU_OP OR op = SW_OP OR op = SB_OP OR op = SH_OP OR op = ADDI_OP OR OP = ADDIU_OP) AND reset = '0' ELSE -- en lw, lb, lbu, lh, lhu, sw, sb, sh o addi
		"001" WHEN (op = BEQ_OP OR op = BNE_OP) AND reset = '0' ELSE -- en beq o bne
		"010" WHEN (op = R_OP AND jr_detect = '0') AND reset = '0' ELSE -- en instrucciones formato R
		"011" WHEN op = ORI_OP AND reset = '0' ELSE -- en la instruccion ORI
		"100" WHEN op = ANDI_OP AND reset = '0' ELSE -- en la instruccion ANDI
		"110" WHEN op = XORI_OP AND reset = '0' ELSE -- en la instruccion XORI
		"101" WHEN op = SLTI_OP AND reset = '0' ELSE -- en la instruccion SLTI
		"111" WHEN op = SLTIU_OP AND reset = '0' ELSE -- en la instruccion SLTIU
		"000"; -- si no se cumple ninguna de las condiciones anteriores 
	memwrite <= '1' WHEN (op = SW_OP OR op = SB_OP OR op = SH_OP) AND reset = '0' ELSE -- en sw, sb, sh
		'0';
	alusrc <= '1' WHEN (op = LW_OP OR op = LB_OP OR op = LBU_OP OR op = LH_OP OR op = LHU_OP OR op = SW_OP OR op = SB_OP OR op = SH_OP OR op = ADDI_OP OR op = ADDIU_OP OR op = ORI_OP OR op = XORI_OP OR op = ANDI_OP OR op = SLTI_OP OR op = SLTIU_OP) AND reset = '0' ELSE -- en lw, lb, lbu, lh, lhu, sw, sb, sh, ori o addi
		'0';
	regwrite <= '1' WHEN ((op = R_OP AND jr_detect = '0') OR op = LW_OP OR op = LB_OP OR op = LBU_OP OR op = LH_OP OR op = LHU_OP OR op = LUI_OP OR op = ADDI_OP OR op = ADDIU_OP OR op = ORI_OP OR op = XORI_OP OR op = ANDI_OP OR op = SLTI_OP OR op = SLTIU_OP OR op = JAL_OP) AND reset = '0' ELSE -- en instrucciones formato R, lw, lb, lbu, lh, lhu, lui, ori o addi
		'0';
	lui <= '1' WHEN op = LUI_OP AND reset = '0' ELSE -- en instruccion lui
		'0';
	jump <= "01" WHEN (op = JUMP_OP OR op = JAL_OP)AND reset = '0' ELSE -- en jump y jal
		"10" WHEN op = R_OP AND jr_detect = '1' AND reset = '0' ELSE -- en instruccion jr
		"00";
	Zero_extend <= '1' WHEN (op = ANDI_OP OR op = ORI_OP OR op = XORI_OP) AND reset = '0' ELSE -- en andi, xori y ori
		'0';
	tipoAcc <= "000" WHEN (op = LW_OP OR op = SW_OP) AND reset = '0' ELSE
		"001" WHEN (op = LHU_OP OR op = SH_OP) AND reset = '0' ELSE
		"011" WHEN (op = LH_OP OR op = SH_OP) AND reset = '0' ELSE
		"010" WHEN (op = LBU_OP OR op = SB_OP) AND reset = '0' ELSE
		"100" WHEN (op = LB_OP OR op = SB_OP) AND reset = '0' ELSE
		"111";

END Behavioral;