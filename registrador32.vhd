-- Registrador 32 Bits

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registrador32 is

	port 
	(
	  d : in std_logic_vector (31 downto 0);
	  load : in std_logic;
	  clear: in std_logic;
	  clock: in std_logic;
	  q : out std_logic_vector (31 downto 0) := "00000000000000000000000000000000"
	);

end entity;

architecture rtl of registrador32 is
begin

	process(clock, clear)
	begin
		if(clear = '1') then
			q <= "00000000000000000000000000000000";
		elsif (rising_edge(CLOCK)) then
			if(load = '1') then
				q <= d;
			end if;
		end if;
	end process;

end rtl;