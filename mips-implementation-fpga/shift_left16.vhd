----------------------------------------------------------------------------------
-- Company: Universidad Catolica
-- Engineer: Vicente Gonzalez
-- 
-- Create Date:    16:14:58 05/11/2010 
-- Design Name: 
-- Module Name:    shift_left16 - Behavioral 
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
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY shift_left16 IS
    PORT (
        ent : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        sal : OUT STD_LOGIC_VECTOR (31 DOWNTO 0));
END shift_left16;

ARCHITECTURE Behavioral OF shift_left16 IS

BEGIN
    sal <= ent & X"0000";

END Behavioral;