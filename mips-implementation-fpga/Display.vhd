----------------------------------------------------------------------------------
-- Company: Facultad de Ingenieria -UNA
-- Engineer: Edgar Maqueda
-- 
-- Create Date:    21:24:06 10/19/2022 
-- Design Name: 
-- Module Name:    Display - Behavioral 
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

ENTITY Display IS
	PORT (
		mclk : IN STD_LOGIC;
		sel_dis : IN STD_LOGIC;
		write_cntl : IN STD_LOGIC;
		valor1 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		anodo : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
		--LED :   out STD_LOGIC_VECTOR (6 downto 0);
		salida_LED : OUT STD_LOGIC_VECTOR (6 DOWNTO 0)
	);
END Display;

ARCHITECTURE Behavioral OF Display IS
	SIGNAL clk : STD_LOGIC;
	SIGNAL aux_LED : STD_LOGIC_VECTOR (6 DOWNTO 0);
	SIGNAL digit_1, digit_2, digit_3 : STD_LOGIC_VECTOR(3 DOWNTO 0);
	COMPONENT digit_divider
		PORT (
			valor1 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			digit_1 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			digit_2 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			digit_3 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT clk_divider
		PORT (
			mclk : IN STD_LOGIC;
			clk : OUT STD_LOGIC
		);
	END COMPONENT;

	COMPONENT Seven_seg1
		PORT (
			digit_1 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			digit_2 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			digit_3 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			clk : IN STD_LOGIC;
			anodo : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			LED : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
		);
	END COMPONENT;

BEGIN

	--aux_LED <= LED;

	PROCESS (mclk)
	BEGIN
		IF mclk'event AND mclk = '1' THEN
			IF sel_dis = '1' AND write_cntl = '1' THEN
				salida_LED <= aux_LED;
			END IF;
		END IF;
	END PROCESS;
	Inst_digit_divider : digit_divider PORT MAP(
		valor1 => valor1,
		digit_1 => digit_1,
		digit_2 => digit_2,
		digit_3 => digit_3
	);

	Inst_clk_divider : clk_divider PORT MAP(
		mclk => mclk,
		clk => clk
	);

	Inst_Seven_seg1 : Seven_seg1 PORT MAP(
		digit_1 => digit_1,
		digit_2 => digit_2,
		digit_3 => digit_3,
		clk => clk,
		anodo => anodo,
		LED => aux_LED
	);
END Behavioral;