----------------------------------------------------------------------------------
-- Company: Universidad Catolica
-- Engineer: Vicente Gonzalez
-- 
-- Create Date:    14:35:08 06/14/2017 
-- Design Name: 
-- Module Name:    salida_par - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY salida_par IS
	PORT (
		sel : IN STD_LOGIC;
		write_cntl : IN STD_LOGIC;
		clk : IN STD_LOGIC;
		data : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		salida : OUT STD_LOGIC_VECTOR (7 DOWNTO 0));
END salida_par;

ARCHITECTURE Behavioral OF salida_par IS

BEGIN
	PROCESS (clk)
	BEGIN
		IF clk'event AND clk = '1' THEN
			IF sel = '1' AND write_cntl = '1' THEN
				salida <= data;
			END IF;
		END IF;
	END PROCESS;
END Behavioral;