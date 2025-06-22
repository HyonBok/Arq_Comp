library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is 
    port(   clk  : in std_logic;
            endereco : in unsigned(6 downto 0);
            dado     : out unsigned(13 downto 0)        
    );
end entity;

architecture a_rom of rom is
    type mem is array (0 to 127) of unsigned(13 downto 0);
    constant conteudo_rom : mem := (
        -- Carrega constantes que vao ser escritas na RAM
        0 => B"1100_000_0000011", -- Load-Int, Rd, Constante (3) 
        1 => B"1100_001_0001010", -- Load-Int, Rd, Constante (10, vai ser usado para endereço da RAM)
        2 => B"1100_010_0010000", -- Load-Int, Rd, Constante (16)
        3 => B"1100_011_0010001", -- Load-Int, Rd, Constante (17) , vai ser usado para endereço da RAM)
        4 => B"1100_100_1111111", -- Load-Int, Rd, Constante (-1)
        5 => B"1100_101_0000001", -- Load-Int, Rd, Constante (1, vai ser usado para endereço da RAM)
        6 => B"1100_110_1111100", -- Load-Int, Rd, Constante (-4)
        7 => B"1100_111_0000100", -- Load-Int, Rd, Constante (4, vai ser usado para endereço da RAM)

        -- Escreve constantes na RAM
        8 => B"0111_0000_001_000", -- Save-Word, Constante, Re, R1 (Salva 3 em 10)
        9 => B"0111_0010_011_010", -- Save-Word, Constante, Re, R1 (Salva 16 em 19)
        10 => B"0111_0000_101_100", -- Save-Word, Constante, Re, R1 (Salva -1 em 1)
        11 => B"0111_1111_111_110", -- Save-Word, Constante, Re, R1 (Salva -4 em 3)
        12 => B"0111_0000_010_010", -- Save-Word, Constante, Re, R1 (Salva 16 em 16)

        -- Lê os valores da RAM
        13 => B"0110_0000_001_110", -- Load-Word, Constante, Re, R1 (Carregar End10 em R6)
        14 => B"0110_0010_011_100", -- Load-Word, Constante, Re, R1 (Carregar End19 em R4)
        15 => B"0110_0000_101_010", -- Load-Word, Constante, Re, R1 (Carregar End1 em R2)
        16 => B"0000_0000_000000", -- NOP
        17 => B"0110_1111_111_000", -- Load-Word, Constante, Re, R1 (Carregar End3 em R0)
        18 => B"0110_0110_001_110", -- Load-Word, Constante, Re, R1 (Carregar End16 em R6)
        others => (others=>'0')
    );
    
begin
    process(clk)
    begin 
        if(rising_edge(clk)) then
            dado <= conteudo_rom(to_integer(endereco));
        end if;
    end process;
end architecture;

