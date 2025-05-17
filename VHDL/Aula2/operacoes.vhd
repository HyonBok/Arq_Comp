library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity operacoes is
   port (   
     ent0,ent1: in  unsigned(15 downto 0);
     soma,subt, op_e, op_ou: out unsigned(15 downto 0)
   );
end entity;

architecture a_operacoes of operacoes is
begin
   soma <= ent0+ent1;
   subt <= ent0-ent1;
   op_e <= ent0 and ent1;
   op_ou <= ent0 or ent1;
end architecture;