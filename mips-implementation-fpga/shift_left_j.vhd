----------------------------------------------------------------------------------
-- Company: Universidad Catolica
-- Engineer: Vicente Gonzalez
-- 
-- Create Date:    12:05:38 04/14/2014 
-- Design Name: 
-- Module Name:    shift_left_j - Behavioral 
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

ENTITY shift_left_j IS
    PORT (
        ent : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
        sal : OUT STD_LOGIC_VECTOR (27 DOWNTO 0));
END shift_left_j;

ARCHITECTURE Behavioral OF shift_left_j IS

BEGIN
    sal <= ent & "00";

END Behavioral;