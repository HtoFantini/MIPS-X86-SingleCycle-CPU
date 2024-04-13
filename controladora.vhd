library IEEE;
use IEEE.std_logic_1164.all;

entity CONTROLADORA is
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
end CONTROLADORA;

architecture rtl of CONTROLADORA is
begin
	process(OPCODE)
    begin
    	if(OPCODE = "0110011") then -- Tipo R OK
				BRANCH <= '0';
            MEMREAD <= '0';
            MEMTOREG <= '0';
            ALUOP <= "010";
            MEMWRITE <= '0' ;
            ALUSRC <= '0';
            REGWRITE <= '1';
				JALR_Control <='0';
				JAL_Control <= '0';

        elsif ((opcode = "0000011")) then -- Tipo I (Loads)
				BRANCH <= '0';
            MEMREAD <= '1';
            MEMTOREG <= '1';
            ALUOP <= "000";
            MEMWRITE <= '0' ;
            ALUSRC <= '1';
            REGWRITE <= '1';
				JALR_Control <='0';
				JAL_Control <= '0';

		  elsif (OPCODE = "0010011") then	-- Tipo I (Imediatos)
				BRANCH <= '0';
            MEMREAD <= '0';
            MEMTOREG <= '0';
            ALUOP <= "100";
            MEMWRITE <= '0' ;
            ALUSRC <= '1';
            REGWRITE <= '1';
				JALR_Control <='0';
				JAL_Control <= '0';

		  elsif (OPCODE = "1100111") then	-- Tipo I (JALR)
				BRANCH <= '1';
            MEMREAD <= '0';
            MEMTOREG <= '0';
            ALUOP <= "101";
            MEMWRITE <= '0' ;
            ALUSRC <= '1';
            REGWRITE <= '1';
				JALR_Control <='1';
				JAL_Control <= '0';

        elsif (OPCODE = "0100011") then -- Tipo S OK
				BRANCH <= '0';
            MEMREAD <= '0';
            MEMTOREG <= 'X';
            ALUOP <= "000";
            MEMWRITE <= '1' ;
            ALUSRC <= '1';
            REGWRITE <= '0';
				JALR_Control <='0';
				JAL_Control <= '0';

        elsif (OPCODE = "1100011") then -- Tipo B OK
				BRANCH <= '1';
            MEMREAD <= '0';
            MEMTOREG <= 'X';
            ALUOP <= "011";
            MEMWRITE <= '0' ;
            ALUSRC <= '0';
            REGWRITE <= '0';
				JALR_Control <='0';
				JAL_Control <= '0';

        elsif (OPCODE = "0110111") then -- Tipo U (SÓ PARA LUI)
				BRANCH <= '0';
            MEMREAD <= '0';
            MEMTOREG <= '0';
            ALUOP <= "000";
            MEMWRITE <= '0' ;
            ALUSRC <= '1';
            REGWRITE <= '1';
				JALR_Control <='0';
				JAL_Control <= '0';

        elsif (OPCODE = "1101111") then -- Tipo J
				BRANCH <= '1';
            MEMREAD <= '0';
            MEMTOREG <= '0';
            ALUOP <= "011";
            MEMWRITE <= '0' ;
            ALUSRC <= '1';
            REGWRITE <= '1';
				JALR_Control <='0';
				JAL_Control <= '1';

			else
				BRANCH <= '0';
            MEMREAD <= '0';
            MEMTOREG <= '0';
            ALUOP <= "000";
            MEMWRITE <= '0' ;
            ALUSRC <= '0';
            REGWRITE <= '0';
				JALR_Control <='0';
				JAL_Control <= '0';
            
        end if;
    end process;
  
end rtl;