library ieee;
use ieee.std_logic_1164.all;

entity paridade is
    port(
        a0: in std_logic;
        a1: in std_logic;
        a2: in std_logic;
        b: out std_logic
    );
    end entity;

architecture a_paridade of paridade is
begin
    b <= ((a0 xor a1) xor a2) or (a0 and a1 and a2);
end architecture;

