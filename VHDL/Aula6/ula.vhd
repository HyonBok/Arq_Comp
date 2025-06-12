library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ula is
    port(
        a0, a1:  in  unsigned(15 downto 0); -- Entradas
        selec:  in  unsigned(1 downto 0);
        opcode: in unsigned(3 downto 0);
        resultado:  out  unsigned(15 downto 0);
        z, n, v, jmp_en: out std_logic
    );
end entity;

architecture a_ula of ula is
    signal soma, subt, op_e, op_ou, result: unsigned(15 downto 0);
    signal z_s, v_s: std_logic;

begin
    soma <= a0 + a1;
    subt <= a0 - a1;
    op_e <= a0 and a1;
    op_ou <= a0 or a1;

    result <=
        soma when selec = "00" else
        subt when selec = "01" else
        op_e when selec = "10" else
        op_ou when selec = "11";

    resultado <= result;

    z_s <= '1' when result = "0000000000000000" else '0';
    z <= z_s;
    n <= result(15);

    -- Casos de overflow:
    -- positivo + positivo = negativo
    -- negativo + negativo = positivo
    -- positivo - negativo = negativo
    -- negativo - positivo = positivo
    v_s <= '1' when (a0(15) = '0' and a1(15) = '0' and result(15) = '1' and selec = "00") or
                    (a0(15) = '1' and a1(15) = '1' and result(15) = '0' and selec = "00") or
                    (a0(15) = '1' and a1(15) = '0' and result(15) = '1' and selec = "01") or
                    (a0(15) = '0' and a1(15) = '1' and result(15) = '0' and selec = "01") else
        '0';
    v <= v_s;

    -- BNE 
    -- BL
    jmp_en <= '1' when  (opcode = "1000" and z_s = '0') or 
                        (opcode = "1001" and result(15) = '1' and v_s = '0') else
            '0';

end architecture;



