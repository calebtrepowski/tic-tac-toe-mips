----------------------------------------------------------------------------------
-- Company: Universidad Catolica
-- Engineer: Vicente Gonzalez
-- 
-- Create Date:    17:23:17 04/08/2010 
-- Design Name: MIPS
-- Module Name:    mips - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 13/6/2016
-- Revision 0.01 - File Created
-- Additional Comments: 
-- Se modifico este archivo para que la constante declarada en general.vhd, que define el tamanho de la 
-- ROM de instrucciones, afecte tambien aqui. Lo mismo se hizo para la memoria de datos. 
-- 
--
-- ERRORES CONOCIDOS:
----------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE work.general.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY mips IS
	PORT (
		clk50mhz : IN STD_LOGIC;
		-- pines de reset externos los pines west y east de alrededor de la perilla de la placa
		reset1 : IN STD_LOGIC;
		reset0 : IN STD_LOGIC;
		-- entrada de los dos pulsadores de alrededor de la perilla de la placa
		north : IN STD_LOGIC;
		south : IN STD_LOGIC;
		-- llaves de dos posiciones en la placa
		sw : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		-- interfaz con el LCD de la placa
		salida : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		LCD_E : OUT STD_LOGIC;
		LCD_RS : OUT STD_LOGIC;
		LCD_RW : OUT STD_LOGIC;
		LCD_DB : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		-- puerto serial
		rx : IN STD_LOGIC;
		tx : OUT STD_LOGIC;
		atn : IN STD_LOGIC;
		-- modulo Display
		--Dis_valor1   : in std_logic_vector(7 downto 0);
		anodo : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
		salida_LED : OUT STD_LOGIC_VECTOR (6 DOWNTO 0)
	);
END mips;

