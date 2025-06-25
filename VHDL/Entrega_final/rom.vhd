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
        0 => B"1100_111_0100000", -- 1100 = Load-Upper-Int, Rd, Constante 
        1 => B"1100_001_0000001", -- 1100 = Load-Upper-Int, Rd, Constante 
        2 => B"1100_010_0000000", -- 1100 = Load-Upper-Int, Rd, Constante
        3 => B"1100_011_0001110", -- 1100 = Load-Upper-Int, Rd, Constante

        -- Carrega o "complemento" de 33 para fazer o BVC (extora para 33 ou mais) 0111111111011111
        4 => B"1100_100_0000001", -- 1100 = Load-Upper-Int, Rd, Constante
        5 => B"0100_001_0_001_001", -- 0100 = ADDI, Rd, R1, Constante
        6 => B"0000_100_0_100_100", -- ADD:    0000 dddx sss rrr            R4 = R4 + R4
        7 => B"1001_0000_001_011", -- CMP:    1001 xxxx sss rrr             compara R1 e R3
        8 => B"1000_000_1111101", -- BNE:    1000 xxx bbbbbbb
        9 => B"0001_101_0_100_111", -- SUB:    0001 dddx sss rrr            R5 = R4 - R0
        10 => B"0100_101_1_101_110", -- ADDI:   0100 dddm sss ccc            R5 = R5 - 1
        11 => B"0000_101_0_101_100", -- ADD:    0000 dddx sss rrr            R5 = R5 + R4

        -- Loop adicionando do 1 ao 32
        12 => B"0100_010_0_010_001", -- 0100 = ADDI, Rd, R1, Constante
        13 => B"0111_0000_010_001", -- 0111 = Save-Word, Constante, Re, R1 
        14 => B"1011_0000_010_101", -- CMP+:   1011 xxxx sss rrr             compara (Soma) R2 e R5
        15 => B"1010_000_1111101", --  BVC:    1010 xxx bbbbbbb              se não overflow pula -3
        
        -- 0 para zerar os valores na RAM
        16 => B"1100_001_0000000", -- 1100 = Load-Upper-Int, Rd, Constante

        -- Loop excluindo multiplos de 2
        17 => B"1100_010_0000010", -- 1100 = Load-Upper-Int, Rd, Constante
        18 => B"0100_010_0_010_010", -- 0100 = ADDI, Rd, R1, Constante
        19 => B"0111_0000_010_001", -- 0111 = Save-Word, Constante, Re, R1 
        20 => B"1011_0000_010_101", -- CMP+:   1011 xxxx sss rrr             compara (Soma) R2 e R5
        21 => B"1010_000_1111101", --  BVC:    1010 xxx 1bbbbbb              se não overflow pula -3
        
        -- Loop excluindo multiplos de 3
        22 => B"1100_010_0000011", -- 1100 = Load-Upper-Int, Rd, Constante
        23 => B"0100_010_0_010_011", -- 0100 = ADDI, Rd, R1, Constante
        24 => B"0111_0000_010_001", -- 0111 = Save-Word, Constante, Re, R1 
        25 => B"1011_0000_010_101", -- CMP+:   1011 xxxx sss rrr             compara (Soma) R2 e R5
        26 => B"1010_000_1111101", --  BVC:    1010 xxx 1bbbbbb              se não overflow pula -3

        -- Loop excluindo multiplos de 5
        27 => B"1100_010_0000101", -- 1100 = Load-Upper-Int, Rd, Constante
        28 => B"0100_010_0_010_101", -- 0100 = ADDI, Rd, R1, Constante
        29 => B"0111_0000_010_001", -- 0111 = Save-Word, Constante, Re, R1 
        30 => B"1011_0000_010_101", -- CMP+:   1011 xxxx sss rrr             compara (Soma) R2 e R5
        31 => B"1010_000_1111101", --  BVC:    1010 xxx 1bbbbbb              se não overflow pula -3

        -- Loop lendo RAM
        32 => B"1100_010_0000001", -- 1100 = Load-Upper-Int, Rd, Constante
        33 => B"0100_010_0_010_001", -- 0100 = ADDI, Rd, R1, Constante
        34 => B"0110_0000_010_110", -- 0111 = Load-Word, Constante, Re, Rd 
        35 => B"1011_0000_010_101", -- CMP+:   1011 xxxx sss rrr             compara (Soma) R2 e R5
        36 => B"1010_000_1111101", --  BVC:    1010 xxx 1bbbbbb              se não overflow pula -3
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

