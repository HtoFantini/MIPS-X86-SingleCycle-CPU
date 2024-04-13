LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;
USE STD.TEXTIO.ALL;

-- RAM entity
ENTITY BANCO_DE_REGISTRADORES IS
    PORT(
       REGWRITE : IN STD_LOGIC; -- 1 ESCRITA 0 LEITURA
       CLOCK : IN STD_LOGIC;
       READ_REGISTER_1 : IN STD_LOGIC_VECTOR (4 DOWNTO 0); -- ENDEREÇO DO REGISTRADOR 1
       READ_REGISTER_2 : IN STD_LOGIC_VECTOR (4 DOWNTO 0); -- ENDEREÇO DO REGISTRADOR 2
       WRITE_REGISTER : IN STD_LOGIC_VECTOR (4 DOWNTO 0); -- ENDEREÇO DO REGISTRADOR DE ESCRITA
       WRITE_DATA : IN STD_LOGIC_VECTOR (31 DOWNTO 0); -- DADO QUE SERÁ ESCRITO
       READ_DATA_1 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0); -- DADO LIDO DO REGISTRADOR 1
       READ_DATA_2 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0) -- DADO LIDO DO REGISTRADOR 2
    );
END ENTITY;

-- RAM architecture
ARCHITECTURE BEV OF BANCO_DE_REGISTRADORES IS

    TYPE MEM IS ARRAY (31 DOWNTO 0) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    FILE Outputfile: TEXT open write_mode is "bancoderegistradores.txt";
    SIGNAL MEMORY : MEM := (others=>(others=>'0'));
    SIGNAL WRITE_REGISTER_SIGNAL : INTEGER RANGE 0 TO 31;
    SIGNAL READ_REGISTER_1_SIGNAL : INTEGER RANGE 0 TO 31;
    SIGNAL READ_REGISTER_2_SIGNAL : INTEGER RANGE 0 TO 31;

    -- Função para converter std_logic_vector para string
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

    WRITE_REGISTER_SIGNAL <= CONV_INTEGER(WRITE_REGISTER);
    READ_REGISTER_1_SIGNAL <= CONV_INTEGER(READ_REGISTER_1);
    READ_REGISTER_2_SIGNAL <= CONV_INTEGER(READ_REGISTER_2);

    READ_DATA_1 <= MEMORY(READ_REGISTER_1_SIGNAL);
    READ_DATA_2 <= MEMORY(READ_REGISTER_2_SIGNAL);

    PROCESS(CLOCK, REGWRITE)
        variable i : integer := 0;
        variable element_string : string(1 to 32);
		  variable linha : line;
		  variable espaco : line;
		  variable quebra_linha : STRING(1 to 32) := "--------------------------------";
    BEGIN
        IF(rising_edge(CLOCK)) THEN
            IF (REGWRITE='1') THEN  --HABILITA ESCRITA EM 1
                IF(WRITE_REGISTER_SIGNAL = 0) THEN
						 --EMPTY
					 ELSE
						 MEMORY(WRITE_REGISTER_SIGNAL) <= WRITE_DATA;
					 END IF;
				END IF;
			FOR i IN 0 TO 31 LOOP
				 element_string := slv_to_string(MEMORY(i));
				 WRITE(linha, element_string);
				 WRITELINE(Outputfile, linha);
			END LOOP;
			WRITE(espaco, quebra_linha);
			WRITELINE(Outputfile, espaco);
			END IF;
    END PROCESS;
END BEV;