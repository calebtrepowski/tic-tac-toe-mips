----------------------------------------------------------------------------------
-- Company: Universidad Catolica
-- Engineer: Vicente Gonzalez
-- 
-- Create Date:    14:25:15 06/14/2017 
-- Design Name: MIPS
-- Module Name:    md - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
-- Memoria de datos del MIPS, implementa la lectura de un byte, una media palabra (16 bits)
-- y una palabra (32 bits). Las dos primeras con o sin signo.
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
USE work.general.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY md IS
	PORT (
		dir : IN STD_LOGIC_VECTOR (NUM_BITS_MEMORIA_DATOS - 1 + 2 DOWNTO 0);
		datain : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		cs : IN STD_LOGIC;
		memwrite : IN STD_LOGIC;
		memread : IN STD_LOGIC;
		clk : IN STD_LOGIC;
		-- 000 una palabra, 
		-- 001 16 bits sin signo, 010 8 bits sin signo, 
		-- 011 16 bits con signo y 100 8 bits con signo.
		tipoAcc : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		dataout : OUT STD_LOGIC_VECTOR (31 DOWNTO 0));
END md;

ARCHITECTURE Behavioral OF md IS
	TYPE mem_byte IS ARRAY (0 TO 2 ** NUM_BITS_MEMORIA_DATOS - 1) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL mem00 : mem_byte; -- bytes menos significativos
	SIGNAL mem01 : mem_byte;
	SIGNAL mem10 : mem_byte;
	SIGNAL mem11 : mem_byte; -- bytes mas significativos
	-- senhales intermedias para medias palabras
	SIGNAL hwtemp1 : STD_LOGIC_VECTOR (15 DOWNTO 0);
	SIGNAL hwtemp2 : STD_LOGIC_VECTOR (15 DOWNTO 0);
