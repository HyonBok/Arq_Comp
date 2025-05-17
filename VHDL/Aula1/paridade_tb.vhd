library ieee;
use ieee.std_logic_1164.all;

entity paridade_tb is
end;

architecture a_paridade_tb of paridade_tb is
    component paridade
        port(
            a0: in std_logic;
            a1: in std_logic;
            a2: in std_logic;
            b: out std_logic
        );
    end component;

    signal a0, a1, a2, b: std_logic;

begin
    uut: paridade port map(
        a0 => a0,
        a1 => a1,
        a2 => a2,
        b => b
    );
    process
    begin
        a0 <= '0';
        a1 <= '0';
        a2 <= '0';
        wait for 50 ns;
        a0 <= '1';
        a1 <= '0';
        a2 <= '0';
        wait for 50 ns;
        a0 <= '0';
        a1 <= '1';
        a2 <= '0';
        wait for 50 ns;
        a0 <= '1';
        a1 <= '1';
        a2 <= '0';
        wait for 50 ns;
        a0 <= '0';
        a1 <= '0';
        a2 <= '1';
        wait for 50 ns;
        a0 <= '1';
        a1 <= '0';
        a2 <= '1';
        wait for 50 ns;
        a0 <= '0';
        a1 <= '1';
        a2 <= '1';
        wait for 50 ns;
        a0 <= '1';
        a1 <= '1';
        a2 <= '1';
        wait for 50 ns;
        wait;
    end process;
end architecture;

