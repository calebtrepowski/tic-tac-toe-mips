----------------------------------------------------------------------------------
-- Company: Universidad Catolica
-- Engineer: Vicente Gonzalez
-- 
-- Create Date:    14:28:41 06/14/2017 
-- Design Name: 
-- Module Name:    decodificador - Behavioral 
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

ENTITY decodificador IS
	PORT (
		ent : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		csVGA : OUT STD_LOGIC;
		csMem : OUT STD_LOGIC;
		cs_dis : OUT STD_LOGIC;
		csParPort : OUT STD_LOGIC;
		csEntrada : OUT STD_LOGIC);
END decodificador;

ARCHITECTURE Behavioral OF decodificador IS

BEGIN
	-- VGA
	csVGA <= '1' WHEN ent(31 DOWNTO 8) = X"FFFF00" ELSE
		'0';

	-- memoria
	csMem <= '1' WHEN ent(31 DOWNTO 16) = X"1001" ELSE
		'0';

	-- Puerto paralelo de salida
	csParPort <= '1' WHEN ent = X"FFFF8000" ELSE
		'0';

	-- habilitador de lectura de las llaves
	csEntrada <= '1' WHEN ent = X"FFFFD000" ELSE
		'0';

END Behavioral;