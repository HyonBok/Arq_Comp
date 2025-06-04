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
        1 => "00000000000000", -- B: NOP
        2 => "00000000000000", -- C: NOP
        3 => "01000110110001", -- D: 0100 = Addi, 011 = Rd, 011 = R1, 0001 = Constante
        4 => "00000000000000", -- E: NOP
        5 => "11110000000001", -- F: 1111 = Salto, 000 = Lixo, 0000001 = Endereço
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

