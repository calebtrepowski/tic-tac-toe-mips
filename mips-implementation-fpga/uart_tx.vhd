----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:35:17 03/17/2020 
-- Design Name: 
-- Module Name:    uart_tx - Behavioral 
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

ENTITY uart_tx IS
	PORT (
		clk : IN STD_LOGIC;
		resetTx : IN STD_LOGIC;
		txdata : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		readyTx : IN STD_LOGIC;
		tx : OUT STD_LOGIC;
		enviado : OUT STD_LOGIC);
END uart_tx;

ARCHITECTURE Behavioral OF uart_tx IS
	-- numero de ciclos a 25 MHz para alcanzar medio bit y un bit a 19200 bps
	CONSTANT FULL_BIT_CONST : STD_LOGIC_VECTOR (10 DOWNTO 0) := "10100010110"; --X"516"

	SIGNAL s_reg : STD_LOGIC_VECTOR (7 DOWNTO 0); -- registro de corrimiento
	SIGNAL corr, carga_s_reg : STD_LOGIC; -- control del registro de corrimiento
	SIGNAL cont_ciclos : STD_LOGIC_VECTOR (10 DOWNTO 0); -- contador de ciclos de reloj
	SIGNAL hab_cont_ciclos, cera_cont_ciclos : STD_LOGIC; -- controles contador ciclos de reloj
	SIGNAL cont_bits : STD_LOGIC_VECTOR (3 DOWNTO 0); -- contador de bits recibidos
	SIGNAL hab_cont_bits, cera_cont_bits : STD_LOGIC; -- controles contador de bits recibidos
	-- maquina de estados de control
	TYPE state_type IS (st1_idle, st2_start, st3_datos, st4_stop);
	SIGNAL state, next_state : state_type;
	-- salida de los comparadores
	SIGNAL full_bit, ocho_bits_rec : STD_LOGIC;

BEGIN
	-----------------------------------------------------------
	-- Camino de los datos
	-----------------------------------------------------------
	-- registro de corrimiento
	shift_register : PROCESS (clk, corr, carga_s_reg)
	BEGIN
		IF clk'event AND clk = '1' THEN
			IF carga_s_reg = '1' THEN
				s_reg <= txdata;
			ELSIF corr = '1' THEN
				s_reg <= '1' & s_reg(7 DOWNTO 1);
			END IF;
		END IF;
	END PROCESS;

	-- contador de ciclos de reloj para bits por segundo
	contador_ciclos : PROCESS (clk, hab_cont_ciclos, cera_cont_ciclos)
	BEGIN
		IF clk'event AND clk = '1' THEN
			IF cera_cont_ciclos = '1' THEN
				cont_ciclos <= (OTHERS => '0');
			ELSIF hab_cont_ciclos = '1' THEN
				cont_ciclos <= STD_LOGIC_VECTOR(unsigned(cont_ciclos) + 1);
			END IF;
		END IF;
	END PROCESS;

	-- contador de ciclos de reloj bits recibidos
	contador_bits : PROCESS (clk, hab_cont_bits, cera_cont_bits)
	BEGIN
		IF clk'event AND clk = '1' THEN
			IF cera_cont_bits = '1' THEN
				cont_bits <= (OTHERS => '0');
			ELSIF hab_cont_bits = '1' THEN
				cont_bits <= STD_LOGIC_VECTOR(unsigned(cont_bits) + 1);
			END IF;
		END IF;
	END PROCESS;

	-----------------------------------------------------------
	-- Fin Camino de los datos
	-----------------------------------------------------------

	-----------------------------------------------------------
	-- Control
	-----------------------------------------------------------

	SYNC_PROC : PROCESS (clk, resetTx)
	BEGIN
		IF (clk'event AND clk = '1') THEN
			IF (resetTx = '1') THEN
				state <= st1_idle;
			ELSE
				state <= next_state;
			END IF;
		END IF;
	END PROCESS;

	--MEALY State-Machine - Outputs based on state and inputs
	OUTPUT_DECODE : PROCESS (state, full_bit, ocho_bits_rec, readyTx, s_reg)
	BEGIN
		-- por defecto ceramos los contadores y no contamos
		hab_cont_bits <= '0';
		cera_cont_bits <= '1';
		hab_cont_ciclos <= '0';
		cera_cont_ciclos <= '1';
		corr <= '0';
		carga_s_reg <= '0';
		tx <= '1';
		enviado <= '0';

		CASE (state) IS
			WHEN st1_idle =>
				cera_cont_bits <= '1';
				cera_cont_ciclos <= '1';
				tx <= '1';
				IF readyTx = '1' THEN
					carga_s_reg <= '1';
				END IF;
			WHEN st2_start =>
				-- contamos ciclos
				hab_cont_ciclos <= '1';
				cera_cont_ciclos <= '0';
				tx <= '0';
				IF full_bit = '1' THEN
					-- ceramos ambos contadores
					cera_cont_bits <= '1';
					cera_cont_ciclos <= '1';
				END IF;
			WHEN st3_datos =>
				hab_cont_ciclos <= '1';
				cera_cont_ciclos <= '0';
				cera_cont_bits <= '0';
				tx <= s_reg(0);
				IF ocho_bits_rec = '0' AND full_bit = '1' THEN
					-- ceramos contador de ciclos y cuenta contador de bits
					cera_cont_bits <= '0';
					hab_cont_bits <= '1';
					cera_cont_ciclos <= '1';
					corr <= '1';
				END IF;
			WHEN st4_stop =>
				-- contamos ciclos
				hab_cont_ciclos <= '1';
				cera_cont_ciclos <= '0';
				tx <= '1';
				IF full_bit = '1' THEN
					-- indicamos que se envio un byte
					enviado <= '1';
				END IF;
		END CASE;
	END PROCESS;

	NEXT_STATE_DECODE : PROCESS (state, full_bit, ocho_bits_rec, readyTx)
	BEGIN
		--declare default state for next_state to avoid latches
		next_state <= state; --default is to stay in current state
		--insert statements to decode next_state
		--below is a simple example
		CASE (state) IS
			WHEN st1_idle =>
				IF readyTx = '1' THEN
					next_state <= st2_start;
				END IF;
			WHEN st2_start =>
				IF full_bit = '1' THEN
					next_state <= st3_datos;
				END IF;
			WHEN st3_datos =>
				IF ocho_bits_rec = '1' THEN
					next_state <= st4_stop;
				END IF;
			WHEN st4_stop =>
				IF full_bit = '1' THEN
					next_state <= st1_idle;
				END IF;
			WHEN OTHERS =>
				next_state <= st1_idle;
		END CASE;
	END PROCESS;

	-- comparadores
	full_bit <= '1' WHEN cont_ciclos = FULL_BIT_CONST ELSE
		'0';
	ocho_bits_rec <= '1' WHEN cont_bits = "1000" ELSE
		'0';

END Behavioral;