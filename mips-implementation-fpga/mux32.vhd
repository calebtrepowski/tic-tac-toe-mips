----------------------------------------------------------------------------------
-- Company: Universidad Catolica
-- Engineer: Vicente Gonzalez
-- 
-- Create Date:    14:30:06 03/26/2010 
-- Design Name: 
-- Module Name:    mux32 - Behavioral 
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
ENTITY mux32 IS
    PORT (
        e0 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        e1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        sel : IN STD_LOGIC;
        s : OUT STD_LOGIC_VECTOR (31 DOWNTO 0));
END mux32;

ARCHITECTURE Behavioral OF mux32 IS

BEGIN
    s <= e0 WHEN sel = '0' ELSE
        e1;

END Behavioral;