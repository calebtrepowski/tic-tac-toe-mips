----------------------------------------------------------------------------------
-- Company: Universidad Catolica
-- Engineer: Vicente Gonzalez
-- 
-- Create Date:    15:54:20 04/05/2010 
-- Design Name: 
-- Module Name:    pc - Behavioral 
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

ENTITY pc IS
	PORT (
		e : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		s : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		reset : IN STD_LOGIC;
		clk : IN STD_LOGIC);
END pc;

ARCHITECTURE Behavioral OF pc IS

BEGIN
	PROCESS (clk) IS
	BEGIN
		IF clk'event AND clk = '1' THEN
			IF reset = '1' THEN
				s <= X"00400000";
			ELSE
				s <= e;
			END IF;
		END IF;
	END PROCESS;
END Behavioral;