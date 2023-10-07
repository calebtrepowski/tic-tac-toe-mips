----------------------------------------------------------------------------------
-- Company: Universidad Catolica
-- Engineer: Vicente Gonzalez
-- 
-- Create Date:    14:44:35 06/14/2017 
-- Design Name: 
-- Module Name:    md_io - Behavioral 
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

ENTITY md_io IS
	PORT (
		dir : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		datain : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		memwrite : IN STD_LOGIC;
		memread : IN STD_LOGIC;
		tipoAcc : IN STD_LOGIC_VECTOR (2 DOWNTO 0); --tipo de operacion a realizar, cargar bytes, half word y word
		clk : IN STD_LOGIC;
		clk50mhz : IN STD_LOGIC;
		reset : IN STD_LOGIC;
		north : IN STD_LOGIC;
		south : IN STD_LOGIC;
		sw : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		dataout : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		salida : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		--Dis_valor1    : in std_logic_vector(7 downto 0);
		anodo : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
		LCD_E : OUT STD_LOGIC;
		LCD_RS : OUT STD_LOGIC;
		LCD_RW : OUT STD_LOGIC;
		salida_LED : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
		LCD_DB : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END md_io;

ARCHITECTURE Behavioral OF md_io IS
	COMPONENT entrada
		PORT (
			north : IN STD_LOGIC;
			south : IN STD_LOGIC;
			sw : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			alMIPS : OUT STD_LOGIC_VECTOR (5 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT decodificador
		PORT (
			ent : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			csMem : OUT STD_LOGIC;
			cs_dis : OUT STD_LOGIC;
			csParPort : OUT STD_LOGIC;
			csLCD : OUT STD_LOGIC;
			csEntrada : OUT STD_LOGIC
		);
	END COMPONENT;

	COMPONENT md
		PORT (
			dir : STD_LOGIC_VECTOR (NUM_BITS_MEMORIA_DATOS - 1 + 2 DOWNTO 0);
			datain : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			cs : IN STD_LOGIC;
			memwrite : IN STD_LOGIC;
			memread : IN STD_LOGIC;
			tipoAcc : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
			clk : IN STD_LOGIC;
			dataout : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT salida_par
		PORT (
			sel : IN STD_LOGIC;
			write_cntl : IN STD_LOGIC;
			clk : IN STD_LOGIC;
			data : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			salida : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT lcd
		PORT (
			dataOut : IN STD_LOGIC_VECTOR (8 DOWNTO 0);
			memWrite : IN STD_LOGIC;
			cs : IN STD_LOGIC;
			clk : IN STD_LOGIC;
			reset : IN STD_LOGIC;
			E : OUT STD_LOGIC;
			RS : OUT STD_LOGIC;
			RW : OUT STD_LOGIC;
			DB : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT Display
		PORT (
			mclk : IN STD_LOGIC;
			sel_dis : IN STD_LOGIC;
			write_cntl : IN STD_LOGIC;
			valor1 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			anodo : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			--LED : OUT std_logic_vector(6 downto 0);
			salida_LED : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
		);
	END COMPONENT;

	-- Definimos senhales para interconexion interna en este modulo
	SIGNAL csMem : STD_LOGIC;
	SIGNAL csSalidaPar : STD_LOGIC;
	SIGNAL cs_dis : STD_LOGIC;
	SIGNAL csLCD : STD_LOGIC;
	SIGNAL csEntrada : STD_LOGIC;
	SIGNAL datosMem : STD_LOGIC_VECTOR (31 DOWNTO 0);
	SIGNAL datosEntrada : STD_LOGIC_VECTOR (5 DOWNTO 0);
	--signal anodo       : STD_LOGIC_VECTOR (2 downto 0);
	--signal LED         : STD_LOGIC_VECTOR (6 downto 0);

BEGIN

	-- Multiplexor de salida
	dataout <= datosMem WHEN csMem = '1' ELSE
		"00000000000000000000000000" & datosEntrada WHEN csEntrada = '1' ELSE
		(OTHERS => '0');

	Inst_entrada : entrada PORT MAP(
		north => north,
		south => south,
		sw => sw,
		alMIPS => datosEntrada
	);

	Inst_decodificador : decodificador PORT MAP(
		ent => dir(31 DOWNTO 0),
		csMem => csMem,
		cs_dis => cs_dis,
		csParPort => csSalidaPar,
		csLCD => csLCD,
		csEntrada => csEntrada
	);

	Inst_md : md PORT MAP(
		dir => dir(NUM_BITS_MEMORIA_DATOS - 1 + 2 DOWNTO 0),
		datain => datain,
		cs => csMem,
		memwrite => memwrite,
		memread => memread,
		tipoAcc => tipoAcc,
		clk => clk,
		dataout => datosMem
	);

	Inst_salida_par : salida_par PORT MAP(
		sel => csSalidaPar,
		write_cntl => memwrite,
		clk => clk,
		data => datain(7 DOWNTO 0),
		salida => salida
	);

	Inst_lcd : lcd PORT MAP(
		dataOut => datain(8 DOWNTO 0),
		memWrite => memwrite,
		cs => csLCD,
		clk => clk50mhz,
		reset => reset,
		E => LCD_E,
		RS => LCD_RS,
		RW => LCD_RW,
		DB => LCD_DB
	);
	Inst_Display : Display PORT MAP(
		mclk => clk,
		sel_dis => cs_dis,
		write_cntl => memwrite,
		valor1 => datain(7 DOWNTO 0),
		anodo => anodo,
		salida_LED => salida_LED
	);
END Behavioral;