----------------------------------------------------------------------------------
-- Company: Universidad Catolica
-- Engineer: Vicente Gonzalez
-- 
-- Create Date:    15:24:01 06/15/2017 
-- Design Name: 
-- Module Name:    barrel_shifter - Behavioral 
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
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;
USE IEEE.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY barrel_shifter IS
	PORT (
		e : IN STD_LOGIC_VECTOR (31 DOWNTO 0); -- entrada
		control : IN STD_LOGIC_VECTOR (4 DOWNTO 0); -- control, cantidad de bits a correr
		op : IN STD_LOGIC_VECTOR (1 DOWNTO 0); -- corrimiento a la derecha, a la izquierda o derecha aritmetico
		s : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)); -- salida
END barrel_shifter;

ARCHITECTURE RTL OF barrel_shifter IS

BEGIN
	-- corrimiento logico o aritmetico
	s <= to_stdlogicvector(to_bitvector(e) SLL CONV_INTEGER(control)) WHEN op = "00" ELSE -- corrimiento logico a la izquierda
		to_stdlogicvector(to_bitvector(e) SRL CONV_INTEGER(control)) WHEN op = "01" ELSE -- corrimiento logico a la derecha
		to_stdlogicvector(to_bitvector(e) SRA CONV_INTEGER(control)) WHEN op = "10" ELSE -- corrimiento aritmetico a la derecha
		X"00000000";
	-- corrimiento aritmetico
	--	     to_stdlogicvector(to_bitvector(e) sra CONV_INTEGER(control)) when left_right = '1';	-- FUNCIONA
END RTL;