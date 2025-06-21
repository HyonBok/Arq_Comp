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
        -- Carrega constantes
        0 => B"1100_001_0000000", -- 1100 = Load-Upper-Int, Rd, Constante
        1 => B"1100_010_0000000", -- 1100 = Load-Upper-Int, Rd, Constante
        2 => B"1100_011_0100000", -- 1100 = Load-Upper-Int, Rd, Constante
        -- Loop adicionando do 1 ao 32
        3 => B"0100_001_0_001_001", -- 0100 = ADDI, Rd, R1, Constante
        4 => B"0100_010_0_010_001", -- 0100 = ADDI, Rd, R1, Constante
        5 => B"0111_0000_010_001", -- 0111 = Save-Word, Constante, Re, R1 
        6 => B"1001_1101_001_011", -- 1001 = BL, Constante, R1, R2
        -- 0 para zerar os valores na RAM
        7 => B"1100_001_0000000", -- 1100 = Load-Upper-Int, Rd, Constante
        -- Loop excluindo multiplos de 2
        8 => B"1100_010_0000010", -- 1100 = Load-Upper-Int, Rd, Constante
        9 => B"0100_010_0_010_010", -- 0100 = ADDI, Rd, R1, Constante
        10 => B"0111_0000_010_001", -- 0111 = Save-Word, Constante, Re, R1 
        11 => B"1001_1110_010_011", -- 1001 = BL, Constante, R1, R2
        -- Loop excluindo multiplos de 3
        12 => B"1100_010_0000011", -- 1100 = Load-Upper-Int, Rd, Constante
        13 => B"0100_010_0_010_011", -- 0100 = ADDI, Rd, R1, Constante
        14 => B"0111_0000_010_001", -- 0111 = Save-Word, Constante, Re, R1 
        15 => B"1001_1110_010_011", -- 1001 = BL, Constante, R1, R2
        -- Loop excluindo multiplos de 5
        16 => B"1100_010_0000101", -- 1100 = Load-Upper-Int, Rd, Constante
        17 => B"0100_010_0_010_101", -- 0100 = ADDI, Rd, R1, Constante
        18 => B"0111_0000_010_001", -- 0111 = Save-Word, Constante, Re, R1 
        19 => B"1001_1110_010_011", -- 1001 = BL, Constante, R1, R2
        -- Loop lendo RAM
        20 => B"1100_010_0000001", -- 1100 = Load-Upper-Int, Rd, Constante
        21 => B"0100_010_0_010_001", -- 0100 = ADDI, Rd, R1, Constante
        22 => B"0110_0000_010_101", -- 0111 = Load-Word, Constante, Re, Rd 
        23 => B"1001_1110_010_011", -- 1001 = BL, Constante, R1, R2
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

