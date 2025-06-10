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
        0 => "11000110000101", -- A: 1100 = Load, 011 = Rd, 0000101 = Constante
        1 => "11001000001000", -- B: 1100 = Load, 010 = Rd, 0001000 = Constante
        2 => "00001010111000", -- C: 0000 = Add, 101 = Rd, 011 = R1, 100 = R2, 0 = lixo
        3 => "01011011010001", -- D: 0101 = Subi, 101 = Rd, 101 = R1, 0001 = Constante
        4 => B"1000_110_011_100_1", -- E: 1000 = BNE, 000 = Constante, 0010100 = Endereço
        5 => "11001010000000", -- F: 1100 = Load, 101 = Rd, 0000000 = Constante
        20 => "01000111010000", -- G: 0100 = Addi, 011 = Rd, 101 = R1, 0000 = Constante
        21 => "11110000000010", -- H: 1111 = Salto, 000 = Lixo, 0000010 = Endereço
        22 => "11000110000000", -- I: 1100 = Load, 011 = Rd, 0000000 = Constante
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

