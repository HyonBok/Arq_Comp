library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ula is
    port(
        a0, a1:  in  unsigned(15 downto 0); -- Entradas
        selec:  in  unsigned(1 downto 0);
        resultado:  out  unsigned(15 downto 0);
        z, n, dif_zero: out std_logic
    );
end entity;

architecture a_ula of ula is
    signal soma, subt, op_e, op_ou, result: unsigned(15 downto 0);

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

    dif_zero <= '1' when result /= "0000000000000000" else
                '0';

    z <= '1' when result = "0000000000000000" else '0';
    n <= result(15);

end architecture;