ARCHITECTURE Behavioral OF mips IS
	COMPONENT prog IS
		PORT (
			dataDeMI : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			dataAMI : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			dirMI : OUT STD_LOGIC_VECTOR (NUM_BITS_MEMORIA_INSTRUCCIONES - 1 DOWNTO 0);
			writeMI : OUT STD_LOGIC;
			rstMIPS : OUT STD_LOGIC;
			-- lineas de control
			clk : IN STD_LOGIC;
			-- puerto serial
			rx : IN STD_LOGIC;
			tx : OUT STD_LOGIC;
			atn : IN STD_LOGIC
		);
	END COMPONENT;

	COMPONENT divisorCLK IS
		PORT (
			clk50mhz : IN STD_LOGIC;
			clk : OUT STD_LOGIC
		);
	END COMPONENT;
	COMPONENT JR_detect
		PORT (
			funct : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
			jr : OUT STD_LOGIC
		);
	END COMPONENT;
	COMPONENT antirebote
		PORT (
			boton1 : IN STD_LOGIC;
			boton2 : IN STD_LOGIC;
			clk : IN STD_LOGIC;
			reset : OUT STD_LOGIC
		);
	END COMPONENT;
	COMPONENT pc -- Program Counter
		PORT (
			e : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			reset : IN STD_LOGIC;
			clk : IN STD_LOGIC;
			s : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT suma_4 -- sumador para realizar PC + 4
		PORT (
			e : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			s : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT mi -- Memoria de Instrucciones
		PORT (
			dir : IN STD_LOGIC_VECTOR(NUM_BITS_MEMORIA_INSTRUCCIONES - 1 DOWNTO 0);
			s : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			-- interfaz con el programador
			dirMI : IN STD_LOGIC_VECTOR (NUM_BITS_MEMORIA_INSTRUCCIONES - 1 DOWNTO 0);
			dataS : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			dataE : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			writeProg : IN STD_LOGIC;
			clk : IN STD_LOGIC
		);
	END COMPONENT;
	COMPONENT mux5_4a1
		PORT (
			e0 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
			e1 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
			e2 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
			e3 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
			control : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			s : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT reg
		PORT (
			rr1 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
			rr2 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
			wr : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
			clk : IN STD_LOGIC;
			regwrite : IN STD_LOGIC;
			reset : IN STD_LOGIC;
			wd : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			rd1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			rd2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT shift_left16
		PORT (
			ent : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			sal : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT alu
		PORT (
			op1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			op2 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			control : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			shiftamt : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
			s : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			zero : OUT STD_LOGIC
		);
	END COMPONENT;
	COMPONENT control_branch
		PORT (
			branch : IN STD_LOGIC;
			bne : IN STD_LOGIC;
			zero : IN STD_LOGIC;
			sal : OUT STD_LOGIC
		);
	END COMPONENT;
	COMPONENT exten_signo_cero
		PORT (
			e : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			cero_ext : IN STD_LOGIC;
			s : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT md_io
		PORT (
			dir : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			datain : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			memwrite : IN STD_LOGIC;
			memread : IN STD_LOGIC;
			tipoAcc : IN STD_LOGIC_VECTOR (2 DOWNTO 0); --tipo de operacion a realizar, cargar bytes, half word y word
			clk : IN STD_LOGIC;
			clk50mhz : IN STD_LOGIC;
			reset : IN STD_LOGIC;
			north : IN STD_LOGIC;
			south : IN STD_LOGIC;
			sw : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			dataout : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			salida : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			anodo : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			salida_LED : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			LCD_E : OUT STD_LOGIC;
			LCD_RS : OUT STD_LOGIC;
			LCD_RW : OUT STD_LOGIC;
			LCD_DB : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT mux32
		PORT (
			e0 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			e1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			sel : IN STD_LOGIC;
			s : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT mux32_4a1
		PORT (
			e0 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			e1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			e2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			e3 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			s : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT shift_left
		PORT (
			e : IN STD_LOGIC_VECTOR(29 DOWNTO 0);
			s : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT shift_left_j
		PORT (
			ent : IN STD_LOGIC_VECTOR (25 DOWNTO 0);
			sal : OUT STD_LOGIC_VECTOR (27 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT sumador32
		PORT (
			e1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			e2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			s : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		);
	END COMPONENT;

	-- unidades de control
	COMPONENT alu_control
		PORT (
			aluop : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			funct : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
			s : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT control1
		PORT (
			op : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
			jr_detect : IN STD_LOGIC;
			reset : IN STD_LOGIC;

			tipoAcc : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
			regdst : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
			branch : OUT STD_LOGIC;
			bne : OUT STD_LOGIC;
			memread : OUT STD_LOGIC;
			memtoreg : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
			aluop : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
			memwrite : OUT STD_LOGIC;
			alusrc : OUT STD_LOGIC;
			lui : OUT STD_LOGIC;
			jump : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
			regwrite : OUT STD_LOGIC;
			Zero_extend : OUT STD_LOGIC
		);
	END COMPONENT;
	-- Definimos senhales para interconexion
	SIGNAL nuevo_pc : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL dir_ins : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL instruccion : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL pc_mas_4 : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL lee_reg1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL lee_reg2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL salida_alu : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL salida_mem : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL escribe_reg : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL mem_o_alu : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL ext_signo : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL corr_izq : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL dir_branch : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL dir_jump : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL dir_jump28 : STD_LOGIC_VECTOR(27 DOWNTO 0);
	SIGNAL dir_branch_o_PC_4 : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL shift_16 : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL tipoAcc : STD_LOGIC_VECTOR (2 DOWNTO 0);
	SIGNAL dir_esc_reg : STD_LOGIC_VECTOR(4 DOWNTO 0);

	SIGNAL alu_cntl : STD_LOGIC_VECTOR(3 DOWNTO 0);

	SIGNAL cero : STD_LOGIC;

	SIGNAL sal_mult_alu : STD_LOGIC_VECTOR(31 DOWNTO 0);

	SIGNAL dirMIprog : STD_LOGIC_VECTOR(NUM_BITS_MEMORIA_INSTRUCCIONES - 1 DOWNTO 0);
	SIGNAL dataDeMI : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL dataAMI : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL writeMIProg : STD_LOGIC;
	SIGNAL rstMIPSProg : STD_LOGIC;

	-- senhales de control
	SIGNAL regdst : STD_LOGIC_VECTOR (1 DOWNTO 0);
	SIGNAL branch : STD_LOGIC;
	SIGNAL bne : STD_LOGIC;
	SIGNAL memread : STD_LOGIC;
	SIGNAL memtoreg : STD_LOGIC_VECTOR (1 DOWNTO 0);
	SIGNAL aluop : STD_LOGIC_VECTOR (2 DOWNTO 0);
	SIGNAL memwrite : STD_LOGIC;
	SIGNAL alusrc : STD_LOGIC;
	SIGNAL regwrite : STD_LOGIC;
	SIGNAL sel_mux_branch : STD_LOGIC;
	SIGNAL lui : STD_LOGIC;
	SIGNAL jump : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL Zero_extend : STD_LOGIC;
	SIGNAL jr_detect_sig : STD_LOGIC;

	SIGNAL reset_boton : STD_LOGIC;
	SIGNAL reset : STD_LOGIC;
	SIGNAL clk : STD_LOGIC;
BEGIN

	inst_prog : prog PORT MAP(
		dataDeMI => dataDeMI,
		dataAMI => dataAMI,
		dirMI => dirMIprog,
		writeMI => writeMIProg,
		rstMIPS => rstMIPSProg,
		-- lineas de control
		clk => clk,
		-- puerto serial
		rx => rx,
		tx => tx,
		atn => atn
	);

	Inst_divisorCLK : divisorCLK PORT MAP(
		clk50mhz => clk50mhz,
		clk => clk
	);

	Inst_antirebote : antirebote PORT MAP(
		boton1 => reset1,
		boton2 => reset0,
		clk => clk,
		reset => reset_boton -- fuente del reset
	);

	-- el reset del MIPS se activa o por los botones de reset externos 
	-- o por el reset del circuito de programacion
	reset <= reset_boton OR rstMIPSProg;

	Inst_pc : pc PORT MAP(
		e => nuevo_pc,
		s => dir_ins,
		reset => reset,
		clk => clk
	);
	Inst_suma_4 : suma_4 PORT MAP(
		e => dir_ins,
		s => pc_mas_4
	);
	Inst_mi : mi PORT MAP(
		dir => dir_ins(NUM_BITS_MEMORIA_INSTRUCCIONES - 1 + 2 DOWNTO 2),
		s => instruccion,
		-- interfaz con el programador
		dirMI => dirMIprog,
		dataS => dataDeMI,
		dataE => dataAMI,
		writeProg => writeMIProg,
		clk => clk
	);
	Inst_mux5_4a1 : mux5_4a1 PORT MAP(
		e0 => instruccion(20 DOWNTO 16),
		e1 => instruccion(15 DOWNTO 11),
		e2 => B"11111",
		e3 => B"11111",
		control => regdst,
		s => dir_esc_reg
	);
	Inst_reg : reg PORT MAP(
		rr1 => instruccion(25 DOWNTO 21),
		rr2 => instruccion(20 DOWNTO 16),
		wr => dir_esc_reg,
		clk => clk,
		regwrite => regwrite,
		reset => reset,
		rd1 => lee_reg1,
		rd2 => lee_reg2,
		wd => escribe_reg
	);
	Inst_shift_left16 : shift_left16 PORT MAP(
		ent => instruccion(15 DOWNTO 0),
		sal => shift_16
	);
	Inst_alu : alu PORT MAP(
		op1 => lee_reg1,
		op2 => sal_mult_alu,
		control => alu_cntl,
		shiftamt => instruccion(10 DOWNTO 6),
		s => salida_alu,
		zero => cero
	);
	Inst_exten_signo_cero : exten_signo_cero PORT MAP(
		e => instruccion(15 DOWNTO 0),
		cero_ext => Zero_extend,
		s => ext_signo
	);
	Inst_control_branch : control_branch PORT MAP(
		branch => branch,
		bne => bne,
		zero => cero,
		sal => sel_mux_branch
	);
	Inst_md_io : md_io PORT MAP(
		dir => salida_alu,
		datain => lee_reg2,
		memwrite => memwrite,
		memread => memread,
		tipoAcc => tipoAcc,
		clk => clk,
		clk50mhz => clk50mhz,
		reset => reset,
		north => north,
		south => south,
		sw => sw,
		dataout => salida_mem,
		salida => salida,
		anodo => anodo,
		salida_LED => salida_LED,
		LCD_E => LCD_E,
		LCD_RS => LCD_RS,
		LCD_RW => LCD_RW,
		LCD_DB => LCD_DB
	);
	Inst_mux32_branch : mux32 PORT MAP(
		e0 => pc_mas_4,
		e1 => dir_branch,
		sel => sel_mux_branch,
		s => dir_branch_o_PC_4
	);
	Inst_mux32_4a1_jump : mux32_4a1 PORT MAP(
		e0 => dir_branch_o_PC_4,
		e1 => dir_jump,
		e2 => lee_reg1,
		e3 => lee_reg1,
		sel => jump,
		s => nuevo_pc
	);
	Inst_mux32_4a1_mem : mux32_4a1 PORT MAP(
		e0 => salida_alu,
		e1 => salida_mem,
		e2 => shift_16,
		e3 => pc_mas_4,
		sel => memtoreg,
		s => mem_o_alu
	);
	Inst_mux32_lui : mux32 PORT MAP(
		e0 => mem_o_alu,
		e1 => shift_16,
		sel => lui,
		s => escribe_reg
	);
	Inst_mux32_ALU : mux32 PORT MAP(
		e0 => lee_reg2,
		e1 => ext_signo,
		sel => alusrc,
		s => sal_mult_alu
	);
	Inst_shift_left : shift_left PORT MAP(
		e => ext_signo(29 DOWNTO 0),
		s => corr_izq
	);
	Inst_shift_left_jump : shift_left_j PORT MAP(
		ent => instruccion(25 DOWNTO 0),
		sal => dir_jump28
	);
	dir_jump <= pc_mas_4(31 DOWNTO 28) & dir_jump28;
	Inst_sumador32 : sumador32 PORT MAP(
		e1 => pc_mas_4,
		e2 => corr_izq,
		s => dir_branch
	);
	Inst_alu_control : alu_control PORT MAP(
		aluop => aluop,
		funct => instruccion(5 DOWNTO 0),
		s => alu_cntl
	);
	Inst_jr_detect : JR_detect PORT MAP(
		funct => instruccion(5 DOWNTO 0),
		jr => jr_detect_sig
	);
	Inst_control1 : control1 PORT MAP(
		op => instruccion(31 DOWNTO 26),
		jr_detect => jr_detect_sig,
		reset => reset,
		tipoAcc => tipoAcc,
		regdst => regdst,
		branch => branch,
		bne => bne,
		memread => memread,
		memtoreg => memtoreg,
		aluop => aluop,
		memwrite => memwrite,
		alusrc => alusrc,
		lui => lui,
		jump => jump,
		regwrite => regwrite,
		Zero_extend => Zero_extend
	);

END Behavioral;