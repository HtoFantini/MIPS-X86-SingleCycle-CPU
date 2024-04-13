library IEEE;
use IEEE.std_logic_1164.all;

entity GERADOR_IMEDIATO is
port(
  INSTRUCAO : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
  IMEDIATO : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
end GERADOR_IMEDIATO;



architecture rtl of GERADOR_IMEDIATO is
signal opcode : std_logic_vector(6 downto 0);
signal IMM : std_logic_vector(31 downto 0);
begin
    opcode <= instrucao(6 downto 0);
    IMEDIATO <= IMM;

    process(INSTRUCAO, opcode, IMM) 
    begin
        if((opcode = "0000011") or (opcode = "0010011") or (opcode = "1100111")) then --tipo I
            IMM(11 DOWNTO 0) <= INSTRUCAO(31 DOWNTO 20);
            if(IMM(11) = '0') then
                IMM(31 downto 12) <= "00000000000000000000";

                elsif(IMM(11) = '1') then
                    IMM(31 downto 12) <= "11111111111111111111";
            end if;

        elsif (opcode = "0100011") then --tipo S
            IMM(11 DOWNTO 5) <= INSTRUCAO(31 DOWNTO 25);
            IMM(4 DOWNTO 0) <= INSTRUCAO(11 DOWNTO 7);
            if(IMM(11) = '0') then
                IMM(31 downto 12) <= "00000000000000000000";
                elsif(IMM(11) = '1') then
                    IMM(31 downto 12) <= "11111111111111111111";
            end if;

        elsif (opcode = "1100011") then --tipo B
            IMM(11) <= INSTRUCAO(31);
            IMM(10) <= INSTRUCAO(7);
            IMM(9 DOWNTO 4) <= INSTRUCAO(30 DOWNTO 25);
            IMM(3 DOWNTO 0) <= INSTRUCAO(11 DOWNTO 8);

            if(IMM(11) = '0') then
                IMM(31 downto 12) <= "00000000000000000000";
                elsif(IMM(11) = '1') then
                    IMM(31 downto 12) <= "11111111111111111111";
            end if;

        elsif ((opcode = "0010111") or (opcode = "0110111")) then --tipo U
            IMM(19 DOWNTO 0) <= INSTRUCAO(31 DOWNTO 12);
            
            if(IMM(19) = '0') then
                IMM(31 downto 20) <= "000000000000";
                elsif(IMM(19) = '1') then
                    IMM(31 downto 20) <= "111111111111";
            end if;

        elsif (opcode = "1101111") then --tipo J
            IMM(19) <= INSTRUCAO(31);
            IMM(9 downto 0) <= INSTRUCAO(30 downto 21);
            IMM(10) <= INSTRUCAO(20);
            IMM(18 downto 11) <= INSTRUCAO(19 downto 12);
            --IMM(19 DOWNTO 0) <= INSTRUCAO(31 DOWNTO 12);

            if(IMM(19) = '0') then
                IMM(31 downto 20) <= "000000000000";

            elsif(IMM(19) = '1') then
                IMM(31 downto 20) <= "111111111111";
            end if;
            
        else
            IMM(31 DOWNTO 0) <= "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
        end if;
        
    end process;
end rtl;

