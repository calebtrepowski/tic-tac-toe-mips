----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:17:27 12/28/2016 
-- Design Name: 
-- Module Name:    vga_driver - Behavioral 
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
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY convertidor_VGA IS
	PORT (
		clk : IN STD_LOGIC;
		CLK25 : IN STD_LOGIC;
		csvga : IN STD_LOGIC;
		dir : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		tipoAcc : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		memwrite : IN STD_LOGIC;
		RST : IN STD_LOGIC;
		datain : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		HSYNC : OUT STD_LOGIC;
		VSYNC : OUT STD_LOGIC;
		RGB : OUT STD_LOGIC_VECTOR (2 DOWNTO 0));
END convertidor_VGA;

ARCHITECTURE Behavioral OF convertidor_VGA IS

	CONSTANT HD : INTEGER := 639; --  639   Horizontal Display (640)
	CONSTANT HFP : INTEGER := 16; --   16   Right border (front porch)
	CONSTANT HSP : INTEGER := 96; --   96   Sync pulse (Retrace)
	CONSTANT HBP : INTEGER := 48; --   48   Left boarder (back porch)

	CONSTANT VD : INTEGER := 479; --  479   Vertical Display (480)
	CONSTANT VFP : INTEGER := 10; --   10   Right border (front porch)
	CONSTANT VSP : INTEGER := 2; --    2   Sync pulse (Retrace)
	CONSTANT VBP : INTEGER := 33; --   33   Left boarder (back porch)

	SIGNAL hPos : INTEGER := 0;
	SIGNAL vPos : INTEGER := 0;

	SIGNAL videoOn : STD_LOGIC := '0';

	SIGNAL fila : INTEGER := 0;
	SIGNAL columna : INTEGER := 0;
	--	type mem_byte is array (0 to 31) of std_logic_vector(7 downto 0);
	--	signal mem00 : mem_byte;	-- bytes menos significativos
	--	signal mem01 : mem_byte;
	--	signal mem10 : mem_byte;
	--	signal mem11 : mem_byte;	-- bytes mas significativos
	-- an array "array of array" type
	--	signal MEM32X32 : std_logic_vector(31 downto 0);
	TYPE mem IS ARRAY (31 DOWNTO 0) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL MEM32X32 : mem;
	SIGNAL actualizar : STD_LOGIC_VECTOR(31 DOWNTO 0);
