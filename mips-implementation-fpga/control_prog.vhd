----------------------------------------------------------------------------------
-- Company: Universidad Catolica
-- Engineer: Vicente Gonzalez
-- 
-- Create Date:    16:27:29 03/25/2020 
-- Design Name: 
-- Module Name:    control - Behavioral 
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

USE work.general.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY control_prog IS
	PORT (-- Interfaz con la Memoria de Instrucciones del MIPS y el MIPS en general
		DataDeMI : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		DataAMI : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		DirMI : OUT STD_LOGIC_VECTOR (NUM_BITS_MEMORIA_INSTRUCCIONES - 1 DOWNTO 0);
		writeMI : OUT STD_LOGIC;
		rstMIPS : OUT STD_LOGIC;
		-- Interfaz con el PSOC y el UART
		Atn : IN STD_LOGIC;
		Enviado : IN STD_LOGIC;
		TxData : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		ReadyTx : OUT STD_LOGIC;
		RxData : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		ReadyRx : IN STD_LOGIC;
		ResetTx : OUT STD_LOGIC;
		ResetRx : OUT STD_LOGIC;
		-- Senhales generales
		clk : IN STD_LOGIC);
END control_prog;

ARCHITECTURE Behavioral OF control_prog IS
	-- Estados de la maquina de estados del control
	--- Espera comando
	TYPE state_type IS (st1_esperaAtn0, st2_esperaAtn1, st3_esperaComando,
		--- Comando C
		st4_C_enviaTam1, st5_C_esperaEnviaTam1, st6_C_enviaTam2, st7_C_esperaEnviaTam2,
		--- Comando P
		st8_P_esperaTam1, st9_P_esperaTam2, st10_P_recibeDatos, st11_P_escribeMI, st12_P_enviaRespC,
		st13_P_esperaEnviaRespC,
		--- Comando V
		st14_V_esperaTam1, st15_V_esperaTam2, st16_V_recibeDatos, st17_V_verificaMI, st18_V_recibeResto,
		st19_V_enviaRespE, st20_V_esperaEnviaRespE, st21_V_enviaRespC, st22_V_esperaEnviaRespC);
	-- FF de la variable de estados y senhal para el estado siguiente							  
	SIGNAL state, next_state : state_type;

	-- registro que almacena la cantidad de datos recibidos por el UART (16 its)
	SIGNAL cantMSBLSB : STD_LOGIC_VECTOR (15 DOWNTO 0);
	SIGNAL nextCantMSB, nextCantLSB : STD_LOGIC_VECTOR (7 DOWNTO 0);
	SIGNAL decCantMSBLSB, cargaCantMSB, cargaCantLSB : STD_LOGIC;
	-- registro que almacena la palabra recibida por el UART de cara al MIPS (32 bits)
	-- se accede por bytes en funcion de contBytes
	TYPE pal32bits IS ARRAY (3 DOWNTO 0) OF STD_LOGIC_VECTOR (7 DOWNTO 0);
	SIGNAL pal : pal32bits; -- para acceder pal(3), pal(2)... Para convertir std_logic_vector a entero to_integer(unsgined())
	SIGNAL nextPal : pal32bits;
	SIGNAL cargaPal : STD_LOGIC;
	-- registro que cuenta los bytes de la palabra anterior ( 2 bits)
	SIGNAL contBytes : STD_LOGIC_VECTOR (1 DOWNTO 0);
	SIGNAL rstContBytes, incContBytes : STD_LOGIC;
	-- registro que almacena la posicion de la memoria de instrucciones del MIPS que sera escrito
	SIGNAL dirMIreg : STD_LOGIC_VECTOR (NUM_BITS_MEMORIA_INSTRUCCIONES - 1 DOWNTO 0);
	SIGNAL rstDirMI, incDirMI : STD_LOGIC;
	--	signal numeroPosicionesMI : std_logic_vector (15 downto 0) := X"00FF";	-- Cantidad de posiciones (palabras) de la memoria del MIPS
	CONSTANT numeroPosicionesMI : STD_LOGIC_VECTOR (15 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(2 ** NUM_BITS_MEMORIA_INSTRUCCIONES, 16)); -- Cantidad de posiciones (palabras) de la memoria del MIPS
