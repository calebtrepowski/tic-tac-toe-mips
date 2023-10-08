--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

PACKAGE general IS

    -- type <new_type> is
    --  record
    --    <type_name>        : std_logic_vector( 7 downto 0);
    --    <type_name>        : std_logic;
    -- end record;
    --
    -- Declare constants
    --
    -- constant <constant_name>		: time := <time_unit> ns;
    -- constant <constant_name>		: integer := <value;

    -- cantidad de bits de direcciones de las memorias del MIPS
    -- Estos definen el tamanho de la memoria disponible para programa y datos
    -- Recordar que el FPGA tiene relativamente poca memoria interna.
    CONSTANT NUM_BITS_MEMORIA_INSTRUCCIONES : INTEGER := 9;
    CONSTANT NUM_BITS_MEMORIA_DATOS : INTEGER := 7;

    -- archivo desde donde se lee el programa a cargarse en la ROM. Se lee en tiempo de sintesis del hardware
    CONSTANT filename : STRING := "programa_pantalla_blanco.txt";
    -- tipos de datos de las memorias de instrucciones y datos del MIPS
    -- definidas segun el tamanho indicado por las constantes definidas antes
    TYPE mem_instrucciones IS ARRAY (0 TO 2 ** NUM_BITS_MEMORIA_INSTRUCCIONES - 1) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    TYPE mem_datos IS ARRAY (0 TO 2 ** NUM_BITS_MEMORIA_DATOS - 1) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    --
    -- Declare functions and procedure
    --
    -- function <function_name>  (signal <signal_name> : in <type_declaration>) return <type_declaration>;
    -- procedure <procedure_name> (<type_declaration> <constant_name>	: in <type_declaration>);
    --

END general;

PACKAGE BODY general IS

    ---- Example 1
    --  function <function_name>  (signal <signal_name> : in <type_declaration>  ) return <type_declaration> is
    --    variable <variable_name>     : <type_declaration>;
    --  begin
    --    <variable_name> := <signal_name> xor <signal_name>;
    --    return <variable_name>; 
    --  end <function_name>;

    ---- Example 2
    --  function <function_name>  (signal <signal_name> : in <type_declaration>;
    --                         signal <signal_name>   : in <type_declaration>  ) return <type_declaration> is
    --  begin
    --    if (<signal_name> = '1') then
    --      return <signal_name>;
    --    else
    --      return 'Z';
    --    end if;
    --  end <function_name>;

    ---- Procedure Example
    --  procedure <procedure_name>  (<type_declaration> <constant_name>  : in <type_declaration>) is
    --    
    --  begin
    --    
    --  end <procedure_name>;

END general;