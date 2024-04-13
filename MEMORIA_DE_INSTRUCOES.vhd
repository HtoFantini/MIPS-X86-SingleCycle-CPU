library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MEMORIA_DE_INSTRUCOES is
    generic(
        addr_width : integer := 6; -- quantidade de instrucoes
        addr_bits  : integer := 32; -- quantos bits pra suportar a memoria de ate 256
        data_width : integer := 32 -- n de bits de cada dado
    );

    port(
        addr : in std_logic_vector(addr_bits-1 downto 0);
        data : out std_logic_vector(data_width-1 downto 0)
    );

end MEMORIA_DE_INSTRUCOES;

architecture arch of MEMORIA_DE_INSTRUCOES is

    type rom_type is array (0 to addr_width-1) of std_logic_vector(data_width-1 downto 0);
    -- Instrucoes a serem executadas EM LITTLE ENDIAN (bit menos significativo = inicio da instrucao)     
    signal MI : rom_type := (  "00000100010000000000000001101111", -- jal  x0,17408
                               "00000000011100010000000100010011", -- addi x2,x2, 7
										 "00000000000100010010001000100011", -- sw   x2,4(x1)
										 "00000000000000010010010100000011", -- lw  x10, 0(x2)
										 "00000010011001010000010100110011", -- add x10,x10,x6
										 "00000000001000001000000001100011" -- beq  x1,x2, Start
                              -- "00000000101000010010000000100011",
                              -- "11111111111101010000001010010011",
                              -- "00000000000000101101100001100011",
                              -- "00000000000100000000010100010011",
                              -- "00000000100000010000000100010011",
                              -- "00000000000000001000000001100111",
                              -- "11111111111101010000010100010011",
                              -- "11111101110111111111000011101111",
                              -- "00000000000001010000001100010011",
                              -- "00000000010000010010000010000011",
                              -- "00000000100000010000000100010011",
                              -- "00000000000000001000000001100111",
                              -- "00000000101000000000010100010011",
                              -- "11111011110111111111000011101111",
                              -- "00000000000000000000000000010011"
    );
    
begin
    data <= MI(to_integer(unsigned(addr(7 downto 0))));
end arch; 