BEGIN

	actualizar <= datain (31 DOWNTO 0) WHEN tipoAcc = "000" ELSE
		MEM32X32(to_integer(unsigned(dir(15 DOWNTO 2))))(31 DOWNTO 16) & datain(15 DOWNTO 0) WHEN ((tipoAcc = "001" OR tipoAcc = "011") AND dir(1 DOWNTO 0) = "00") ELSE
		datain(15 DOWNTO 0) & MEM32X32(to_integer(unsigned(dir(15 DOWNTO 2))))(15 DOWNTO 0) WHEN ((tipoAcc = "001" OR tipoAcc = "011") AND dir(1 DOWNTO 0) = "10") ELSE
		MEM32X32(to_integer(unsigned(dir(15 DOWNTO 2))))(31 DOWNTO 8) & datain(7 DOWNTO 0) WHEN ((tipoAcc = "010" OR tipoAcc = "100") AND dir(1 DOWNTO 0) = "00") ELSE
		MEM32X32(to_integer(unsigned(dir(15 DOWNTO 2))))(31 DOWNTO 16) & datain(7 DOWNTO 0) & MEM32X32(to_integer(unsigned(dir(15 DOWNTO 2))))(7 DOWNTO 0) WHEN ((tipoAcc = "010" OR tipoAcc = "100") AND dir(1 DOWNTO 0) = "01") ELSE
		MEM32X32(to_integer(unsigned(dir(15 DOWNTO 2))))(31 DOWNTO 24) & datain(7 DOWNTO 0) & MEM32X32(to_integer(unsigned(dir(15 DOWNTO 2))))(15 DOWNTO 0) WHEN ((tipoAcc = "010" OR tipoAcc = "100") AND dir(1 DOWNTO 0) = "10") ELSE
		datain(7 DOWNTO 0) & MEM32X32(to_integer(unsigned(dir(15 DOWNTO 2))))(23 DOWNTO 0) WHEN ((tipoAcc = "010" OR tipoAcc = "100") AND dir(1 DOWNTO 0) = "11") ELSE
		MEM32X32(to_integer(unsigned(dir(15 DOWNTO 2))));

	memorizar : PROCESS (clk25)
	BEGIN
		IF (clk25'event AND clk25 = '1') THEN
			IF (csvga = '1' AND memwrite = '1') THEN
				MEM32X32(to_integer(unsigned(dir(15 DOWNTO 2)))) <= actualizar;
			END IF;
		END IF;
	END PROCESS;
	--mem32 : process(clk25)
	--begin
	--	if (clk25'event and clk25='1') then
	--		if (csvga = '1' and memwrite = '1') then
	--			case tipoAcc is
	--			when "000" =>
	--				MEM32X32(to_integer(unsigned(dir(15 downto 2)))) <= datain (31 downto 0);
	--			when "001" | "011" =>
	--				case dir(1 downto 0) is
	--				when "00" =>
	--					MEM32X32(to_integer(unsigned(dir(15 downto 2)))) <= MEM32X32(31 downto 16) & datain(15 downto 0);
	--				when "10" =>
	--					MEM32X32(to_integer(unsigned(dir(15 downto 2)))) <= datain(15 downto 0) & MEM32X32(15 downto 0);
	--				when others =>
	--					MEM32X32 <= MEM32X32;
	--				end case;
	--			when "010" | "100" =>
	--				case dir(1 downto 0) is
	--				when "00" =>
	--					MEM32X32(to_integer(unsigned(dir(15 downto 2)))) <= MEM32X32(31 DOWNTO 8) & datain(7 downto 0);
	--				when "01" =>
	--					MEM32X32(to_integer(unsigned(dir(15 downto 2)))) <= MEM32X32(31 downto 16) & datain(7 downto 0) & MEM32X32(7 downto 0);
	--				when "10" =>
	--					MEM32X32(to_integer(unsigned(dir(15 downto 2)))) <= MEM32X32(31 downto 24) & datain(7 downto 0) & MEM32X32(15 downto 0);
	--				when "11" =>
	--					MEM32X32(to_integer(unsigned(dir(15 downto 2)))) <= datain(7 downto 0) & MEM32X32(23 downto 0);
	--				when others =>
	--					MEM32X32 <= MEM32X32;
	--				end case;
	--			when others =>
	--				MEM32X32 <= MEM32X32;
	--			end case;
	--		else
	--			MEM32X32 <= MEM32X32;
	--		end if;
	--	else
	--		MEM32X32 <= MEM32X32;
	--	end if;
	--end process;

	--memoria:process(clk25)
	--begin
	--		if (clk25'event and clk25='1') then
	--			if (csvga = '1' and memwrite = '1') then
	--				case tipoAcc is
	--				when "000" =>
	--					mem00(to_integer(unsigned(dir(15 downto 2)))) <= datain(7 downto 0);
	--					mem01(to_integer(unsigned(dir(15 downto 2)))) <= datain(15 downto 8);
	--					mem10(to_integer(unsigned(dir(15 downto 2)))) <= datain(23 downto 16);
	--					mem11(to_integer(unsigned(dir(15 downto 2)))) <= datain(31 downto 24);
	--				when "001" | "011" =>
	--					case dir(1 downto 0) is
	--					when "00" =>
	--						mem00(to_integer(unsigned(dir(15 downto 2)))) <= datain(7 downto 0);
	--						mem01(to_integer(unsigned(dir(15 downto 2)))) <= datain(15 downto 8);
	--					when "10" =>
	--						mem10(to_integer(unsigned(dir(15 downto 2)))) <= datain(7 downto 0);
	--						mem11(to_integer(unsigned(dir(15 downto 2)))) <= datain(15 downto 8);
	--					when others =>
	--					end case;
	--				when "010" | "100" => -- un byte
	--					case dir(1 downto 0) is
	--					when "00" =>
	--						mem00(to_integer(unsigned(dir(15 downto 2)))) <= datain(7 downto 0);
	--					when "01" =>
	--						mem01(to_integer(unsigned(dir(15 downto 2)))) <= datain(7 downto 0);
	--					when "10" =>
	--						mem10(to_integer(unsigned(dir(15 downto 2)))) <= datain(7 downto 0);
	--					when "11" =>
	--						mem11(to_integer(unsigned(dir(15 downto 2)))) <= datain(7 downto 0);
	--					when others =>
	--					end case;
	--				when others =>
	--				end case;
	--			end if;
	--		end if;
	--end process;
	--
	--MEM32X32(0) <= x"00200400";
	--MEM32X32(1) <= x"00200418";
	--MEM32X32(2) <= x"00200424";
	--MEM32X32(3) <= x"00200442";
	--MEM32X32(4) <= x"00200481";
	--MEM32X32(5) <= x"00200481";
	--MEM32X32(6) <= x"00200442";
	--MEM32X32(7) <= x"00200424";
	--MEM32X32(8) <= x"00200418";
	--MEM32X32(9) <= x"00200400";
	--
	--MEM32X32(10) <= x"ffffffff";
	--
	--MEM32X32(11) <= x"00200400";
	--MEM32X32(12) <= x"18281400";
	--MEM32X32(13) <= x"24242400";
	--MEM32X32(14) <= x"42224400";
	--MEM32X32(15) <= x"81218400";
	--MEM32X32(16) <= x"81218400";
	--MEM32X32(17) <= x"42224400";
	--MEM32X32(18) <= x"24242400";
	--MEM32X32(19) <= x"18281400";
	--MEM32X32(20) <= x"00200400";
	--
	--MEM32X32(21) <= x"ffffffff";
	--
	--MEM32X32(22) <= x"00200400";
	--MEM32X32(23) <= x"81200400";
	--MEM32X32(24) <= x"42200400";
	--MEM32X32(25) <= x"24200400";
	--MEM32X32(26) <= x"18200400";
	--MEM32X32(27) <= x"18200400";
	--MEM32X32(28) <= x"24200400";
	--MEM32X32(29) <= x"42200400";
	--MEM32X32(30) <= x"81200400";
	--MEM32X32(31) <= x"00200400";

	Horizontal_position_counter : PROCESS (clk25, RST)
	BEGIN
		IF (RST = '1') THEN
			hpos <= 0;
		ELSIF (clk25'event AND clk25 = '1') THEN
			IF (hPos = (HD + HFP + HSP + HBP)) THEN
				hPos <= 0;
			ELSE
				hPos <= hPos + 1;
			END IF;
		END IF;
	END PROCESS;

	Vertical_position_counter : PROCESS (clk25, RST, hPos)
	BEGIN
		IF (RST = '1') THEN
			vPos <= 0;
		ELSIF (clk25'event AND clk25 = '1') THEN
			IF (hPos = (HD + HFP + HSP + HBP)) THEN
				IF (vPos = (VD + VFP + VSP + VBP)) THEN
					vPos <= 0;
				ELSE
					vPos <= vPos + 1;
				END IF;
			END IF;
		END IF;
	END PROCESS;

	Horizontal_Synchronisation : PROCESS (clk25, RST, hPos)
	BEGIN
		IF (RST = '1') THEN
			HSYNC <= '0';
		ELSIF (clk25'event AND clk25 = '1') THEN
			IF ((hPos <= (HD + HFP)) OR (hPos > HD + HFP + HSP)) THEN
				HSYNC <= '1';
			ELSE
				HSYNC <= '0';
			END IF;
		END IF;
	END PROCESS;

	Vertical_Synchronisation : PROCESS (clk25, RST, vPos)
	BEGIN
		IF (RST = '1') THEN
			VSYNC <= '0';
		ELSIF (clk25'event AND clk25 = '1') THEN
			IF ((vPos <= (VD + VFP)) OR (vPos > VD + VFP + VSP)) THEN
				VSYNC <= '1';
			ELSE
				VSYNC <= '0';
			END IF;
		END IF;
	END PROCESS;

	video_on : PROCESS (clk25, RST, hPos, vPos)
	BEGIN
		IF (RST = '1') THEN
			videoOn <= '0';
		ELSIF (clk25'event AND clk25 = '1') THEN
			IF (hPos <= HD AND vPos <= VD) THEN
				videoOn <= '1';
			ELSE
				videoOn <= '0';
			END IF;
		END IF;
	END PROCESS;

	--MEM32X32 <= mem11(fila) & 
	-- 			   mem10(fila) & 
	--			   mem01(fila) & 
	--			   mem00(fila);

	draw : PROCESS (VideoOn, RST, hPos, vPos)
		VARIABLE offset : NATURAL;
		VARIABLE offset2 : NATURAL;
		VARIABLE xint, yint : INTEGER;
		VARIABLE color : STD_LOGIC;
	BEGIN
		xint := hPos/20;
		yint := vPos/15;
		IF (RST = '1') THEN
			RGB <= "000";
		ELSIF (clk25'event AND clk25 = '1') THEN
			IF videoOn = '1' THEN
				offset := (yint * 32) + (xint);
				offset2 := (xint * 32) + (yint);
				color := MEM32X32(offset2)(offset);
				RGB <= (OTHERS => color);
			ELSE
				RGB <= "000";
			END IF;
		END IF;
	END PROCESS;
	contarcol : PROCESS (clk25, RST, hPos, vPos, videoOn)
	BEGIN
		IF (RST = '1') THEN
			columna <= 0;
		ELSIF (clk25'event AND clk25 = '1') THEN
			IF (videoOn = '1') THEN
				IF ((hPos >= 304 AND hPos < 336) AND (vPos >= 224 AND vPos < 256)) THEN
					IF columna = 31 THEN
						columna <= 0;
					ELSE
						columna <= columna + 1;
					END IF;
				ELSE
					columna <= columna;
				END IF;
			ELSE
				columna <= columna;
			END IF;
		END IF;
	END PROCESS;

	contarfil : PROCESS (clk25, RST, hPos, vPos, videoOn)
	BEGIN
		IF (RST = '1') THEN
			fila <= 0;
		ELSIF (clk25'event AND clk25 = '1') THEN
			IF (videoOn = '1') THEN
				IF ((hPos >= 304 AND hPos < 336) AND (vPos >= 224 AND vPos < 256)) THEN
					IF columna = 31 THEN
						IF fila = 31 THEN
							fila <= 0;
						ELSE
							fila <= fila + 1;
						END IF;
					ELSE
						fila <= fila;
					END IF;
				ELSE
					fila <= fila;
				END IF;
			ELSE
				fila <= fila;
			END IF;
		END IF;
	END PROCESS;

	--draw:process(clk25, RST, hPos, vPos, videoOn)
	--begin
	--	if(RST = '1')then
	--		RGB <= "000";
	--	elsif(clk25'event and clk25 = '1')then
	--		if(videoOn = '1')then
	--			if((MEM32X32(columna)) = '1' and (hPos >= 304 and hPos < 336) AND (vPos >= 224 and vPos <256))then
	--				RGB <= "111";
	--			else
	--				RGB <= "000";
	--			end if;
	--		else
	--			RGB <= "000";
	--		end if;
	--	end if;
	--end process;
	--
END Behavioral;