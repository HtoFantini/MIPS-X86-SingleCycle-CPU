library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;
use ieee.numeric_std.all;

entity alu is
    port (
    	CONTROL : in    std_logic_vector(3 downto 0);
        SRC1    : in    std_logic_vector(31 downto 0);
        SRC2    : in    std_logic_vector(31 downto 0);
		ZERO    : out   std_logic;
        RESULT  : out   std_logic_vector(31 downto 0);
        OUT_ADDR: out   std_logic_vector(7 downto 0)
    );
end alu;


-- Define the architecture for this entity.
-- Consider the following operations to calculate the value or RESULT:
--      CONTROL             RESULT
--      0000                SRC1 and SRC2 
--      0001                SRC1 or SRC2
--      0010                SRC1 + SRC2
--      0110                SRC1 - SRC2
--      0111                SRC1 < SRC2 ? 1 : 0
--      1100                NOT( SRC1 or SRC2 )

-- Consider the following behavior for the ZERO output:
--  ZERO <= RESULT == 0 ? 1 : 0

architecture arch of alu is
begin
    process(CONTROL, SRC1, SRC2)
	 variable temp : std_logic_vector(31 downto 0);
		begin
			case(CONTROL) is
				when "0000" =>
					RESULT <= SRC1 AND SRC2 ;
					temp :=	SRC1 AND SRC2 ;

				when "0001" => 
					RESULT <= SRC1 OR SRC2 ;
					temp :=	SRC1 OR SRC2 ;

				when "0010" => 
					RESULT <= std_logic_vector(signed(SRC1) + signed(SRC2)) ;
					temp :=	std_logic_vector(signed(SRC1) + signed(SRC2)) ;

				when "0110" => 
					RESULT <= std_logic_vector(signed(SRC1) - signed(SRC2)) ;
					temp :=	std_logic_vector(signed(SRC1) - signed(SRC2)) ;

				when "0111" => 
					if(signed(SRC1) < signed(SRC2)) then
						RESULT <= "00000000000000000000000000000001";
						temp := "00000000000000000000000000000001";

						else
							RESULT <= "00000000000000000000000000000000";
							temp := "00000000000000000000000000000000";
					end if;

				when "1100" =>
					RESULT <= NOT(SRC1 OR SRC2);
					temp := NOT(SRC1 OR SRC2);

				WHEN "1101" =>
					RESULT <= std_logic_vector(signed(SRC1) + signed(SRC2)) ;
					temp := "00000000000000000000000000000000";	

				when "1111" =>
					RESULT <= "00000000000000000000000000000000" ;
					temp := "00000000000000000000000000000000";

				when others =>
					RESULT <= "00000000000000000000000000000000";
					temp := "00000000000000000000000000000000";

				end case ;

				if(temp = "00000000000000000000000000000000") then
					ZERO <= '1';
					else
						ZERO <= '0';
				end if;
				
				OUT_ADDR(7 downto 0) <= temp(7 downto 0);
		end process;
end arch;