----------------------------------------------------------------------------------
-- Company: Universidad Catolica
-- Engineer: Vicente Gonzalez
-- 
-- Create Date:    16:36:42 06/13/2019 
-- Design Name: 
-- Module Name:    entrada - Behavioral 
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

ENTITY entrada IS
    PORT (
        north : IN STD_LOGIC;
        south : IN STD_LOGIC;
        sw : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        alMIPS : OUT STD_LOGIC_VECTOR (5 DOWNTO 0));
END entrada;

ARCHITECTURE Behavioral OF entrada IS

BEGIN

    alMIPS <= sw & south & north;

END Behavioral;