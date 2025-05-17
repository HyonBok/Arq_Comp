library IEEE;
use IEEE.std_logic_1164.all;

entity mux8_tb is
end;

architecture a_mux8_tb of mux8_tb is
    component mux8
        port(
            ent0, ent1, ent2, ent3, ent4, ent5, ent6, ent7: in std_logic;
            sel0, sel1, sel2: in std_logic;
            saida: out std_logic
        );
    end component;

    signal ent0, ent1, ent2, ent3, ent4, ent5, ent6, ent7: std_logic;
    signal sel0, sel1, sel2: std_logic;
    signal saida: std_logic;

begin
    uut: mux8 port map(
        ent0 => ent0,
        ent1 => ent1,
        ent2 => ent2,
        ent3 => ent3,
        ent4 => ent4,
        ent5 => ent5,
        ent6 => ent6,
        ent7 => ent7,
        sel0 => sel0,
        sel1 => sel1,
        sel2 => sel2,
        saida => saida
    );
    process
    begin
        -- Selecionado ent0, entao saida deve ser 0
        ent0 <= '0';
        ent1 <= '0';
        ent2 <= '1';
        ent3 <= '1';
        ent4 <= '1';
        ent5 <= '0';
        ent6 <= '1';
        ent7 <= '1';
        sel0 <= '0';
        sel1 <= '0';
        sel2 <= '0';
        wait for 50 ns;
        -- ent3 = 1, então saida deve ser 1
        ent0 <= '0';
        ent1 <= '0';
        ent2 <= '0';
        ent3 <= '1';
        ent4 <= '0';
        ent5 <= '0';
        ent6 <= '0';
        ent7 <= '1';
        sel0 <= '1';
        sel1 <= '1';
        sel2 <= '0';
        wait for 50 ns;
        -- Saida depende do valor de ent2
        ent0 <= '0';
        ent1 <= '0';
        ent2 <= '0';
        ent3 <= '1';
        ent4 <= '1';
        ent5 <= '0';
        ent6 <= '1';
        ent7 <= '0';
        sel0 <= '0';
        sel1 <= '1';
        sel2 <= '0';
        wait for 50 ns;
        ent0 <= '0';
        ent1 <= '0';
        ent2 <= '1';
        ent3 <= '1';
        ent4 <= '1';
        ent5 <= '0';
        ent6 <= '1';
        ent7 <= '1';
        sel0 <= '0';
        sel1 <= '1';
        sel2 <= '0';
        wait for 50 ns;
        wait;
    end process;
end architecture;



