library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc is 
    port(   clk, reset, jmp_en, pc_en, pc_relativo, branch_en : in std_logic;
            data_in  : in unsigned(6 downto 0);
            data_out : out unsigned(6 downto 0)
    );
end entity;

architecture a_pc of pc is

    signal entrada_pc: unsigned(6 downto 0);
    signal saida_relativo: unsigned(6 downto 0);
    signal registro: unsigned(6 downto 0) := "0000000";
begin

    saida_relativo <= data_in when pc_relativo = '0' else
                    registro + data_in;

    entrada_pc <=   saida_relativo when (jmp_en='1' and pc_relativo = '0') or branch_en='1' else 
                    registro + 1;

    process(clk, reset, pc_en)
    begin
        if reset='1' then
            registro <= "0000000";
        elsif pc_en='1' then
            if rising_edge(clk) then
                registro <= entrada_pc;
            end if;
        end if;
    end process;

    data_out <= registro;

end architecture;