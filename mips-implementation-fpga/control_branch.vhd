----------------------------------------------------------------------------------
-- Company: Universidad Catolica
-- Engineer: Vicente Gonzalez
-- 
-- Create Date:    16:11:50 05/11/2010 
-- Design Name: 
-- Module Name:    control_branch - Behavioral 
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

ENTITY control_branch IS
    PORT (
        branch : IN STD_LOGIC;
        bne : IN STD_LOGIC;
        zero : IN STD_LOGIC;
        sal : OUT STD_LOGIC);
END control_branch;

ARCHITECTURE Behavioral OF control_branch IS

BEGIN
    sal <= '1' WHEN branch = '1' AND ((bne = '1' AND zero = '0') OR (bne = '0' AND zero = '1')) ELSE
        '0';
END Behavioral;