BEGIN
	-- Camino de los datos
	contadorBytes : PROCESS (rstContBytes, incContBytes, clk)
	BEGIN
		IF clk'event AND clk = '1' THEN
			IF rstContBytes = '1' THEN
				contBytes <= "00";
			ELSIF incContBytes = '1' THEN
				contBytes <= STD_LOGIC_VECTOR(unsigned(contBytes) + 1);
			END IF;
		END IF;
	END PROCESS;

	contadorDirMI : PROCESS (rstDirMI, incDirMI, clk)
	BEGIN
		IF clk'event AND clk = '1' THEN
			IF rstDirMI = '1' THEN
				dirMIreg <= (OTHERS => '0');
			ELSIF incDirMI = '1' THEN
				dirMIreg <= STD_LOGIC_VECTOR(unsigned(dirMIreg) + 1);
			END IF;
		END IF;
	END PROCESS;
	-- conectamos dirMIreg a la salida de direcciones
	DirMI <= dirMIreg;

	cantidadMSBLSB : PROCESS (decCantMSBLSB, cargaCantMSB, cargaCantLSB, clk)
	BEGIN
		IF clk'event AND clk = '1' THEN
			IF decCantMSBLSB = '1' THEN
				cantMSBLSB <= STD_LOGIC_VECTOR(unsigned(cantMSBLSB) - 1);
			ELSIF cargaCantMSB = '1' THEN
				cantMSBLSB <= nextCantMSB & cantMSBLSB(7 DOWNTO 0);
			ELSIF cargaCantLSB = '1' THEN
				cantMSBLSB <= cantMSBLSB(15 DOWNTO 8) & nextCantLSB;
			END IF;
		END IF;
	END PROCESS;

	palabraASerEscritaEnMI : PROCESS (cargaPal, clk)
	BEGIN
		IF clk'event AND clk = '1' THEN
			IF cargaPal = '1' THEN
				pal <= nextPal;
			END IF;
		END IF;
	END PROCESS;
	dataAMI <= (pal(0) & pal(1) & pal(2) & pal(3));

	-- Fin Camino de los datos

	-- Control
	estados : PROCESS (next_state, clk)
	BEGIN
		IF clk'event AND clk = '1' THEN
			state <= next_state;
		END IF;
	END PROCESS;

	-- circuito de salida Mealy y Moore
	OUTPUT_DECODE : PROCESS (state, atn, readyRx, rxData, pal, cantMSBLSB)
	BEGIN
		-- salidas por defecto para evitar latches
		resetTx <= '0'; -- no reset del UART TX
		readyTx <= '0'; -- No se transmite por el UART TX
		txData <= X"00"; -- Dato a transmitir por UART TX es 00000000
		resetRx <= '0'; -- no reset del UART RX
		rstMIPS <= '0'; -- no hacemos reset al MIPS
		writeMI <= '0'; -- no escribimos en la MI del MIPS
		rstDirMI <= '0'; -- no reset a Direccion de MI del MIPS
		incDirMI <= '0'; -- no incrementa la direccion del MI del MIPS
		rstContBytes <= '0'; -- no reset a ContBytes 
		incContBytes <= '0'; -- no se incrementa ContBytes 
		cargaCantLSB <= '0'; -- no cargamos CantMSBLSB
		cargaCantMSB <= '0';
		decCantMSBLSB <= '0'; -- no decrementamos CantMSBLSB
		-- CantMSBLSB conserva su valor por defecto
		nextCantMSB <= CantMSBLSB(15 DOWNTO 8);
		nextCantLSB <= CantMSBLSB(7 DOWNTO 0);
		-- pal conserva su valor por defecto
		nextPal(0) <= pal(0);
		nextPal(1) <= pal(1);
		nextPal(2) <= pal(2);
		nextPal(3) <= pal(3);

		CASE (state) IS
				---------- Espera Comando
			WHEN st1_esperaAtn0 =>
				resetTx <= '1'; -- reset al UART
				resetRx <= '1';
				rstDirMI <= '1'; -- reset a Direccion de MI del MIPS
			WHEN st2_esperaAtn1 =>
				resetTx <= '1'; -- reset al UART
				resetRx <= '1';
				IF atn = '1' THEN
					resetTx <= '0'; -- esperamos recibir y transmitir datos
					resetRx <= '0';
				END IF;
			WHEN st3_esperaComando =>
				-- no hay salidas asociadas a este estado

				--------- Comando C
			WHEN st4_C_enviaTam1 =>
				txData <= numeroPosicionesMI(15 DOWNTO 8); -- enviamos MSB del tamanho
				readyTx <= '1';
			WHEN st5_C_esperaEnviaTam1 => -- no hace nada, espera envio
				txData <= numeroPosicionesMI(15 DOWNTO 8);
			WHEN st6_C_enviaTam2 =>
				txData <= numeroPosicionesMI(7 DOWNTO 0); -- enviamos LSB del tamanho
				readyTx <= '1';
			WHEN st7_C_esperaEnviaTam2 => -- no hace nada, espera envio
				txData <= numeroPosicionesMI(7 DOWNTO 0);

				--------- Comando P
			WHEN st8_P_esperaTam1 =>
				IF readyRx = '1' THEN
					cargaCantMSB <= '1';
					nextCantMSB <= rxData;
				END IF;
			WHEN st9_P_esperaTam2 =>
				IF readyRx = '1' THEN
					cargaCantLSB <= '1';
					nextCantLSB <= rxData;
					rstDirMI <= '1'; -- Direccion de MI del MIPS es 0
					rstContBytes <= '1'; -- Contador de bytes recibidos es 0
				END IF;
			WHEN st10_P_recibeDatos =>
				rstMIPS <= '1';
				IF readyRx = '1' THEN
					cargaPal <= '1';
					nextPal(to_integer(unsigned(contBytes))) <= rxData;
					incContBytes <= '1';
					decCantMSBLSB <= '1';
				END IF;
			WHEN st11_P_escribeMI =>
				writeMI <= '1';
				incDirMI <= '1';
				rstMIPS <= '1';
			WHEN st12_P_enviaRespC =>
				txData <= STD_LOGIC_VECTOR(to_unsigned(CHARACTER'pos('c'), 8));
				readyTx <= '1'; -- transmitimos respuesta
			WHEN st13_P_esperaEnviaRespC =>
				-- no hay salidas asociadas a este estado

				--------- Comando V
			WHEN st14_V_esperaTam1 =>
				IF readyRx = '1' THEN
					cargaCantMSB <= '1';
					nextCantMSB <= rxData;
				END IF;
			WHEN st15_V_esperaTam2 =>
				IF readyRx = '1' THEN
					cargaCantLSB <= '1';
					nextCantLSB <= rxData;
					rstDirMI <= '1'; -- Direccion de MI del MIPS es 0
					rstContBytes <= '1'; -- Contador de bytes recibidos es 0
				END IF;
			WHEN st16_V_recibeDatos =>
				IF readyRx = '1' THEN
					cargaPal <= '1';
					nextPal(to_integer(unsigned(contBytes))) <= rxData;
					incContBytes <= '1';
					decCantMSBLSB <= '1';
				END IF;
			WHEN st17_V_verificaMI =>
				incDirMI <= '1';
			WHEN st18_V_recibeResto =>
				IF readyRx = '1' THEN
					decCantMSBLSB <= '1';
				END IF;
			WHEN st19_V_enviaRespE =>
				txData <= STD_LOGIC_VECTOR(to_unsigned(CHARACTER'pos('e'), 8));
				readyTx <= '1'; -- transmitimos respuesta
			WHEN st20_V_esperaEnviaRespE =>
			WHEN st21_V_enviaRespC =>
				txData <= STD_LOGIC_VECTOR(to_unsigned(CHARACTER'pos('c'), 8));
				readyTx <= '1'; -- transmitimos respuesta
			WHEN st22_V_esperaEnviaRespC =>
				-- no hay salidas asociadas a este estado
		END CASE;
	END PROCESS;

	-- circuito del estado siguiente
	NEXT_STATE_DECODE : PROCESS (state, DataDeMI, atn, enviado, readyRx, rxData, contBytes, cantMSBLSB, pal)
	BEGIN
		next_state <= state; -- por defecto en el mismo estado

		CASE (state) IS
				---------- Espera Comando
			WHEN st1_esperaAtn0 =>
				IF atn = '0' THEN
					next_state <= st2_esperaAtn1;
				END IF;
			WHEN st2_esperaAtn1 =>
				IF atn = '1' THEN
					next_state <= st3_esperaComando;
				END IF;
			WHEN st3_esperaComando =>
				IF atn = '0' THEN
					next_state <= st2_esperaAtn1; -- reiniciamos esta maquina
				ELSIF readyRx = '1' THEN
					IF rxData = STD_LOGIC_VECTOR(to_unsigned(CHARACTER'pos('C'), 8)) THEN
						next_state <= st4_C_enviaTam1;
					ELSIF rxData = STD_LOGIC_VECTOR(to_unsigned(CHARACTER'pos('P'), 8)) THEN
						next_state <= st8_P_esperaTam1;
					ELSIF rxData = STD_LOGIC_VECTOR(to_unsigned(CHARACTER'pos('V'), 8)) THEN
						next_state <= st14_V_esperaTam1;
					END IF;
				END IF;
				--------- Comando C
			WHEN st4_C_enviaTam1 =>
				IF atn = '0' THEN
					next_state <= st2_esperaAtn1; -- reiniciamos esta maquina
				ELSE
					next_state <= st5_C_esperaEnviaTam1;
				END IF;
			WHEN st5_C_esperaEnviaTam1 =>
				IF atn = '0' THEN
					next_state <= st2_esperaAtn1; -- reiniciamos esta maquina
				ELSIF enviado = '1' THEN
					next_state <= st6_C_enviaTam2;
				END IF;
			WHEN st6_C_enviaTam2 =>
				IF atn = '0' THEN
					next_state <= st2_esperaAtn1; -- reiniciamos esta maquina
				ELSE
					next_state <= st7_C_esperaEnviaTam2;
				END IF;
			WHEN st7_C_esperaEnviaTam2 =>
				IF atn = '0' THEN
					next_state <= st2_esperaAtn1; -- reiniciamos esta maquina
				ELSIF enviado = '1' THEN
					next_state <= st1_esperaAtn0; -- volvemos al estado inicial
				END IF;
				--------- Comando P
			WHEN st8_P_esperaTam1 =>
				IF atn = '0' THEN
					next_state <= st2_esperaAtn1; -- reiniciamos esta maquina
				ELSIF readyRx = '1' THEN
					next_state <= st9_P_esperaTam2;
				END IF;
			WHEN st9_P_esperaTam2 =>
				IF atn = '0' THEN
					next_state <= st2_esperaAtn1; -- reiniciamos esta maquina
				ELSIF readyRx = '1' THEN
					next_state <= st10_P_recibeDatos;
				END IF;
			WHEN st10_P_recibeDatos =>
				IF atn = '0' THEN
					next_state <= st2_esperaAtn1; -- reiniciamos esta maquina
				ELSIF readyRx = '1' AND contBytes = "11" THEN
					next_state <= st11_P_escribeMI; -- escribe en memoria
				END IF;
			WHEN st11_P_escribeMI =>
				IF cantMSBLSB = X"0000" THEN
					next_state <= st12_P_enviaRespC;
				ELSE
					next_state <= st10_P_recibeDatos;
				END IF;
			WHEN st12_P_enviaRespC =>
				next_state <= st13_P_esperaEnviaRespC;
			WHEN st13_P_esperaEnviaRespC =>
				IF atn = '0' THEN
					next_state <= st2_esperaAtn1; -- reiniciamos esta maquina
				ELSIF enviado = '1' THEN
					next_state <= st1_esperaAtn0;
				END IF;
				--------- Comando V
			WHEN st14_V_esperaTam1 =>
				IF atn = '0' THEN
					next_state <= st2_esperaAtn1; -- reiniciamos esta maquina
				ELSIF readyRx = '1' THEN
					next_state <= st15_V_esperaTam2;
				END IF;
			WHEN st15_V_esperaTam2 =>
				IF atn = '0' THEN
					next_state <= st2_esperaAtn1; -- reiniciamos esta maquina
				ELSIF readyRx = '1' THEN
					next_state <= st16_V_recibeDatos;
				END IF;
			WHEN st16_V_recibeDatos =>
				IF atn = '0' THEN
					next_state <= st2_esperaAtn1; -- reiniciamos esta maquina
				ELSIF readyRx = '1' AND contBytes = "11" THEN
					next_state <= st17_V_verificaMI;
				END IF;
			WHEN st17_V_verificaMI =>
				IF dataDeMI /= (pal(0) & pal(1) & pal(2) & pal(3)) THEN
					IF cantMSBLSB = X"0000" THEN
						next_state <= st19_V_enviaRespE;
					ELSE
						next_state <= st18_V_recibeResto;
					END IF;
				ELSIF cantMSBLSB = X"0000" THEN
					next_state <= st21_V_enviaRespC;
				ELSE
					next_state <= st16_V_recibeDatos;
				END IF;
			WHEN st18_V_recibeResto =>
				IF atn = '0' THEN
					next_state <= st2_esperaAtn1; -- reiniciamos esta maquina
				ELSIF readyRx = '1' AND cantMSBLSB = X"0001" THEN
					next_state <= st19_V_enviaRespE;
				END IF;
			WHEN st19_V_enviaRespE =>
				next_state <= st20_V_esperaEnviaRespE;
			WHEN st20_V_esperaEnviaRespE =>
				IF atn = '0' THEN
					next_state <= st2_esperaAtn1; -- reiniciamos esta maquina
				ELSIF enviado = '1' THEN
					next_state <= st1_esperaAtn0;
				END IF;
			WHEN st21_V_enviaRespC =>
				next_state <= st22_V_esperaEnviaRespC;
			WHEN st22_V_esperaEnviaRespC =>
				IF atn = '0' THEN
					next_state <= st2_esperaAtn1; -- reiniciamos esta maquina
				ELSIF enviado = '1' THEN
					next_state <= st1_esperaAtn0;
				END IF;

				--------- Estado por defecto
			WHEN OTHERS =>
				next_state <= st1_esperaAtn0;
		END CASE;
	END PROCESS;

END Behavioral;