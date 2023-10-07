----------------------------------------------------------------------------------
-- Company: Universidad Catolica
-- Engineer: Vicente Gonzalez
-- 
-- Create Date:    14:42:30 04/09/2010 
-- Design Name: 
-- Module Name:    alu_control - Behavioral 
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

ENTITY alu_control IS
	PORT (
		aluop : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		funct : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
		s : OUT STD_LOGIC_VECTOR (3 DOWNTO 0));
END alu_control;

ARCHITECTURE Behavioral OF alu_control IS

BEGIN
	s <= "0000" WHEN aluop = "000" ELSE -- SW, LW y ADDI
		"0001" WHEN aluop = "001" ELSE -- BNE y BEQ
		"0011" WHEN aluop = "011" ELSE -- ORI
		"0010" WHEN aluop = "100" ELSE -- ANDI
		"0100" WHEN aluop = "101" ELSE -- SLTI
		"1110" WHEN aluop = "110" ELSE -- XORI
		"1101" WHEN aluop = "111" ELSE -- SLTUI		  
		"0000" WHEN aluop = "010" AND (funct = "100000" OR funct = "100001") ELSE -- ADD y ADDU
		"0001" WHEN aluop = "010" AND (funct = "100010" OR funct = "100011") ELSE -- SUB y SUBU
		"0010" WHEN aluop = "010" AND funct = "100100" ELSE -- AND
		"0011" WHEN aluop = "010" AND funct = "100101" ELSE -- OR
		"0100" WHEN aluop = "010" AND funct = "101010" ELSE -- SLT
		"1101" WHEN aluop = "010" AND funct = "101011" ELSE -- SLTU
		"0101" WHEN aluop = "010" AND funct = "000000" ELSE -- SLL
		"0110" WHEN aluop = "010" AND funct = "000010" ELSE -- SRL
		"1000" WHEN aluop = "010" AND funct = "000110" ELSE -- SRLV
		"1001" WHEN aluop = "010" AND funct = "000100" ELSE -- SLLV
		"1010" WHEN aluop = "010" AND funct = "000011" ELSE -- SRA
		"1011" WHEN aluop = "010" AND funct = "000111" ELSE -- SRAV
		"1110" WHEN aluop = "010" AND funct = "100110" ELSE -- XOR
		"1111" WHEN aluop = "010" AND funct = "100111" ELSE -- NOR
		"0111"; -- esta situacion no debe darse nunca
END Behavioral;