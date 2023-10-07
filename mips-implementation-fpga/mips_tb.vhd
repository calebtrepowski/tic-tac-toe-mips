--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:26:11 06/15/2017
-- Design Name:   
-- Module Name:   C:/Users/Usuario/Documents/Materias/Clases Micro 2/XILINX/MIPS-2017/mips_tb.vhd
-- Project Name:  MIPS-2017
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: mips
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

ENTITY mips_tb IS
END mips_tb;

ARCHITECTURE behavior OF mips_tb IS

   -- Component Declaration for the Unit Under Test (UUT)

   COMPONENT mips
      PORT (
         clk : IN STD_LOGIC;
         reset1 : IN STD_LOGIC;
         reset0 : IN STD_LOGIC;
         salida : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
         LCD_E : OUT STD_LOGIC;
         LCD_RS : OUT STD_LOGIC;
         LCD_RW : OUT STD_LOGIC;
         LCD_DB : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0)
      );
   END COMPONENT;
   --Inputs
   SIGNAL clk : STD_LOGIC := '0';
   SIGNAL reset1 : STD_LOGIC := '0';
   SIGNAL reset0 : STD_LOGIC := '0';

   --BiDirs
   SIGNAL LCD_DB : STD_LOGIC_VECTOR(7 DOWNTO 0);

   --Outputs
   SIGNAL salida : STD_LOGIC_VECTOR(7 DOWNTO 0);
   SIGNAL LCD_E : STD_LOGIC;
   SIGNAL LCD_RS : STD_LOGIC;
   SIGNAL LCD_RW : STD_LOGIC;

   -- Clock period definitions
   CONSTANT clk_period : TIME := 20 ns;

BEGIN

   -- Instantiate the Unit Under Test (UUT)
   uut : mips PORT MAP(
      clk => clk,
      reset1 => reset1,
      reset0 => reset0,
      salida => salida,
      LCD_E => LCD_E,
      LCD_RS => LCD_RS,
      LCD_RW => LCD_RW,
      LCD_DB => LCD_DB
   );

   -- Clock process definitions
   clk_process : PROCESS
   BEGIN
      clk <= '0';
      WAIT FOR clk_period/2;
      clk <= '1';
      WAIT FOR clk_period/2;
   END PROCESS;
   -- Stimulus process
   stim_proc : PROCESS
   BEGIN
      -- hold reset state for 100 ns.
      reset0 <= '0';
      reset1 <= '1';
      WAIT FOR clk_period * 2;
      reset0 <= '1';
      reset1 <= '0';
      WAIT FOR clk_period * 2;
      reset0 <= '0';
      reset1 <= '0';

      WAIT FOR clk_period * 2000;

      -- insert stimulus here 

      WAIT;
   END PROCESS;

END;