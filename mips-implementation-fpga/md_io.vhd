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
		clk100mhz : IN STD_LOGIC;
		reset : IN STD_LOGIC;
		dataout : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		-- salida : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		HSYNC : OUT STD_LOGIC;
		VSYNC : OUT STD_LOGIC;
		RGB : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
		led : OUT STD_LOGIC_VECTOR(4 DOWNTO 0));
END md_io;

ARCHITECTURE Behavioral OF md_io IS

COMPONENT decodificador
		PORT (
			ent : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			csVGA : OUT STD_LOGIC;
			csMem : OUT STD_LOGIC;
			cs_dis : OUT STD_LOGIC;
			csParPort : OUT STD_LOGIC;
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

	COMPONENT convertidor_VGA
		PORT (
			clk : IN STD_LOGIC;
			CLK25 : IN STD_LOGIC;
			csvga : IN STD_LOGIC;
			dir : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			tipoAcc : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
			memwrite : IN STD_LOGIC;
			RST : IN STD_LOGIC;
			datain : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			HSYNC : OUT STD_LOGIC;
			VSYNC : OUT STD_LOGIC;
			RGB : OUT STD_LOGIC_VECTOR (2 DOWNTO 0)
		);
	END COMPONENT;

	-- Definimos senhales para interconexion interna en este modulo
	SIGNAL csMem : STD_LOGIC;
	SIGNAL csSalidaPar : STD_LOGIC;
	SIGNAL csVGA : STD_LOGIC;
	SIGNAL cs_dis : STD_LOGIC;
	SIGNAL csEntrada : STD_LOGIC;
	SIGNAL datosMem : STD_LOGIC_VECTOR (31 DOWNTO 0);
	SIGNAL datosEntrada : STD_LOGIC_VECTOR (5 DOWNTO 0);

BEGIN

	-- Multiplexor de salida
	dataout <= datosMem WHEN csMem = '1' ELSE
		"00000000000000000000000000" & datosEntrada WHEN csEntrada = '1' ELSE
		(OTHERS => '0');


	Inst_decodificador : decodificador PORT MAP(
		ent => dir(31 DOWNTO 0),
		csVGA => csVGA,
		csMem => csMem,
		cs_dis => cs_dis,
		csParPort => csSalidaPar,
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

	Inst_VGA : convertidor_VGA PORT MAP(
		clk => clk100mhz,
		CLK25 => clk,
		csvga => csVGA,
		dir => dir(15 DOWNTO 0),
		tipoAcc => tipoAcc,
		memwrite => memWrite,
		RST => reset,
		datain => datain,
		HSYNC => HSYNC,
		VSYNC => VSYNC,
		RGB => RGB
	);
END Behavioral;