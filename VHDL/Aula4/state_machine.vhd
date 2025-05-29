library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity state_machine is 
    port(   clk, rst, wr_en : in std_logic;
            data_out : out std_logic
    );
end entity;

architecture a_state_machine of state_machine is 
    signal estado: std_logic := '0';
begin

    process(clk, rst, wr_en)
    begin
        if rst='1' then
            estado <= '0';
        elsif wr_en='1' then
            if rising_edge(clk) then
                estado <= not estado;
            end if;
        end if;
    end process;

    data_out <= estado;
end architecture;