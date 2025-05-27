library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity main is 
    port(   clk, reset, wr_en, sel_write : in std_logic;
            reg_wr, reg_r1, reg_r2  : in unsigned(4 downto 0);
            sel_operacao:  in  unsigned(1 downto 0);
            data_wr : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0);
            z, n : out std_logic
    );
end entity;

architecture a_main of main is 

    component ula is
        port(   a0, a1:  in  unsigned(15 downto 0);
                selec:  in  unsigned(1 downto 0);
                resultado:  out  unsigned(15 downto 0);
                z, n: out std_logic
        );
    end component;

    component banco_reg is
        port(   clk, rst, wr_en : in std_logic;
                reg_wr, reg_r1, reg_r2  : in unsigned(4 downto 0);
                data_wr : in unsigned(15 downto 0);
                data_r1, data_r2 : out unsigned(15 downto 0)
        );
    end component;

    signal saida_banco1, saida_banco2, saida_ula, entrada_escrita: unsigned(15 downto 0);
begin
    ula1 : ula port map(
        a0=>saida_banco1, a1=>saida_banco2, 
        selec=>sel_operacao, resultado=>saida_ula, 
        z=>z, n=>n
    );   
    banco : banco_reg port map(
        clk=>clk, rst=>reset, wr_en=>wr_en,
        reg_wr=>reg_wr, reg_r1=>reg_r1, reg_r2=>reg_r2,
        data_wr=>entrada_escrita, data_r1=>saida_banco1, data_r2=>saida_banco2
    );

    entrada_escrita <=  data_wr     when sel_write='0' else
                        saida_ula   when sel_write='1' else
                        "0000000000000000";
    
    data_out <= saida_ula;

end architecture;
