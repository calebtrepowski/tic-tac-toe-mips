----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:56:11 04/04/2020 
-- Design Name: 
-- Module Name:    prog - Behavioral 
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

USE work.general.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY prog IS
	PORT (
		dataDeMI : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		dataAMI : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		dirMI : OUT STD_LOGIC_VECTOR (NUM_BITS_MEMORIA_INSTRUCCIONES - 1 DOWNTO 0);
		writeMI : OUT STD_LOGIC;
		rstMIPS : OUT STD_LOGIC;
		-- lineas de control
		clk : IN STD_LOGIC;
		-- puerto serial
		rx : IN STD_LOGIC;
		tx : OUT STD_LOGIC;
		Atn : IN STD_LOGIC);
END prog;

ARCHITECTURE Behavioral OF prog IS
	COMPONENT control_prog IS
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
	END COMPONENT;
	COMPONENT uart_rx IS
		PORT (
			rx : IN STD_LOGIC;
			clk : IN STD_LOGIC;
			resetRx : IN STD_LOGIC;
			rxdata : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
			readyRx : OUT STD_LOGIC);
	END COMPONENT;
	COMPONENT uart_tx IS
		PORT (
			clk : IN STD_LOGIC;
			resetTx : IN STD_LOGIC;
			txdata : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			readyTx : IN STD_LOGIC;
			tx : OUT STD_LOGIC;
			enviado : OUT STD_LOGIC);
	END COMPONENT;

	-- senhales de interconexion
	--		signal DataDeMI : STD_LOGIC_VECTOR (31 downto 0);
	--		signal DataAMI : STD_LOGIC_VECTOR (31 downto 0);
	--		signal DirMI : STD_LOGIC_VECTOR (NUM_BITS_MEMORIA_INSTRUCCIONES-1 downto 0);
	--		signal writeMI : std_logic;
	--		signal rstMIPS : std_logic;
	-- Interfaz con el PSOC y el UART
	--		signal Atn : std_logic;
	SIGNAL Enviado : STD_LOGIC;
	SIGNAL TxData : STD_LOGIC_VECTOR (7 DOWNTO 0);
	SIGNAL ReadyTx : STD_LOGIC;
	SIGNAL RxData : STD_LOGIC_VECTOR (7 DOWNTO 0);
	SIGNAL ReadyRx : STD_LOGIC;
	SIGNAL ResetTx : STD_LOGIC;
	SIGNAL ResetRx : STD_LOGIC;
	-- Senhales generales
	--		signal Reset : std_logic;
	--      signal clk : std_logic;

BEGIN
	Inst_control_prog : control_prog PORT MAP(
		DataDeMI => DataDeMI,
		DataAMI => DataAMI,
		DirMI => DirMI,
		writeMI => writeMI,
		rstMIPS => rstMIPS,
		-- Interfaz con el PSOC y el UART
		Atn => Atn,
		Enviado => Enviado,
		TxData => TxData,
		ReadyTx => ReadyTx,
		RxData => RxData,
		ReadyRx => ReadyRx,
		ResetTx => ResetTx,
		ResetRx => ResetRx,
		-- Senhales generales
		clk => clk
	);

	inst_uart_tx : uart_tx PORT MAP(
		clk => clk,
		resetTx => resetTx,
		txdata => txdata,
		readyTx => readyTx,
		tx => tx,
		enviado => enviado
	);

	inst_uart_rx : uart_rx PORT MAP(
		rx => rx,
		clk => clk,
		resetRx => resetRx,
		rxdata => rxdata,
		readyRx => readyRx
	);

END Behavioral;