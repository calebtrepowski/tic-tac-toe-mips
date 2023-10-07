----------------------------------------------------------------------------------
-- Company: Universidad Catolica
-- Engineer: Vicente Gonzalez
-- 
-- Create Date:    14:00:15 04/08/2010 
-- Design Name: 
-- Module Name:    reg - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: Implementa los 32 registros del MIPS. 
-- En realidad se implementa utilizando 31 posiciones de memoria de 32 bits cada una y
-- la direccion 0 es una constante que retorna el valor cero y lo que se escribe no se guarda.
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
USE IEEE.numeric_std.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY reg IS
	PORT (
		rr1 : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		rr2 : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		wr : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		wd : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		clk : IN STD_LOGIC;
		regwrite : IN STD_LOGIC;
		reset : IN STD_LOGIC;
		rd1 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		rd2 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
END reg;

ARCHITECTURE Behavioral OF reg IS
	TYPE mem IS ARRAY (0 TO 30) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL reg : mem := (OTHERS => X"00000000");
BEGIN
	-- implementacion de la lectura de los registros
	rd1 <= X"00000000" WHEN rr1 = B"00000" ELSE
		reg(to_integer(unsigned(rr1)) - 1);
	rd2 <= X"00000000" WHEN rr2 = B"00000" ELSE
		reg(to_integer(unsigned(rr2)) - 1);

	-- proceso para la escritura de los registros
	PROCESS (clk) IS
	BEGIN
		IF clk'event AND clk = '1' THEN
			IF reset = '1' THEN
				reg(0) <= X"00000000";
			ELSIF regwrite = '1' AND wr /= B"00000" THEN
				reg(to_integer(unsigned(wr)) - 1) <= wd;
			END IF;
		END IF;

	END PROCESS;
END Behavioral;