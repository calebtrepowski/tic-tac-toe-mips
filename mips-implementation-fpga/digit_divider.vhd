----------------------------------------------------------------------------------
-- Company: Facultad de Ingenieria -UNA
-- Engineer: Edgar Maqueda
-- 
-- Create Date:    11:35:03 10/19/2022 
-- Design Name: 
-- Module Name:    digit_divider - Behavioral 
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
USE IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY digit_divider IS
    PORT (
        valor1 : IN STD_LOGIC_VECTOR (7 DOWNTO 0); --para representar 999
        digit_1, digit_2, digit_3 : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
    );
END digit_divider;

ARCHITECTURE Behavioral OF digit_divider IS
    SIGNAL valor2, valor3 : STD_LOGIC_VECTOR (7 DOWNTO 0);
BEGIN

    PROCESS (valor1, valor2, valor3)
    BEGIN
        IF (unsigned(valor1) >= 900) THEN
            digit_3 <= "1001";
            valor2 <= STD_LOGIC_VECTOR(unsigned(valor1) - 900);
        ELSIF (unsigned(valor1) >= 800) THEN
            digit_3 <= "1000";
            valor2 <= STD_LOGIC_VECTOR(unsigned(valor1) - 800);
        ELSIF (unsigned(valor1) >= 700) THEN
            digit_3 <= "0111";
            valor2 <= STD_LOGIC_VECTOR(unsigned(valor1) - 700);
        ELSIF (unsigned(valor1) >= 600) THEN
            digit_3 <= "0110";
            valor2 <= STD_LOGIC_VECTOR(unsigned(valor1) - 600);
        ELSIF (unsigned(valor1) >= 500) THEN
            digit_3 <= "0101";
            valor2 <= STD_LOGIC_VECTOR(unsigned(valor1) - 500);
        ELSIF (unsigned(valor1) >= 400) THEN
            digit_3 <= "0100";
            valor2 <= STD_LOGIC_VECTOR(unsigned(valor1) - 400);
        ELSIF (unsigned(valor1) >= 300) THEN
            digit_3 <= "0011";
            valor2 <= STD_LOGIC_VECTOR(unsigned(valor1) - 300);
        ELSIF (unsigned(valor1) >= 200) THEN
            digit_3 <= "0010";
            valor2 <= STD_LOGIC_VECTOR(unsigned(valor1) - 200);
        ELSIF (unsigned(valor1) >= 100) THEN
            digit_3 <= "0001";
            valor2 <= STD_LOGIC_VECTOR(unsigned(valor1) - 100);
        ELSE
            digit_3 <= "0000";
            valor2 <= valor1;
        END IF;

        IF (unsigned(valor2) >= 90) THEN
            digit_2 <= "1001";
            valor3 <= STD_LOGIC_VECTOR(unsigned(valor2) - 90);
        ELSIF (unsigned(valor2) >= 80) THEN
            digit_2 <= "1000";
            valor3 <= STD_LOGIC_VECTOR(unsigned(valor2) - 80);
        ELSIF (unsigned(valor2) >= 70) THEN
            digit_2 <= "0111";
            valor3 <= STD_LOGIC_VECTOR(unsigned(valor2) - 70);
        ELSIF (unsigned(valor2) >= 60) THEN
            digit_2 <= "0110";
            valor3 <= STD_LOGIC_VECTOR(unsigned(valor2) - 60);
        ELSIF (unsigned(valor2) >= 50) THEN
            digit_2 <= "0101";
            valor3 <= STD_LOGIC_VECTOR(unsigned(valor2) - 50);
        ELSIF (unsigned(valor2) >= 40) THEN
            digit_2 <= "0100";
            valor3 <= STD_LOGIC_VECTOR(unsigned(valor2) - 40);
        ELSIF (unsigned(valor2) >= 30) THEN
            digit_2 <= "0011";
            valor3 <= STD_LOGIC_VECTOR(unsigned(valor2) - 30);
        ELSIF (unsigned(valor2) >= 20) THEN
            digit_2 <= "0010";
            valor3 <= STD_LOGIC_VECTOR(unsigned(valor2) - 20);
        ELSIF (unsigned(valor2) >= 10) THEN
            digit_2 <= "0001";
            valor3 <= STD_LOGIC_VECTOR(unsigned(valor2) - 10);
        ELSE
            digit_2 <= "0000";
            valor3 <= valor2;
        END IF;

        IF (unsigned(valor3) >= 9) THEN
            digit_1 <= "1001";
        ELSIF (unsigned(valor3) >= 8) THEN
            digit_1 <= "1000";
        ELSIF (unsigned(valor3) >= 7) THEN
            digit_1 <= "0111";
        ELSIF (unsigned(valor3) >= 6) THEN
            digit_1 <= "0110";
        ELSIF (unsigned(valor3) >= 5) THEN
            digit_1 <= "0101";
        ELSIF (unsigned(valor3) >= 4) THEN
            digit_1 <= "0100";
        ELSIF (unsigned(valor3) >= 3) THEN
            digit_1 <= "0011";
        ELSIF (unsigned(valor3) >= 2) THEN
            digit_1 <= "0010";
        ELSIF (unsigned(valor3) >= 1) THEN
            digit_1 <= "0001";
        ELSE
            digit_1 <= "0000";
        END IF;

    END PROCESS;
END Behavioral;