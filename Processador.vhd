library ieee;
LIBRARY work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
USE ieee.std_logic_signed.all;



ENTITY Processador IS 
	PORT
	(
		Saida		:  OUT STD_LOGIC_VECTOR(31 downto 0);
		Clock 	:  IN  STD_LOGIC
	);
END Processador;


architecture rtl of Processador is

component somador32 is
  port
  (
    input1 : in std_logic_vector (31 downto 0);
    input2 : in std_logic_vector (31 downto 0);
    output : out std_logic_vector (31 downto 0)
  );
end component;

component soma4 is
  port
  (
    input1 : in std_logic_vector (31 downto 0);
    output : out std_logic_vector (31 downto 0)
  );
end component;

component SEPARADOR_INSTRUCAO is
port(
      INSTRUCAO : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      INTRUCAO_06_00 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
      INTRUCAO_11_07 : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
      INTRUCAO_14_12 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      INTRUCAO_19_15 : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
      INTRUCAO_24_20 : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
      INTRUCAO_30    : OUT STD_LOGIC;  
      INTRUCAO_31_25 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
      INSTRUCAO_COMPLETA : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
end component;

component alu is
    port (
        CONTROL : in    std_logic_vector(3 downto 0);
        SRC1    : in    std_logic_vector(31 downto 0);
        SRC2    : in    std_logic_vector(31 downto 0);
		  ZERO    : out   std_logic;
        RESULT  : out   std_logic_vector(31 downto 0);
        OUT_ADDR: out   std_logic_vector(7 downto 0)
    );
end component;

component ALU_CONTROL IS
  PORT(
       ALU_OP : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
       BIT_30 : IN STD_LOGIC;
       BIT_14_12 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
       OPERATION : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
      );
END component;

component BANCO_DE_REGISTRADORES IS
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
END component;

component CONTROLADORA is
  port(
        OPCODE 		: IN STD_LOGIC_VECTOR(6 DOWNTO 0);
        BRANCH 		: OUT STD_LOGIC;
        MEMREAD 		: OUT STD_LOGIC;
        MEMTOREG 		: OUT STD_LOGIC;
        ALUOP 			: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        MEMWRITE 		: OUT STD_LOGIC;
        ALUSRC 		: OUT STD_LOGIC;
        REGWRITE 		: OUT STD_LOGIC;
        JALR_Control	: OUT STD_LOGIC;
        JAL_Control	: OUT std_logic
    );
end component;

component deslocador is
  port (
        RESET : in std_logic;
        INPUT : in std_logic_vector(31 downto 0);
        OUTPUT : out std_logic_vector(31 downto 0)
  );
end component;

component GERADOR_IMEDIATO is
  port(
       INSTRUCAO : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
       IMEDIATO : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
end component;

component MEMORIA_DE_INSTRUCOES is
    generic(
            addr_width : integer := 6; -- Pode ser de até 2^64
            addr_bits  : integer := 32; -- required bits to store 256 elements
            data_width : integer := 32 -- each element has 32-bits
           );
    port(
        addr : in std_logic_vector(addr_bits-1 downto 0);
        data : out std_logic_vector(data_width-1 downto 0)
    );
end component;

component mux IS
	PORT ( E1, E2 : IN STD_LOGIC_VECTOR (31 downto 0);
		seleciona : IN STD_LOGIC;
		f : OUT STD_LOGIC_VECTOR (31 downto 0)) ;
END component ;

component PORTA_AND IS
  PORT(
       INPUT_1 : IN STD_LOGIC;
       INPUT_2 : IN STD_LOGIC;
       OUTPUT: OUT STD_LOGIC
       );
END component;

component RAM IS
  PORT(
       DATAIN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
       ADDRESS : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
       -- Write when 1, Read when 0
       CLK : IN STD_LOGIC;
       MEM_READ : IN STD_LOGIC;
       MEM_WRITE : IN STD_LOGIC;
       DATAOUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
      );
END component;

component registrador32 is
	port 
	(
		d : in std_logic_vector (31 downto 0);
		load : in std_logic;
		clear: in std_logic;
		clock: in std_logic;
		q : out std_logic_vector (31 downto 0)
	);

end component;

--Soma 4
signal Out_Soma4 				: std_logic_vector(31 downto 0);
--PC
signal Out_PC	 				: std_logic_vector(31 downto 0);
--Memoria Instrucoes
signal Out_MEM_INSTRU		: std_logic_vector(31 downto 0);

--Separador de Instrucoes
signal INSTRUCAO_06_00		: std_logic_vector(6 downto 0);
signal INSTRUCAO_11_07		: std_logic_vector(4 downto 0);
signal INSTRUCAO_14_12		: std_logic_vector(2 downto 0);
signal INSTRUCAO_19_15		: std_logic_vector(4 downto 0);
signal INSTRUCAO_24_20		: std_logic_vector(4 downto 0);
signal INSTRUCAO_30			: std_logic;
signal INSTRUCAO_31_25		: std_logic_vector(6 downto 0);
signal INSTRUCAO_COMPLETA	: std_logic_vector(31 downto 0);

--Controladora
--signal OPCODE         	: STD_LOGIC_VECTOR(6 DOWNTO 0);
signal BRANCH         		: STD_LOGIC;
signal MEMREAD     			  : STD_LOGIC;
signal MEMTOREG     			: STD_LOGIC;
signal ALUOP         		  : STD_LOGIC_VECTOR(2 DOWNTO 0);
signal MEMWRITE     			: STD_LOGIC;
signal ALUSRC         		: STD_LOGIC;
signal REGWRITE     			: STD_LOGIC;

--Banco de Registradores
signal READ_DATA_1 			: STD_LOGIC_VECTOR (31 DOWNTO 0);
signal READ_DATA_2 			: STD_LOGIC_VECTOR (31 DOWNTO 0);

--Gerador de Imediato
signal IMEDIATO 				: STD_LOGIC_VECTOR(31 DOWNTO 0);

--MUX 3 (ALU)
signal Out_MUX_3				: STD_LOGIC_VECTOR(31 DOWNTO 0);

--ALU Control
signal OPERATION 				: STD_LOGIC_VECTOR(3 DOWNTO 0);

--ALU
signal ZERO            		: std_logic;
signal RESULT          		: std_logic_vector(31 downto 0);
signal OUT_ADDR        		: std_logic_vector(7 downto 0);

--Memoria RAM
signal DATAOUT 				: STD_LOGIC_VECTOR(31 DOWNTO 0);

--Deslocador
signal OUTPUT 					: std_logic_vector(31 downto 0);

--Porta AND
signal OUT_AND 				: std_logic;

--Somador
signal Out_Somador 			: std_logic_vector (31 downto 0);

--MUX 1 (BRANCH)
signal Out_MUX_1				: std_logic_vector (31 downto 0);

--MUX 2 (Saida)
signal Out_MUX_2				: std_logic_vector (31 downto 0);

--MUX_JALR
signal JALR_Ctrl				: std_logic;
signal Out_MUX_JALR			: std_logic_vector (31 downto 0);

--MUX_JAL
signal JAL_Ctrl				: std_logic;
signal Out_MUX_JAL			: std_logic_vector (31 downto 0);

begin
  Saida<=Out_MUX_2;
  somador 		: somador32 port map(input1=>Out_PC, input2=>OUTPUT, output=>Out_Somador);

  somaConst 	: soma4 port map(input1=>Out_PC, output=>Out_Soma4);

  separador 	: SEPARADOR_INSTRUCAO port map(INSTRUCAO=>Out_MEM_INSTRU, INTRUCAO_06_00=>INSTRUCAO_06_00, INTRUCAO_11_07=>INSTRUCAO_11_07, 
                              INTRUCAO_14_12=>INSTRUCAO_14_12, INTRUCAO_19_15=>INSTRUCAO_19_15, INTRUCAO_24_20=>INSTRUCAO_24_20,
                              INTRUCAO_30=>INSTRUCAO_30, INSTRUCAO_COMPLETA=>INSTRUCAO_COMPLETA);

  ALU_1			  : alu port map(CONTROL=>OPERATION, SRC1=>READ_DATA_1, SRC2=>Out_MUX_3, ZERO=>ZERO, RESULT=>RESULT, OUT_ADDR=>OUT_ADDR);

  ALU_Ctrl		: ALU_CONTROL port map(ALU_OP => ALUOP, BIT_30 => INSTRUCAO_30, BIT_14_12 => INSTRUCAO_14_12, OPERATION => OPERATION);

  BANCO_REG	  : BANCO_DE_REGISTRADORES port map(REGWRITE => REGWRITE, CLOCK => Clock, READ_REGISTER_1 => INSTRUCAO_19_15,
                                READ_REGISTER_2 => INSTRUCAO_24_20, WRITE_REGISTER => INSTRUCAO_11_07, WRITE_DATA => Out_MUX_JAL,
                                READ_DATA_1 => READ_DATA_1, READ_DATA_2 => READ_DATA_2);

  CONTROLER	  : CONTROLADORA port map(OPCODE => INSTRUCAO_06_00, BRANCH => BRANCH, MEMREAD => MEMREAD, MEMTOREG => MEMTOREG, ALUOP => ALUOP,
                          MEMWRITE => MEMWRITE, ALUSRC => ALUSRC, REGWRITE => REGWRITE, JALR_Control => JALR_Ctrl, JAL_Control => JAL_Ctrl);

  desloc		  : deslocador port map(RESET => '0', INPUT => Out_MUX_JALR, OUTPUT => OUTPUT);

  GERA_IME		: GERADOR_IMEDIATO port map(INSTRUCAO => INSTRUCAO_COMPLETA, IMEDIATO=>IMEDIATO);

  MEM_INSTRU	: MEMORIA_DE_INSTRUCOES port map(addr => Out_PC, data => Out_MEM_INSTRU);	

  mux_1			  : mux port map(E1=>Out_Soma4, E2=>Out_Somador, seleciona=>OUT_AND, f=>Out_MUX_1);	--MUX BRANCH

  mux_2			  : mux port map(E1=>RESULT, E2=>DATAOUT, seleciona=>MEMTOREG, f=>Out_MUX_2);			--MUX SAÍDA

  mux_3			  : mux port map(E1=>READ_DATA_2, E2=>IMEDIATO, seleciona=>ALUSRC, f=>Out_MUX_3);		--MUX ALU

  PORTA_AND_1	: PORTA_AND port map(INPUT_1 => BRANCH, INPUT_2 => ZERO, OUTPUT => OUT_AND);

  MEM_RAM		  : RAM port map(DATAIN=>READ_DATA_2, ADDRESS=>OUT_ADDR, CLK=>Clock, MEM_READ=>MEMREAD, MEM_WRITE=>MEMWRITE, DATAOUT=>DATAOUT);

  PC				  : registrador32 port map(d=>Out_MUX_1, load=>'1', clear=>'0', clock=>Clock, q=>Out_PC);

  mux_JALR	  : mux port map(E1=>IMEDIATO, E2=>Out_MUX_2, seleciona=>JALR_Ctrl, f=>Out_MUX_JALR);

  mux_JAL		  : mux port map(E1=>Out_MUX_2, E2=>Out_Soma4, seleciona=>JAL_Ctrl, f=>Out_MUX_JAL);
end rtl;