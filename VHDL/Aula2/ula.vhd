library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ula is
    port(
        a0,a1:  in  unsigned(15 downto 0);
        sel:  in  unsigned(1 downto 0);
        saida:  out  unsigned(15 downto 0)
    );
end entity;

architecture a_ula of ula is
    component mux16 is
        port(
            a0,a1,a2,a3: in  unsigned(15 downto 0);
            sel: in  unsigned(1 downto 0);
            saida: out unsigned(15 downto 0)
        );
    end component;

    component soma_e_subtrai is
        port(
            a0,a1       :  in  unsigned(15 downto 0);
            soma,subt :  out unsigned(15 downto 0)
        );
    end component;

    signal soma, subt, s2, s3: unsigned(15 downto 0);

begin
    soma_e_subt: soma_e_subtrai port map(
        a0 => a0,
        a1 => a1,
        soma => soma,
        subt => subt
    );

    mux: mux16 port map(
        a0 => soma,
        a1 => subt,
        a2 => s2,
        a3 => s3,
        sel => sel,
        saida => saida
    );
end architecture;


