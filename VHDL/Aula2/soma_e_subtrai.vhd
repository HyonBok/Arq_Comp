library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity soma_e_subtrai is
    port (   
      a0,a1       :  in  unsigned(15 downto 0);
      soma,subt :  out unsigned(15 downto 0)
    );
 end entity;
 architecture a_soma_e_subtrai of soma_e_subtrai is
 begin
    soma <= a0+a1;
    subt <= a0-a1;
 end architecture;