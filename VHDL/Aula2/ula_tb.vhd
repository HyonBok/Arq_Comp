library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ula_tb is
end;

architecture a_ula_tb of ula_tb is
    component ula
        port(
            ent0,ent1:  in  unsigned(15 downto 0);
            selec:  in  unsigned(1 downto 0);
            resultado:  out  unsigned(15 downto 0);
            z, n: out std_logic
        );
    end component;

    signal selec: unsigned(1 downto 0);
    signal ent0, ent1, resultado: unsigned(15 downto 0);
    signal z, n: std_logic;

begin
    uut: ula port map(
        ent0 => ent0,
        ent1 => ent1,
        resultado => resultado,
        selec => selec,
        z => z,
        n => n
    );

    process
    begin
        ent0 <= "0000000001001101"; -- 77
        ent1 <= "0000000000000110"; -- 6
        selec <= "00"; -- operacao: +
        wait for 10 ns;
        ent0 <= "1111111111111101"; -- -3
        ent1 <= "0000000000001010"; -- 10
        selec <= "00"; -- operacao: +
        wait for 10 ns;
        ent0 <= "1111111111111011"; -- -5
        ent1 <= "1111111111111001"; -- -6
        selec <= "00"; -- operacao: +
        wait for 10 ns;
        ent0 <= "0000000000000101"; -- 5
        ent1 <= "0000000000000011"; -- 3
        selec <= "01"; -- operacao: -
        wait for 10 ns;
        ent0 <= "1111111111110101"; -- -10
        ent1 <= "0000000000001101"; -- 13
        selec <= "01"; -- operacao: -
        wait for 10 ns;
        ent0 <= "1111111111100101"; -- -26
        ent1 <= "1111111111110100"; -- -11
        selec <= "01"; -- operacao: -
        wait for 10 ns;
        ent0 <= "1001110001101001";
        ent1 <= "0000000111111111";
        selec <= "10"; -- operacao: e
        wait for 10 ns;
        ent0 <= "1001110001101001";
        ent1 <= "0000000111111111";
        selec <= "11"; -- operacao: ou
        wait for 10 ns;
        wait;
    end process;
end architecture;
