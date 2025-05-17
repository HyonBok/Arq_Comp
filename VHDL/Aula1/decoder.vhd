library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity decoder is
    port(
        a0: in std_logic;
        a1: in std_logic;
        b0: out std_logic;
        b1: out std_logic;
        b2: out std_logic;
        b3: out std_logic
    );
    end entity;

architecture a_decoder of decoder is
begin
    b0 <= not a0 and not a1;
    b1 <= not a0 and a1;
    b2 <= a0 and not a1;
    b3 <= a0 and a1;
end architecture;
