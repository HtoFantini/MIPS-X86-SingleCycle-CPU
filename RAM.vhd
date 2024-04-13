-- Random Access Memory (RAM) with
-- 1 read/write port

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;
USE STD.TEXTIO.ALL;

-- RAM entity
ENTITY RAM IS
  PORT(
        DATAIN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        ADDRESS : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        -- Write when 1, Read when 0
        CLK : IN STD_LOGIC;
        MEM_READ : IN STD_LOGIC;
        MEM_WRITE : IN STD_LOGIC;
        DATAOUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
       );
END ENTITY;

-- RAM architecture
ARCHITECTURE BEV OF RAM IS

	TYPE MEM IS ARRAY (63 DOWNTO 0) OF STD_LOGIC_VECTOR(31 DOWNTO 0); -- TAMANHO DA MEMORIA TOTALMENTE ARBITRARIO, PODE SER 256 OU 10000000
	FILE Outputfile: TEXT open write_mode is "MemoriaRam.txt";
	SIGNAL MEMORY : MEM := (others=>(others=>'0'));
	SIGNAL ADDR : INTEGER RANGE 0 TO 255;

	function slv_to_string(a: std_logic_vector) return string is
		variable b : string (a'length downto 1) := (others => NUL);
		variable c : integer := 1;
			begin
				for i in a'range loop
					b(c) := std_logic'image(a(i))(2);
					c := c + 1;
				end loop;
			return b;
	end function;
	 
BEGIN

ADDR<=CONV_INTEGER(ADDRESS);
DATAOUT <= MEMORY(ADDR);

	PROCESS(CLK, ADDR, MEM_READ, MEM_WRITE)
		variable i : integer := 0;
      variable element_string : string(1 to 32);
		variable linha : line;
		variable espaco : line;
		variable quebra_linha : STRING(1 to 32) := "--------------------------------";
	BEGIN
		IF(rising_edge(CLK)) THEN
			IF(MEM_WRITE = '1' AND MEM_READ = '0') THEN
				MEMORY(ADDR) <= DATAIN;
			ELSE
				--EMPTY
			END IF;
			FOR i IN 0 TO 63 LOOP -- ESCOLHA ARBITRARIA DE QUANTOS ESPACOS DA MEMORIA VAO SER PRINTADOS
				element_string := slv_to_string(MEMORY(i));
				WRITE(linha, element_string);
				WRITELINE(Outputfile, linha);
			END LOOP;
			WRITE(espaco, quebra_linha);
			WRITELINE(Outputfile, espaco);
		END IF;
	END PROCESS;
END BEV;