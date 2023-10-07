----------------------------------------------------------------------------------
-- Company: Universidad Catolica
-- Engineer: Vicente Gonzalez
-- 
-- Create Date:    14:26:14 04/09/2010 
-- Design Name: 
-- Module Name:    shift_left - Behavioral 
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

ENTITY shift_left IS
    PORT (
        e : IN STD_LOGIC_VECTOR (29 DOWNTO 0);
        s : OUT STD_LOGIC_VECTOR (31 DOWNTO 0));
END shift_left;

ARCHITECTURE Behavioral OF shift_left IS

BEGIN
    s <= e & B"00";

END Behavioral;