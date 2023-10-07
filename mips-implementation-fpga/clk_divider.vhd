----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:12:48 10/19/2022 
-- Design Name: 
-- Module Name:    clk_divider - Behavioral 
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

ENTITY clk_divider IS
	PORT (
		mclk : IN STD_LOGIC;
		clk : OUT STD_LOGIC);
END clk_divider;

ARCHITECTURE Behavioral OF clk_divider IS
	SIGNAL cuenta : STD_LOGIC_VECTOR (26 DOWNTO 0);
	SIGNAL aux : STD_LOGIC := '0';
BEGIN

	PROCESS (mclk, cuenta)

	BEGIN
		IF (mclk'event AND mclk = '1') THEN
			cuenta <= STD_LOGIC_VECTOR(unsigned(cuenta) + 1);

			IF unsigned(cuenta) = 200000 THEN
				cuenta <= (OTHERS => '0');
				aux <= NOT(aux);
			END IF;
		END IF;
	END PROCESS;
	clk <= aux;

END Behavioral;