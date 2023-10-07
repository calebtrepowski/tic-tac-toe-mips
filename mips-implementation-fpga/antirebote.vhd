----------------------------------------------------------------------------------
-- Company: Universidad Catolica
-- Engineer: Vicente Gonzalez
-- 
-- Create Date:    14:17:31 05/12/2010 
-- Design Name: 
-- Module Name:    antirebote - Behavioral 
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

ENTITY antirebote IS
	PORT (
		boton1 : IN STD_LOGIC;
		boton2 : IN STD_LOGIC;
		clk : IN STD_LOGIC;
		reset : OUT STD_LOGIC := '0');
END antirebote;

ARCHITECTURE Behavioral OF antirebote IS

BEGIN
	PROCESS (clk)
	BEGIN
		IF clk'event AND clk = '1' THEN
			IF boton1 = '1' THEN
				reset <= '1';
			ELSIF boton2 = '1' THEN
				reset <= '0';
			END IF;
		END IF;
	END PROCESS;
END Behavioral;