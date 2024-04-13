-- Soma 4
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
USE ieee.std_logic_signed.all;

entity soma4 is
    port
    (
        input1 : in std_logic_vector (31 downto 0);
        output : out std_logic_vector (31 downto 0)
    );
end entity;

architecture rtl of soma4 is
begin
    output <= input1 + ("00000000000000000000000000000001");
end rtl;
