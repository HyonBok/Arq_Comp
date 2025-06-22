library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity flip_flop is 
    port(   clk, reset, data_in, wr_en : in std_logic;
            data_out : out std_logic
    );
end entity;

architecture a_flip_flop of flip_flop is 
    signal registro: std_logic;
begin

    process(clk, reset, wr_en)
    begin
        if reset='1' then
            registro <= '0';
        elsif wr_en='1' then
            if rising_edge(clk) then
                registro <= data_in;
            end if;
        end if;
    end process;

    data_out <= registro;
end architecture;
