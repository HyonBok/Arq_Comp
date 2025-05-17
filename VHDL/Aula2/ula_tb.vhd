library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ula_tb is
end;

architecture a_ula_tb of ula_tb is
    component ula
        port(
            a0,a1:  in  unsigned(15 downto 0);
            sel:  in  unsigned(1 downto 0);
            saida:  out  unsigned(15 downto 0)
        );
    end component;

    signal sel: unsigned(1 downto 0);
    signal a0, a1, saida: unsigned(15 downto 0);

begin
    uut: ula port map(
        a0 => a0,
        a1 => a1,
        saida => saida,
        sel => sel
    );

    process
    begin
        a0 <= "0000000000001111";
        a1 <= "0000000000001110";
        sel <= "00";
        wait for 50 ns;
        a0 <= "0000000000001111";
        a1 <= "0000000000001110";
        sel <= "01";
        wait for 50 ns;
        wait;
    end process;
end architecture;
