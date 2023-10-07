----------------------------------------------------------------------------------
-- Company: Universidad Catolica
-- Engineer: Vicente Gonzalez
-- 
-- Create Date:    08:42:24 04/12/2014 
-- Design Name: 
-- Module Name:    mux32_4a1 - Behavioral 
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

ENTITY mux32_4a1 IS
    PORT (
        e0 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        e1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        e2 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        e3 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        sel : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        s : OUT STD_LOGIC_VECTOR (31 DOWNTO 0));
END mux32_4a1;

ARCHITECTURE Behavioral OF mux32_4a1 IS

BEGIN
    s <= e0 WHEN sel = "00" ELSE
        e1 WHEN sel = "01" ELSE
        e2 WHEN sel = "10" ELSE
        e3;
    --	process (e0, e1, e2, e3) is
    --	begin
    --		case sel is
    --			when "00"   => s <= e0;
    --			when "01"   => s <= e1;
    --			when "10"   => s <= e2;
    --			when "11"   => s <= e3;
    --			when others => s <= e0;
    --		end case;	
    --	end process;

END Behavioral;