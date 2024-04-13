-- Somador 32 bits
library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;
use ieee.numeric_std.all;

entity somador32 is
    port
    (
    input1 : in std_logic_vector (31 downto 0);
    input2 : in std_logic_vector (31 downto 0);
    output : out std_logic_vector (31 downto 0)
    );
end entity;

architecture rtl of somador32 is
begin
    --output <= input2;
    output <= std_logic_vector((signed(input1)) + (signed(input2)));
end rtl;