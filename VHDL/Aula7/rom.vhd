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
        0 => B"1100_001_0000000", -- 1100 = Load-Upper-Int, Rd, Constante
        1 => B"1100_010_0000000", -- 1100 = Load-Upper-Int, Rd, Constante
        2 => B"1100_011_0100000", -- 1100 = Load-Upper-Int, Rd, Constante
        3 => B"0100_001_0_001_001", -- 0100 = ADDI, Rd, R1, Constante
        4 => B"0100_010_0_010_001", -- 0100 = ADDI, Rd, R1, Constante
        5 => B"0111_0000_010_001", -- 0111 = Save-Word, Constante, Re, R1 
        6 => B"1001_1101_001_011", -- 1001 = BL, Constante, R1, R2
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

