library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mux16 is
    port (
        result0,result1,result2,result3: in  unsigned(15 downto 0);
        selec: in  unsigned(1 downto 0);
        resultado: out unsigned(15 downto 0)
    );
end entity mux16;

architecture a_mux16 of mux16 is
begin 
    resultado <=    
        result0 when selec="00" else
        result1 when selec="01" else
        result2 when selec="10" else
        result3 when selec="11" else
        "0000000000000000";  
end architecture;