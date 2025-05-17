library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ula is
    port(
        ent0,ent1:  in  unsigned(15 downto 0); -- Entradas
        selec:  in  unsigned(1 downto 0);
        resultado:  out  unsigned(15 downto 0);
        z, n: out std_logic -- Carry e overflow
    );
end entity;

architecture a_ula of ula is
    component mux16 is
        port(
            result0,result1,result2,result3: in  unsigned(15 downto 0);
            selec: in  unsigned(1 downto 0);
            resultado: out unsigned(15 downto 0)
        );
    end component;

    component operacoes is
        port(
            ent0,ent1: in  unsigned(15 downto 0);
            soma,subt,op_e,op_ou: out unsigned(15 downto 0)
        );
    end component;

    signal soma, subt, op_e, op_ou, result: unsigned(15 downto 0);

begin
    operacoes_0: operacoes port map(
        ent0 => ent0,
        ent1 => ent1,
        soma => soma,
        subt => subt,
        op_e => op_e,
        op_ou => op_ou
    );

    mux16_0: mux16 port map(
        result0 => soma,
        result1 => subt,
        result2 => op_e,
        result3 => op_ou,
        selec => selec,
        resultado => result
    );

    resultado <= result;
    z <= '1' when result = "0000000000000000" else '0';
    n <= result(15);
end architecture;


