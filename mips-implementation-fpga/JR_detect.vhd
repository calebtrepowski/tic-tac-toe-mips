----------------------------------------------------------------------------------
-- Company: Universidad Catolica
-- Engineer: Vicente Gonzalez
-- 
-- Create Date:    08:55:47 04/12/2014 
-- Design Name: 
-- Module Name:    JR_detect - Behavioral 
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

ENTITY JR_detect IS
	PORT (
		funct : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
		jr : OUT STD_LOGIC);
END JR_detect;

ARCHITECTURE Behavioral OF JR_detect IS
	CONSTANT JR_FUNCT : STD_LOGIC_VECTOR(5 DOWNTO 0) := "001000";
BEGIN
	jr <= '1' WHEN funct = JR_FUNCT ELSE
		'0';

END Behavioral;