BEGIN
	-- creamos las medias palabras (16 bits)
	hwtemp1 <= mem01(to_integer(unsigned(dir(NUM_BITS_MEMORIA_DATOS - 1 + 2 DOWNTO 2)))) & mem00(to_integer(unsigned(dir(NUM_BITS_MEMORIA_DATOS - 1 + 2 DOWNTO 2))));
	hwtemp2 <= mem11(to_integer(unsigned(dir(NUM_BITS_MEMORIA_DATOS - 1 + 2 DOWNTO 2)))) & mem10(to_integer(unsigned(dir(NUM_BITS_MEMORIA_DATOS - 1 + 2 DOWNTO 2))));

	leer : PROCESS (dir, memread, cs, mem00, mem01, mem10, mem11, tipoAcc) IS
	BEGIN
		IF cs = '1' AND memread = '1' THEN
			CASE tipoAcc IS
				WHEN "000" => -- lectura de una palabra
					dataout <= mem11(TO_INTEGER(unsigned(dir(NUM_BITS_MEMORIA_DATOS - 1 + 2 DOWNTO 2)))) &
						mem10(TO_INTEGER(unsigned(dir(NUM_BITS_MEMORIA_DATOS - 1 + 2 DOWNTO 2)))) &
						mem01(TO_INTEGER(unsigned(dir(NUM_BITS_MEMORIA_DATOS - 1 + 2 DOWNTO 2)))) &
						mem00(TO_INTEGER(unsigned(dir(NUM_BITS_MEMORIA_DATOS - 1 + 2 DOWNTO 2))));
				WHEN "001" => -- lectura de media palabra sin signo
					CASE dir(1 DOWNTO 0) IS
						WHEN "00" =>
							dataout <= X"0000" & mem01(TO_INTEGER(unsigned(dir(NUM_BITS_MEMORIA_DATOS - 1 + 2 DOWNTO 2)))) &
								mem00(TO_INTEGER(unsigned(dir(NUM_BITS_MEMORIA_DATOS - 1 + 2 DOWNTO 2))));
						WHEN "10" =>
							dataout <= X"0000" & mem11(TO_INTEGER(unsigned(dir(NUM_BITS_MEMORIA_DATOS - 1 + 2 DOWNTO 2)))) &
								mem10(TO_INTEGER(unsigned(dir(NUM_BITS_MEMORIA_DATOS - 1 + 2 DOWNTO 2))));
						WHEN OTHERS =>
							dataout <= X"00000000";
					END CASE;
				WHEN "010" => -- lectura de un byte
					CASE dir(1 DOWNTO 0) IS
						WHEN "00" =>
							dataout <= X"000000" & mem00(TO_INTEGER(unsigned(dir(NUM_BITS_MEMORIA_DATOS - 1 + 2 DOWNTO 2))));
						WHEN "01" =>
							dataout <= X"000000" & mem01(TO_INTEGER(unsigned(dir(NUM_BITS_MEMORIA_DATOS - 1 + 2 DOWNTO 2))));
						WHEN "10" =>
							dataout <= X"000000" & mem10(TO_INTEGER(unsigned(dir(NUM_BITS_MEMORIA_DATOS - 1 + 2 DOWNTO 2))));
						WHEN "11" =>
							dataout <= X"000000" & mem11(TO_INTEGER(unsigned(dir(NUM_BITS_MEMORIA_DATOS - 1 + 2 DOWNTO 2))));
						WHEN OTHERS =>
							dataout <= X"00000000";
					END CASE;
				WHEN "011" => -- lectura de media palabra con signo
					CASE dir(1 DOWNTO 0) IS
						WHEN "00" =>
							dataout <= STD_LOGIC_VECTOR(resize(signed(hwtemp1), dataout'length));
						WHEN "10" =>
							dataout <= STD_LOGIC_VECTOR(resize(signed(hwtemp2), dataout'length));
						WHEN OTHERS =>
							dataout <= X"00000000";
					END CASE;
				WHEN "100" => -- lectura de un byte con signo
					CASE dir(1 DOWNTO 0) IS
						WHEN "00" =>
							dataout <= STD_LOGIC_VECTOR(resize(signed(mem00(to_integer(unsigned(dir(NUM_BITS_MEMORIA_DATOS - 1 + 2 DOWNTO 2))))), dataout'length));
						WHEN "01" =>
							dataout <= STD_LOGIC_VECTOR(resize(signed(mem01(to_integer(unsigned(dir(NUM_BITS_MEMORIA_DATOS - 1 + 2 DOWNTO 2))))), dataout'length));
						WHEN "10" =>
							dataout <= STD_LOGIC_VECTOR(resize(signed(mem10(to_integer(unsigned(dir(NUM_BITS_MEMORIA_DATOS - 1 + 2 DOWNTO 2))))), dataout'length));
						WHEN "11" =>
							dataout <= STD_LOGIC_VECTOR(resize(signed(mem11(to_integer(unsigned(dir(NUM_BITS_MEMORIA_DATOS - 1 + 2 DOWNTO 2))))), dataout'length));
						WHEN OTHERS =>
							dataout <= X"00000000";
					END CASE;
				WHEN OTHERS => -- no debe ocurrir
					dataout <= X"00000000";
			END CASE;

		ELSE
			dataout <= X"00000000";
		END IF;
	END PROCESS leer;

	escribir : PROCESS (clk) IS
	BEGIN
		IF clk'event AND clk = '1' THEN
			IF cs = '1' AND memwrite = '1' THEN
				CASE tipoAcc IS
					WHEN "000" => -- una palabra
						mem00(TO_INTEGER(unsigned(dir(NUM_BITS_MEMORIA_DATOS - 1 + 2 DOWNTO 2)))) <= datain(7 DOWNTO 0);
						mem01(TO_INTEGER(unsigned(dir(NUM_BITS_MEMORIA_DATOS - 1 + 2 DOWNTO 2)))) <= datain(15 DOWNTO 8);
						mem10(TO_INTEGER(unsigned(dir(NUM_BITS_MEMORIA_DATOS - 1 + 2 DOWNTO 2)))) <= datain(23 DOWNTO 16);
						mem11(TO_INTEGER(unsigned(dir(NUM_BITS_MEMORIA_DATOS - 1 + 2 DOWNTO 2)))) <= datain(31 DOWNTO 24);
					WHEN "001" | "011" => -- media palabra
						CASE dir(1 DOWNTO 0) IS
							WHEN "00" =>
								mem00(TO_INTEGER(unsigned(dir(NUM_BITS_MEMORIA_DATOS - 1 + 2 DOWNTO 2)))) <= datain(7 DOWNTO 0);
								mem01(TO_INTEGER(unsigned(dir(NUM_BITS_MEMORIA_DATOS - 1 + 2 DOWNTO 2)))) <= datain(15 DOWNTO 8);
							WHEN "10" =>
								mem10(TO_INTEGER(unsigned(dir(NUM_BITS_MEMORIA_DATOS - 1 + 2 DOWNTO 2)))) <= datain(7 DOWNTO 0);
								mem11(TO_INTEGER(unsigned(dir(NUM_BITS_MEMORIA_DATOS - 1 + 2 DOWNTO 2)))) <= datain(15 DOWNTO 8);
							WHEN OTHERS =>
						END CASE;
					WHEN "010" | "100" => -- un byte
						CASE dir(1 DOWNTO 0) IS
							WHEN "00" =>
								mem00(TO_INTEGER(unsigned(dir(NUM_BITS_MEMORIA_DATOS - 1 + 2 DOWNTO 2)))) <= datain(7 DOWNTO 0);
							WHEN "01" =>
								mem01(TO_INTEGER(unsigned(dir(NUM_BITS_MEMORIA_DATOS - 1 + 2 DOWNTO 2)))) <= datain(7 DOWNTO 0);
							WHEN "10" =>
								mem10(TO_INTEGER(unsigned(dir(NUM_BITS_MEMORIA_DATOS - 1 + 2 DOWNTO 2)))) <= datain(7 DOWNTO 0);
							WHEN "11" =>
								mem11(TO_INTEGER(unsigned(dir(NUM_BITS_MEMORIA_DATOS - 1 + 2 DOWNTO 2)))) <= datain(7 DOWNTO 0);
							WHEN OTHERS =>
						END CASE;
					WHEN OTHERS =>
				END CASE;
			END IF;
		END IF;
	END PROCESS escribir;
END Behavioral;