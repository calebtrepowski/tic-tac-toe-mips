----------------------------------------------------------------------------------
-- Company: Universidad Catolica
-- Engineer: Vicente Gonzalez
-- 
-- Create Date:    14:36:22 06/14/2017 
-- Design Name: 
-- Module Name:    lcd - Behavioral 
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

ENTITY lcd IS
	PORT (-- Interfaz con el MIPS
		dataOut : IN STD_LOGIC_VECTOR (8 DOWNTO 0);
		memWrite : IN STD_LOGIC;
		cs : IN STD_LOGIC;
		clk : IN STD_LOGIC;
		reset : IN STD_LOGIC;
		-- Interfaz con el LCD
		E : OUT STD_LOGIC;
		RS : OUT STD_LOGIC;
		RW : OUT STD_LOGIC;
		DB : OUT STD_LOGIC_VECTOR (7 DOWNTO 0));
END lcd;

ARCHITECTURE Behavioral OF lcd IS

	-- senhales internas para interconectar modulos
	--signal DBTmp : STD_LOGIC_VECTOR(9 downto 0);

	--signal dataInTmp : STD_LOGIC_VECTOR(8 downto 0) := "000000000";

	SIGNAL enableWrite : STD_LOGIC := '0';
	SIGNAL dataOutWrite : STD_LOGIC := '0';

	SIGNAL enableWrite_i : STD_LOGIC := '0';
	SIGNAL E_i : STD_LOGIC := '0';

	TYPE state_type IS (EsperaCS, EsperaAntesE1, EsperaAntesE2, ActivaE, EsperaE1,
		EsperaE2, EsperaE3, EsperaE4, EsperaE5, EsperaE6, EsperaE7,
		EsperaE8, EsperaE9, EsperaE10, EsperaE11, EsperaFinal);
	SIGNAL state, next_state : state_type;

BEGIN

	dataOutWrite <= '1' WHEN memWrite = '1' AND CS = '1' AND enableWrite = '1' ELSE
		'0';

	regDataOut : PROCESS (clk)
	BEGIN
		IF (clk'event AND clk = '1') THEN
			IF (dataOutWrite = '1') THEN
				DB <= dataOut(7 DOWNTO 0);
				RS <= dataOut(8);
			END IF;
		END IF;
	END PROCESS;

	-- solo se puede escribir en el LCD
	RW <= '0';

	--------------------------------------------------
	-- Secuencial de control
	--------------------------------------------------
	control : PROCESS (clk)
	BEGIN
		IF (clk'event AND clk = '1') THEN
			IF (reset = '1') THEN
				state <= EsperaCS;
				-- Salidas
				enableWrite <= '1';
				E <= '0';
			ELSE
				state <= next_state;

				enableWrite <= enableWrite_i;
				E <= E_i;
			END IF;
		END IF;
	END PROCESS;

	--MOORE State-Machine - Outputs based on state only
	CONTROL_OUTPUT_DECODE : PROCESS (state)
	BEGIN
		--insert statements to decode internal output signals
		--below is simple example
		IF state = EsperaCS THEN
			-- CS = 0, no hace nada, permite escritura
			enableWrite_i <= '1';
			E_i <= '0';
		ELSIF state = EsperaAntesE1 THEN
			-- el MIPS escribio un valor que se debe enviar al LCD, y ya no puede volver a escribir
			-- esperamos un ciclo de dos
			enableWrite_i <= '1'; -- el clock de este dispositivo es el doble del MIPS.
			E_i <= '0';
		ELSIF state = EsperaAntesE2 THEN
			-- esperamos dos de dos ciclos
			enableWrite_i <= '0';
			E_i <= '0';
		ELSIF state = ActivaE THEN
			-- activa E
			enableWrite_i <= '0';
			E_i <= '1';
		ELSIF state = EsperaE1 THEN
			-- esperamos uno de doce ciclos
			enableWrite_i <= '0';
			E_i <= '1';
		ELSIF state = EsperaE2 THEN
			enableWrite_i <= '0';
			E_i <= '1';
		ELSIF state = EsperaE3 THEN
			enableWrite_i <= '0';
			E_i <= '1';
		ELSIF state = EsperaE4 THEN
			enableWrite_i <= '0';
			E_i <= '1';
		ELSIF state = EsperaE5 THEN
			enableWrite_i <= '0';
			E_i <= '1';
		ELSIF state = EsperaE6 THEN
			enableWrite_i <= '0';
			E_i <= '1';
		ELSIF state = EsperaE7 THEN
			enableWrite_i <= '0';
			E_i <= '1';
		ELSIF state = EsperaE8 THEN
			enableWrite_i <= '0';
			E_i <= '1';
		ELSIF state = EsperaE9 THEN
			enableWrite_i <= '0';
			E_i <= '1';
		ELSIF state = EsperaE10 THEN
			enableWrite_i <= '0';
			E_i <= '1';
		ELSIF state = EsperaE11 THEN
			-- se escribe dataIn
			enableWrite_i <= '0';
			E_i <= '1';
		ELSIF state = EsperaFinal THEN
			-- desactiva E
			enableWrite_i <= '0';
			E_i <= '0';
		END IF;
	END PROCESS;

	CONTROL_NEXT_STATE_DECODE : PROCESS (state, memWrite, CS)
	BEGIN
		--declare default state for next_state to avoid latches
		next_state <= state; --default is to stay in current state
		--insert statements to decode next_state
		--below is a simple example
		CASE (state) IS
			WHEN EsperaCS =>
				IF CS = '1' AND memWrite = '1' THEN
					next_state <= EsperaAntesE1;
				ELSE
					next_state <= EsperaCS;
				END IF;
			WHEN EsperaAntesE1 =>
				next_state <= EsperaAntesE2;
			WHEN EsperaAntesE2 =>
				next_state <= ActivaE;
			WHEN ActivaE =>
				next_state <= EsperaE1;
			WHEN EsperaE1 =>
				next_state <= EsperaE2;
			WHEN EsperaE2 =>
				next_state <= EsperaE3;
			WHEN EsperaE3 =>
				next_state <= EsperaE4;
			WHEN EsperaE4 =>
				next_state <= EsperaE5;
			WHEN EsperaE5 =>
				next_state <= EsperaE6;
			WHEN EsperaE6 =>
				next_state <= EsperaE7;
			WHEN EsperaE7 =>
				next_state <= EsperaE8;
			WHEN EsperaE8 =>
				next_state <= EsperaE9;
			WHEN EsperaE9 =>
				next_state <= EsperaE10;
			WHEN EsperaE10 =>
				next_state <= EsperaE11;
			WHEN EsperaE11 =>
				next_state <= EsperaFinal;
			WHEN EsperaFinal =>
				next_state <= EsperaCS;
			WHEN OTHERS =>
				next_state <= EsperaCS;
		END CASE;
	END PROCESS;

END Behavioral;