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
        0 => B"1100_011_0000101", -- A: 1100 = Load, 011 = Rd, 0000101 = Constante
        1 => B"1100_100_0001000", -- B: 1100 = Load, 010 = Rd, 0001000 = Constante
        2 => B"0000_101_011_100_0", -- C: 0000 = Add, 101 = Rd, 011 = R1, 100 = R2, 0 = lixo
        3 => B"0101_101_101_0001", -- D: 0101 = Subi, 101 = Rd, 101 = R1, 0001 = Constante
        4 => B"1000_110_011_100_1", -- E: 1000 = BNE, 110 = Constante, 011 = R1, 100 = Constante, 1 = Sinal
        5 => B"1100_1010000000", -- F: 1100 = Load, 101 = Rd, 0000000 = Constante
        20 => B"0100_011_101_0000", -- G: 0100 = Addi, 011 = Rd, 101 = R1, 0000 = Constante
        21 => B"1111_000_0000010", -- H: 1111 = Salto, 000 = Lixo, 0000010 = Endereço
        22 => B"1100_011_0000000", -- I: 1100 = Load, 011 = Rd, 0000000 = Constante
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

