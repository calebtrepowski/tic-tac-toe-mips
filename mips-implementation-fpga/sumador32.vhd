----------------------------------------------------------------------------------
-- Company: Universidad Catolica
-- Engineer: Vicente Gonzalez
-- 
-- Create Date:    17:21:40 04/08/2010 
-- Design Name: 
-- Module Name:    sumador32 - Behavioral 
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

ENTITY sumador32 IS
    PORT (
        e1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        e2 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        s : OUT STD_LOGIC_VECTOR (31 DOWNTO 0));
END sumador32;

ARCHITECTURE Behavioral OF sumador32 IS

BEGIN
    s <= e1 + e2;

END Behavioral;