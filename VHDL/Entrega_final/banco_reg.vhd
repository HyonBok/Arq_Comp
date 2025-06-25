library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_reg is 
    port(   clk, reset, wr_en : in std_logic;
            reg_wr, reg_r1, reg_r2  : in unsigned(2 downto 0);
            data_wr : in unsigned(15 downto 0);
            data_r1, data_r2 : out unsigned(15 downto 0)
    );
end entity;

architecture a_banco_reg of banco_reg is 
    component reg16bits is
        port(   clk, reset, wr_en : in std_logic;
                data_in : in unsigned(15 downto 0);
                data_out : out unsigned(15 downto 0)
        );
    end component;
    signal wr_en0, wr_en1, wr_en2, wr_en3, wr_en4, wr_en5, wr_en6, wr_en7 : std_logic;
    signal reg0, out_reg1, out_reg2, out_reg3, out_reg4, out_reg5, out_reg6, out_reg7 : unsigned(15 downto 0);
    signal entrada : unsigned(15 downto 0);

begin
    reg0 <= "0000000000000000";
    reg1: reg16bits port map(clk=>clk, reset=>reset, wr_en=>wr_en1, data_in=>entrada, data_out=>out_reg1);
    reg2: reg16bits port map(clk=>clk, reset=>reset, wr_en=>wr_en2, data_in=>entrada, data_out=>out_reg2);
    reg3: reg16bits port map(clk=>clk, reset=>reset, wr_en=>wr_en3, data_in=>entrada, data_out=>out_reg3);
    reg4: reg16bits port map(clk=>clk, reset=>reset, wr_en=>wr_en4, data_in=>entrada, data_out=>out_reg4);
    reg5: reg16bits port map(clk=>clk, reset=>reset, wr_en=>wr_en5, data_in=>entrada, data_out=>out_reg5);
    reg6: reg16bits port map(clk=>clk, reset=>reset, wr_en=>wr_en6, data_in=>entrada, data_out=>out_reg6);
    reg7: reg16bits port map(clk=>clk, reset=>reset, wr_en=>wr_en7, data_in=>entrada, data_out=>out_reg7);

    entrada <= data_wr;
    wr_en1 <= '1' when reg_wr="001" and wr_en='1' else '0';
    wr_en2 <= '1' when reg_wr="010" and wr_en='1' else '0';
    wr_en3 <= '1' when reg_wr="011" and wr_en='1' else '0';
    wr_en4 <= '1' when reg_wr="100" and wr_en='1' else '0';
    wr_en5 <= '1' when reg_wr="101" and wr_en='1' else '0';
    wr_en6 <= '1' when reg_wr="110" and wr_en='1' else '0';
    wr_en7 <= '1' when reg_wr="111" and wr_en='1' else '0';


    data_r1 <=  reg0 when reg_r1="000" else
                out_reg1 when reg_r1="001" else
                out_reg2 when reg_r1="010" else
                out_reg3 when reg_r1="011" else
                out_reg4 when reg_r1="100" else
                out_reg5 when reg_r1="101" else
                out_reg6 when reg_r1="110" else
                out_reg7 when reg_r1="111" else
                "0000000000000000";

    data_r2 <=  reg0 when reg_r2="000" else
                out_reg1 when reg_r2="001" else
                out_reg2 when reg_r2="010" else
                out_reg3 when reg_r2="011" else
                out_reg4 when reg_r2="100" else
                out_reg5 when reg_r2="101" else
                out_reg6 when reg_r2="110" else
                out_reg7 when reg_r2="111" else
                "0000000000000000";

end architecture;
