library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mux16 is
    port (
        a0,a1,a2,a3: in  unsigned(15 downto 0);
        sel: in  unsigned(1 downto 0);
        saida: out unsigned(15 downto 0)
    );
end entity mux16;

architecture a_mux16 of mux16 is
begin 
    saida <=    a0 when sel="00" else
        a1 when sel="01" else
        a2 when sel="10" else
        a3 when sel="11" else
        "0000000000000000";  
end architecture;