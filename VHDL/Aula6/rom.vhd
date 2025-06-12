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
        0 => B"1100_011_0000000", -- 1100 = Load, 011 = Rd, 0000000 = Constante
        1 => B"1100_100_0000000", -- 1100 = Load, 100 = Rd, 0000000 = Constante
        2 => B"1100_001_0000110", -- 1100 = Load, 001 = Rd, 0011110 = Constante
        3 => B"0000_100_011_100_0", -- 0000 = Add, 100 = Rd, 011 = R1, 100 = R2, 0 = lixo
        4 => B"0100_011_011_0100", -- 0100 = Addi, 011 = Rd, 011 = R1, 0001 = constante
        5 => B"1001_111_011_001_1", -- 1000 = BL, 110 = Constante, 011 = R1, 100 = R2, 1 = Sinal
        6 => B"0100_101_100_0000", -- 0100 = Addi, 101 = Rd, 011 = R1, 0001 = constante
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

