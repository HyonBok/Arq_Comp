library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc is 
    port(   clk, rst, wr_en, pc_en  : in std_logic;
            data_in  : in unsigned(6 downto 0);
            data_out : out unsigned(6 downto 0)
    );
end entity;

architecture a_pc of pc is

    signal entrada_pc: unsigned(6 downto 0);
    signal registro, saida_somador: unsigned(6 downto 0) := "0000000";
begin

    entrada_pc <=   data_in when wr_en='1' else 
                    saida_somador;

    process(clk, rst, pc_en)
    begin
        if rst='1' then
            registro <= "0000000";
        elsif pc_en='1' then
            if rising_edge(clk) then
                registro <= entrada_pc;
            end if;
        end if;
    end process;

    data_out <= registro;
    saida_somador <= registro + 1;

end architecture;