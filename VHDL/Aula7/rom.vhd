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
        0 => B"1100_011_0011111", -- 1100 = Load-Upper-Int, 011 = Rd, 0000000 = Constante
        1 => B"1100_010_0001101", -- 1100 = Load-Upper-Int, 011 = Rd, 0000000 = Constante
        2 => B"0111_1010_010_011", -- 0111 = Save-Word, 001 = ,  
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

