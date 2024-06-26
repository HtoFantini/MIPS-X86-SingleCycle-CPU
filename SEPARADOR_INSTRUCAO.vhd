library IEEE;
use IEEE.std_logic_1164.all;

entity SEPARADOR_INSTRUCAO is
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
end SEPARADOR_INSTRUCAO;

architecture rtl of SEPARADOR_INSTRUCAO is
signal Instru : STD_LOGIC_VECTOR(31 DOWNTO 0);
begin
  Instru <= INSTRUCAO(31 DOWNTO 0);
  INTRUCAO_06_00 <= INSTRUCAO(6 DOWNTO 0);
  INTRUCAO_11_07 <= INSTRUCAO(11 DOWNTO 7);
  INTRUCAO_14_12 <= INSTRUCAO(14 DOWNTO 12);
  -- INTRUCAO_19_15 <= INSTRUCAO(19 DOWNTO 15);
  -- INTRUCAO_24_20 <= INSTRUCAO(24 DOWNTO 20);
  INTRUCAO_30 <= INSTRUCAO(30);
  INTRUCAO_31_25 <= INSTRUCAO(31 DOWNTO 25);
  INSTRUCAO_COMPLETA <= INSTRUCAO(31 DOWNTO 0);

  process(Instru)
  begin
	  if (Instru(6 downto 0) = "0100011") then
		INTRUCAO_19_15 <= INSTRUCAO(24 DOWNTO 20);
		INTRUCAO_24_20 <= INSTRUCAO(19 DOWNTO 15);

	  else
      INTRUCAO_19_15 <= INSTRUCAO(19 DOWNTO 15);
      INTRUCAO_24_20 <= INSTRUCAO(24 DOWNTO 20);
	  end if;
  end process;
end rtl;






