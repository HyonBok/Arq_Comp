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
        1 => B"1100_010_0000001", -- 1100 = Load-Upper-Int, Rd, Constante
        2 => B"1100_011_0001111", -- 1100 = Load-Upper-Int, Rd, Constante
        -- Loop adicionando 1 ao R0 e comparando com R3
        3 => B"0100_000_0000001",
        4 => B"1101_000_0001111", -- CMPI: 1101 sss bbbbbbb
        5 => B"1000_000_1_111110", --BNE = sssx bbbbbb

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

