----------------------------------------------------------------------------------
-- Company: Universidad Catolica
-- Engineer: Vicente Gonzalez
-- 
-- Create Date:    16:34:44 04/05/2010 
-- Design Name: 
-- Module Name:    mi - Behavioral 
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
USE IEEE.numeric_std.ALL;
USE std.textio.ALL;
USE ieee.std_logic_textio.ALL;
USE work.general.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY mi IS
	PORT (
		dir : IN STD_LOGIC_VECTOR (NUM_BITS_MEMORIA_INSTRUCCIONES - 1 DOWNTO 0);
		s : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		-- interfaz con el programador
		dirMI : IN STD_LOGIC_VECTOR (NUM_BITS_MEMORIA_INSTRUCCIONES - 1 DOWNTO 0);
		dataS : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		dataE : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		writeProg : IN STD_LOGIC;
		clk : IN STD_LOGIC
	);
END mi;

ARCHITECTURE Behavioral OF mi IS
	-- funcion que carga el contenido de la ROM desde un archivo
	IMPURE FUNCTION ROM_INIC (archivo : IN STRING) RETURN mem_instrucciones IS
		FILE f : text IS IN archivo;
		VARIABLE l : line;
		VARIABLE r : mem_instrucciones;
		VARIABLE good : BOOLEAN;
	BEGIN
		FOR I IN mem_instrucciones'RANGE LOOP
			IF endfile (f) THEN
				r(I) := X"00000000"; -- si el archivo se acaba antes completamos con ceros
			ELSE
				readline (f, l); -- leemos una linea
				hread (l, r(I)); -- convertimos a std_logic_vector
			END IF;
		END LOOP;
		RETURN r;
	END FUNCTION;

	-- creamos e inicializamos la memoria de instrucciones a partir del archivo
	SIGNAL mi : mem_instrucciones := ROM_INIC(filename);

BEGIN
	-- puerto de lectura normal del MIPS
	s <= mi(to_integer(unsigned(dir)));

	-- puerto de lectura para la verificacion desde el programador
	dataS <= mi(to_integer(unsigned(dirMI)));

	-- puerto de escritura para la programacion
	puertoEscritura : PROCESS (clk, writeProg)
	BEGIN
		IF clk'event AND clk = '1' THEN
			IF writeProg = '1' THEN
				mi(to_integer(unsigned(dirMI))) <= dataE;
			END IF;
		END IF;
	END PROCESS;
END Behavioral;