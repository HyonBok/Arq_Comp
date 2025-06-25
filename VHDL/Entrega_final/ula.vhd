library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ula is
    port(
        a0, a1:  in  unsigned(15 downto 0); -- Entradas
        selec:  in  unsigned(1 downto 0);
        carry_flag: in std_logic;
        resultado:  out  unsigned(15 downto 0);
        z, n, v, carry_subb: out std_logic
    );
end entity;

architecture a_ula of ula is
    signal soma, subt, cf, op_e, op_ou, result: unsigned(15 downto 0);

begin
    cf(15 downto 1) <= "000000000000000";
    cf(0) <= '1' when carry_flag = '1' else '0';

    soma <= a0 + a1;
    subt <= a0 - a1 - cf;
    op_e <= a0 and a1;
    op_ou <= a0 or a1;

    result <=
        soma when selec = "00" else
        subt when selec = "01" else
        op_e when selec = "10" else
        op_ou when selec = "11";

    resultado <= result;

    z <= '1' when result = "0000000000000000" else '0';
    n <= result(15);

    -- Casos de overflow:
    -- positivo + positivo = negativo
    -- negativo + negativo = positivo
    -- positivo - negativo = negativo
    -- negativo - positivo = positivo
    v <= '1' when (a0(15) = '0' and a1(15) = '0' and result(15) = '1' and selec = "00") or
                    (a0(15) = '1' and a1(15) = '1' and result(15) = '0' and selec = "00") or
                    (a0(15) = '0' and a1(15) = '1' and result(15) = '1' and selec = "01") or
                    (a0(15) = '1' and a1(15) = '0' and result(15) = '0' and selec = "01") else
        '0';   

    -- positivo - negativo = negativo
    -- negativo - positivo = positivo
    carry_subb <= '1' when  (a0(15) = '0' and a1(15) = '1' and result(15) = '1' and selec = "01") or
                            (a0(15) = '1' and a1(15) = '0' and result(15) = '0' and selec = "01") else
        '0';

    
end architecture;



