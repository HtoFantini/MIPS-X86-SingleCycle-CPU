library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity deslocador is
port (
    RESET : in std_logic;
    INPUT : in std_logic_vector(31 downto 0);
    OUTPUT : out std_logic_vector(31 downto 0)
);
end deslocador;

architecture arch of deslocador is
begin
process( INPUT,RESET) BEGIN
    IF(RESET = '1') THEN
        OUTPUT <= "00000000000000000000000000000000";
    ELSE
        --OUTPUT(31 DOWNTO 1) <= INPUT(30 DOWNTO 0);
        --OUTPUT(0) <= '0';
        OUTPUT(30 DOWNTO 0) <= INPUT(31 DOWNTO 1);
        OUTPUT(31) <= INPUT(31);
    END IF;
end process;

end arch;