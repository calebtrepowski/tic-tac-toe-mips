----------------------------------------------------------------------------------
-- Company: Universidad Catolica
-- Engineer: Vicente Gonzalez
-- 
-- Create Date:    14:53:12 06/24/2019 
-- Design Name: MIPS
-- Module Name:    divisorCLK - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: Divisor de frecuencia obtener 25 MHz apartir del clock de 50 MHz de la
-- placa Spartan-3AN Starter Kit. El dispositivo no puede correr a 50 Mhz.
-- 
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

ENTITY divisorCLK IS
	PORT (
		clk100mhz : IN STD_LOGIC;
		clk : OUT STD_LOGIC);
END divisorCLK;

-- Divisor de Frecuencia para el MIPS.
-- La frecuencia de 50 MHz es dividida por 2.
ARCHITECTURE Behavioral OF divisorCLK IS
	SIGNAL clk50mhz : STD_LOGIC := '0';
	SIGNAL clk25mhz : STD_LOGIC := '0';
BEGIN
	PROCESS (clk100mhz)
	BEGIN
		IF clk100mhz = '1' AND clk100mhz'event THEN
			clk50mhz <= NOT clk50mhz;
		END IF;
	END PROCESS;
	PROCESS (clk50mhz)
	BEGIN
		IF clk50mhz = '1' AND clk50mhz'event THEN
			clk25mhz <= NOT clk25mhz;
		END IF;
	END PROCESS;
	clk <= clk25mhz;

END Behavioral;