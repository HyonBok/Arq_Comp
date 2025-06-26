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
        -- Carrega constantes (7 bits)
        0 => B"1100_001_0000001", -- LI
        1 => B"1100_010_0000000", -- LI
        2 => B"1100_011_0001111", -- LI
        3 => B"1100_100_0000000", -- LI
        4 => B"1100_101_0000000", -- LI
        5 => B"1100_110_0000000", -- LI
        6 => B"1100_111_0111111", -- LI

        -- Carrega o "complemento" de 63 no R5 para fazer o BVC (estoura para 64 ou mais)
        7 => B"0100_100_000_1111", -- ADDI (Carrega -1 no R4 R4 = R0 + (-1))
        8 => B"0100_001_001_0001", -- ADDI
        9 => B"0000_100_100_0100", -- ADD (R4 = R4 + R4)
        10 => B"1001_001_011_0000", -- CMPR (Compara R1-R3)
        11 => B"1000_000_1111101", -- BNE
        12 => B"0000_111_100_1111", -- ADD (R7 = R7 + R4)
        13 => B"0000_101_111_1111", -- ADD (R5 = R5 + R7)
        14 => B"0000_0000_000000", -- NOP
        15 => B"0000_101_100_0000", -- ADD (R5 = R5 + R4)

        -- Loop adicionando todos como primos do 2 ao 32
        16 => B"0100_010_000_0001", -- ADDI
        17 => B"0100_010_010_0001", -- ADDI
        18 => B"0111_001_010_0000", -- SW
        19 => B"1001_101_010_0000", -- CMPR
        20 => B"1010_000_1111101", --  BVC (Se não overflow pula -3)
        
        -- 0 para zerar os valores na RAM (Poderia ter usado o R0 que é sempre 0, mas acabamos escolhendo R1 na hora)
        21 => B"1100_001_0000000", -- LI
        
        -- Loop principal
        -- Loop i (R2) iniciando em 2 e carrega R3 = 8 (Raiz mais proxima de 64) para comparar
        22 => B"1100_010_0000010", -- LI
        23 => B"1100_011_0001000", -- LI
        -- Enquanto i (R2) != 6 (R3), pula a instrução de JMP (como se fosse um if)
        24 => B"1001_011_010_0000", -- CMPR
        25 => B"1000_000_0000010", -- BNE
        26 => B"1111_000_0100111", -- JMP (Pula tudo e vai para o final - Linha 39)
        -- Compara se o endereco i (R2) da ram é primo (!= 0) carregando valor no R4. (Novamente, como se fosse um if)
        27 => B"0110_100_010_0000", -- LW
        28 => B"1001_100_000_0000", -- CMPR
        29 => B"1000_000_0000010", -- BNE
        30 => B"1111_000_0100100", -- JMP (Pula todo loop de j - Linha 36)
        -- Loop j (R6) iniciando com valor de 2 * i e somando i a cada iteração
        31 => B"0100_110_010_0000", -- MOV
        32 => B"0000_110_010_0000", -- ADD
        33 => B"0111_001_110_0000", -- SW
        34 => B"1001_101_110_0000", -- CMPR
        35 => B"1010_000_1111101", --  BVC (Se não overflow pula -3)
        -- i++ (R2)
        36 => B"0100_010_010_0001", -- ADDI
        -- Zera o j (R6)
        37 => B"0100_110_000_0000", -- CLR
        38 => B"1111_000_0011000", -- JMP (Volta para o loop de i - Linha 24)

        -- Loop para pegar os primos
        -- Carrega o i (R2) com 2 e zera R7 (Onde ficará os primos)
        39 => B"1100_010_0000010", -- LI
        40 => B"0100_111_000_0000", -- CLR
        -- Compara se o endereco i (R2) da ram é primo (!= 0) carregando no R4, se for, carrega o número i (R2) no R7
        41 => B"0110_100_010_0000", -- LW
        42 => B"1001_100_000_0000", -- CMPR
        43 => B"1000_000_0000010", -- BNE
        44 => B"1111_000_0101110", -- JMP (Pula o load - Linha 46)
        45 => B"0100_111_010_0000", -- MOV
        -- i++ (R2)
        46 => B"0100_010_010_0001", -- ADDI
        -- Enquanto i (R2) < 32 (R5) Continua, caso contrário pula para o final
        47 => B"1001_101_010_0000", -- CMPR
        48 => B"1010_000_1111001", -- BVC

        -- Nop (Ponto final)
        49 => B"0000_0000_000000", -- NOP

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

