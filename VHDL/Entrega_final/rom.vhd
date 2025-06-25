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
        0 => B"1100_001_0000001", -- 1100 = Load-Upper-Int, Rd, Constante 
        1 => B"1100_010_0000000", -- 1100 = Load-Upper-Int, Rd, Constante
        2 => B"1100_011_0001111", -- 1100 = Load-Upper-Int, Rd, Constante
        3 => B"1100_100_0000000", -- 1100 = Load-Upper-Int, Rd, Constante
        4 => B"1100_101_0000000", -- 1100 = Load-Upper-Int, Rd, Constante
        5 => B"1100_110_0000000", -- 1100 = Load-Upper-Int, Rd, Constante
        6 => B"1100_111_0100000", -- 1100 = Load-Upper-Int, Rd, Constante 

        -- Carrega o "complemento" de 33 para fazer o BVC (extora para 33 ou mais) 0111111111011111
        7 => B"0100_100_000_1111", -- ADDI:   0100 ddd sss mccc         carrega -1 no R4 R4 = R0 + (-1)
        8 => B"0100_001_001_0001", -- 0100 = ADDI, Rd, R1, Constante
        9 => B"0000_100_100_0100", -- ADD:    0000 ddd rrr xxxx            R4 = R4 + R4
        10 => B"1001_001_011_0000", -- CMPR:   1001 sss rrr xxxx             compara R1-R3
        11 => B"1000_000_1111101", -- BNE:    1000 xxx bbbbbbb
        12 => B"0000_111_100_1111", -- ADD:    0000 ddd rrr xxxx            R7 = R7 + R4
        13 => B"0000_101_111_1111", -- ADD:    0000 ddd rrr xxxx            R5 = R5 + R7
        14 => B"0100_101_101_0001", -- ADDI:   0100 ddd sss mccc            R5 = R5 + 1
        15 => B"0000_101_100_0000", -- ADD:    0000 ddd rrr xxxx           R5 = R5 + R4

        -- Loop adicionando do 1 ao 32
        16 => B"0100_010_010_0001", -- ADDI:   0100 ddd sss mccc
        17 => B"0111_001_010_0000", -- 0111 = Save-Word 0111 rrr eee mccc 
        18 => B"1001_101_010_0000", -- CMPR:   1001 sss rrr xxxx    CMPR:   1001 sss rrr xxxx compara (Soma) R2 e R5
        19 => B"1010_000_1111101", --  BVC:    1010 xxx bbbbbbb              se não overflow pula -3
        
        -- 0 para zerar os valores na RAM
        20 => B"1100_001_0000000", -- 1100 = Load-Upper-Int, Rd, Constante

        -- Loop excluindo multiplos de 2
        21 => B"1100_010_0000010", -- 1100 = Load-Upper-Int, Rd, Constante
        22 => B"0100_010_010_0010", -- 0100 = ADDI:   0100 ddd sss mccc
        23 => B"0111_001_010_0000", -- 0111 = Save-Word 0111 rrr eee mccc 
        24 => B"1001_101_010_0000", -- CMPR:   1001 sss rrr xxxx             compara (Soma) R2 e R5
        25 => B"1010_000_1111101", --  BVC:    1010 xxx 1bbbbbb              se não overflow pula -3
        
        -- Loop excluindo multiplos de 3
        26 => B"1100_010_0000011", -- 1100 = Load-Upper-Int, Rd, Constante
        27 => B"0100_010_010_0011", -- ADDI:   0100 ddd sss mccc
        28 => B"0111_001_010_0000", -- 0111 = Save-Word 0111 rrr eee mccc 
        29 => B"1001_101_010_0000", -- CMPR:   1001 sss rrr xxxx             compara (Soma) R2 e R5
        30 => B"1010_000_1111101", --  BVC:    1010 xxx 1bbbbbb              se não overflow pula -3

        -- Loop excluindo multiplos de 5
        31 => B"1100_010_0000101", -- 1100 = Load-Upper-Int, Rd, Constante
        32 => B"0100_010_010_0101", -- 0100 = ADDI:   0100 ddd sss mccc
        33 => B"0111_001_010_0000", -- 0111 = Save-Word 0111 rrr eee mccc 
        34 => B"1001_101_010_0000", -- CMPR:   1001 sss rrr xxxx             compara (Soma) R2 e R5
        35 => B"1010_000_1111101", --  BVC:    1010 xxx 1bbbbbb              se não overflow pula -3

        -- Loop lendo RAM
        36 => B"1100_010_0000001", -- 1100 = Load-Upper-Int, Rd, Constante
        37 => B"0100_010_010_0001", -- 0100 = ADDI:   0100 ddd sss mccc
        38 => B"0110_110_010_0110", -- 0111 = Load-Word, Constante, Re, Rd 
        39 => B"1001_101_010_0000", -- CMPR:   1001 sss rrr xxxx             compara (Soma) R2 e R5
        40 => B"1010_000_1111101", --  BVC:    1010 xxx 1bbbbbb              se não overflow pula -3
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

