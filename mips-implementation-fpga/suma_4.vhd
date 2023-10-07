----------------------------------------------------------------------------------
-- Company: Universidad Catolica
-- Engineer: Vicente Gonzalez
-- 
-- Create Date:    16:29:52 04/05/2010 
-- Design Name: 
-- Module Name:    suma_4 - Behavioral 
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

ENTITY suma_4 IS
    PORT (
        e : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        s : OUT STD_LOGIC_VECTOR (31 DOWNTO 0));
END suma_4;

ARCHITECTURE Behavioral OF suma_4 IS

BEGIN
    s <= e + X"00000004";

END Behavioral;