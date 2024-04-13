LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY mux IS
	PORT ( E1, E2 : IN STD_LOGIC_VECTOR (31 downto 0);
		seleciona : IN STD_LOGIC;
		f : OUT STD_LOGIC_VECTOR (31 downto 0)) ;
END mux ;

ARCHITECTURE Behavior OF mux IS
BEGIN
	f <= E1 WHEN seleciona = '0' ELSE E2 ;
END Behavior ;