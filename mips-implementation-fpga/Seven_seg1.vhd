----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:17:34 10/19/2022 
-- Design Name: 
-- Module Name:    Seven_seg1 - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY Seven_seg1 IS
	PORT (
		digit_1, digit_2, digit_3 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		clk : IN STD_LOGIC;
		anodo : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		LED : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END Seven_seg1;

ARCHITECTURE Behavioral OF Seven_seg1 IS
	SIGNAL dato : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
	SIGNAL sel : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
BEGIN

	--Seleccionar cada display
	PROCESS (clk, sel)
	BEGIN
		IF (clk'event AND clk = '1') THEN
			CASE sel IS
				WHEN "00" =>
					anodo <= "110";
					dato <= digit_1; --unidad
				WHEN "01" =>
					anodo <= "101";
					dato <= digit_2; --decena
				WHEN "10" =>
					anodo <= "011";
					dato <= digit_3; --centena
					sel <= "00";
				WHEN OTHERS =>
					anodo <= "111"; --todos apagados
			END CASE;
			sel <= STD_LOGIC_VECTOR(unsigned(sel) + 1);

		END IF;
	END PROCESS;
	--Decodificador BCD a 7 Segmentos

	WITH dato SELECT
		LED <= "1000000" WHEN "0000", --0
		"1111001" WHEN "0001", --1
		"0100100" WHEN "0010", --2
		"0110000" WHEN "0011", --3
		"0011001" WHEN "0100", --4
		"0010010" WHEN "0101", --5
		"0000010" WHEN "0110", --6
		"1111000" WHEN "0111", --7
		"0000000" WHEN "1000", --8
		"0010000" WHEN "1001", --9
		"1111111" WHEN OTHERS; --todos apagados

END Behavioral;