----------------------------------------------------------------------------------
-- Company: Universidad Catolica
-- Engineer: Vicente Gonzalez
-- 
-- Create Date:    14:23:16 04/09/2010 
-- Design Name: 
-- Module Name:    exten_signo - Behavioral 
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
--use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.numeric_std.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY exten_signo_cero IS
	PORT (
		e : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		cero_ext : IN STD_LOGIC;
		s : OUT STD_LOGIC_VECTOR (31 DOWNTO 0));
END exten_signo_cero;

ARCHITECTURE Behavioral OF exten_signo_cero IS

BEGIN
	s <= STD_LOGIC_VECTOR(resize(unsigned (e), s'length)) WHEN cero_ext = '1' ELSE
		STD_LOGIC_VECTOR(resize(signed (e), s'length)) WHEN cero_ext = '0' ELSE
		X"00000000";
	--	s <= X"0000" & e when cero_ext = '1' else
	--	     X"0000" & e when e(15) = '0' and cero_ext = '0' else
	--	     X"FFFF" & e when e(15) = '1' and cero_ext = '0' else
	--		  X"0000" & e;
END Behavioral;