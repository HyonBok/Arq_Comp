library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is 
    port(   clk, mem_read  : in std_logic;
            endereco : in unsigned(6 downto 0);
            dado     : out unsigned(13 downto 0)        
    );
end entity;

architecture a_rom of rom is
    type mem is array (0 to 127) of unsigned(13 downto 0);
    constant conteudo_rom : mem := (
        0 => "00000000000000",
        1 => "00000000000001",
        2 => "00000000000010",
        3 => "11110000000111",  --pula para 7 (0000111)
        4 => "00000000000000",
        5 => "00000000000001",
        6 => "00000000000010",
        7 => "00000000000011",
        8 => "11111100001111", --pula para 15 (0001111)
        13 => "11110000011111", --pula para 31 (0011111)
        14 => "00000000000010",
        15 => "11110000001010", --pula para 10 (0001010) 
        16 => "11110000000011", --pularia para 3 (11) porém não passa aqui
        31 => "11110001110011", --pula para 115 (1110011) (73)
        115 => "00000000000001",
        116 => "00000000000010",
        117 => "00000000000011",
        118 => "11110001110011", --pula para 115 (1110011) (73) (fica em um ciclo infinito de 115 -> 116 -> 117 -> 118 -> 115)
        others => (others=>'0')
    );
    
begin
    process(clk, mem_read)
    begin 
        if mem_read='1' then
            if(rising_edge(clk)) then
                dado <= conteudo_rom(to_integer(endereco));
            end if;
        end if;
    end process;
end architecture;

