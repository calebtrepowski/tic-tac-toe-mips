----------------------------------------------------------------------------------
-- Company: Universidad Catolica
-- Engineer: Vicente Gonzalez
-- 
-- Create Date:    16:59:32 04/08/2010 
-- Design Name: 
-- Module Name:    alu - Behavioral 
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
--use IEEE.numeric_std.all;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY alu IS
	PORT (-- entradas
		op1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		op2 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		control : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		shiftamt : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		-- salidas
		s : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		zero : OUT STD_LOGIC);
END alu;

ARCHITECTURE Behavioral OF alu IS
	COMPONENT alu_parcial
		PORT (
			op1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			op2 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			control : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			s : OUT STD_LOGIC_VECTOR (31 DOWNTO 0));
	END COMPONENT;

	COMPONENT barrel_shifter
		PORT (
			e : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			control : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
			op : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			s : OUT STD_LOGIC_VECTOR (31 DOWNTO 0));
	END COMPONENT;

	SIGNAL s_alu_parcial : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL s_barrel : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL s_mux : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL op_bshift : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL shift_amount : STD_LOGIC_VECTOR(4 DOWNTO 0);

BEGIN
	Inst_alu_parcial : alu_parcial PORT MAP(
		op1 => op1,
		op2 => op2,
		control => control,
		s => s_alu_parcial
	);

	Inst_barrel_shifter : barrel_shifter PORT MAP(
		e => op2,
		control => shift_amount,
		op => op_bshift, -- Que tipo de shift se hace
		s => s_barrel
	);

	-- decodificador de corrimiento derecha/izquierda
	op_bshift <= "00" WHEN control = "0101" OR control = "1001" ELSE --sll y sllv
		"01" WHEN control = "0110" OR control = "1000" ELSE --srl y srlv
		"10" WHEN control = "1010" OR control = "1011" ELSE --sra y srav
		"11";

	-- multiplexor de salida
	s_mux <= s_barrel WHEN control = "0101" OR control = "0110" OR control = "1000" OR
		control = "1001" OR control = "1010" OR control = "1011" ELSE
		s_alu_parcial;

	-- detector de cero
	zero <= '1' WHEN s_mux = X"00000000" ELSE
		'0';

	-- conectamos shift_amount a shift_amount de la instruccion para las operaciones de corrimiento constante
	-- o a los 5 bits menos significativos de RS si la instruccion es de corrimiento por registro
	shift_amount <= shiftamt WHEN control = "0101" OR control = "0110" OR control = "1010" ELSE
		op1(4 DOWNTO 0) WHEN control = "1000" OR control = "1001" OR control = "1011" ELSE
		"00000";

	-- conectamos la salida
	s <= s_mux;

END Behavioral;