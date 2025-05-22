library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_reg is 
    port(   clk, rst, wr_en : in std_logic;
            reg_wr, reg_r1, reg_r2  : in unsigned(4 downto 0);
            data_wr : in unsigned(15 downto 0);
            data_r1, data_r2 : out unsigned(15 downto 0)
    );
end entity;

architecture a_banco_reg of banco_reg is 
    component reg16bits is
        port(   clk, rst, wr_en : in std_logic;
                data_in : in unsigned(15 downto 0);
                data_out : out unsigned(15 downto 0)
        );
    end component;
    signal wr_en0, wr_en1, wr_en2, wr_en3, wr_en4, wr_en5, wr_e6, wr_en7 : std_logic;
    signal out_reg0, out_reg1, out_reg2, out_reg3, out_reg4 ,out_reg5 ,out_reg6, out_reg7 : unsigned(15 downto 0);
    signal entrada : unsigned(15 downto 0);
begin

    reg0: reg16bits port map(clk=>clk, rst=>rst, wr_en=>wr_en0, data_in=>entrada, data_out=>out_reg0);
    reg1: reg16bits port map(clk=>clk, rst=>rst, wr_en=>wr_en1, data_in=>entrada, data_out=>out_reg1);
    reg2: reg16bits port map(clk=>clk, rst=>rst, wr_en=>wr_en2, data_in=>entrada, data_out=>out_reg2);
    reg3: reg16bits port map(clk=>clk, rst=>rst, wr_en=>wr_en3, data_in=>entrada, data_out=>out_reg3);
    reg4: reg16bits port map(clk=>clk, rst=>rst, wr_en=>wr_en4, data_in=>entrada, data_out=>out_reg4);
    reg5: reg16bits port map(clk=>clk, rst=>rst, wr_en=>wr_en5, data_in=>entrada, data_out=>out_reg5);
    reg6: reg16bits port map(clk=>clk, rst=>rst, wr_en=>wr_en6, data_in=>entrada, data_out=>out_reg6);
    reg7: reg16bits port map(clk=>clk, rst=>rst, wr_en=>wr_en7, data_in=>entrada, data_out=>out_reg7);

    process(clk, rst, wr_en)
    begin
        if rst='1' then
            wr_en0 <= '1';
            wr_en1 <= '1';
            wr_en2 <= '1';
            wr_en3 <= '1';
            wr_en4 <= '1';
            wr_en5 <= '1';
            wr_en6 <= '1';
            wr_en7 <= '1';
            entrada <= "0000000000000000";
            
        elsif wr_en='1' then

            entrada <= data_wr;

            wr_en0 <= '1' when reg_wr="00000" else '0';
            wr_en1 <= '1' when reg_wr="00001" else '0';
            wr_en2 <= '1' when reg_wr="00010" else '0';
            wr_en3 <= '1' when reg_wr="00011" else '0';
            wr_en4 <= '1' when reg_wr="00100" else '0';
            wr_en5 <= '1' when reg_wr="00101" else '0';
            wr_en6 <= '1' when reg_wr="00110" else '0';
            wr_en7 <= '1' when reg_wr="00111" else '0';
        
        end if;

        if rising_edge(clk) then
            data_r1 <=  out_reg0 when reg_r1="00000" else
                        out_reg1 when reg_r1="00001" else
                        out_reg2 when reg_r1="00010" else
                        out_reg3 when reg_r1="00011" else
                        out_reg4 when reg_r1="00100" else
                        out_reg5 when reg_r1="00101" else
                        out_reg6 when reg_r1="00110" else
                        out_reg7 when reg_r1="00111" else
                        "0000000000000000";
            
            data_r2 <=  out_reg0 when reg_r2="00000" else
                        out_reg1 when reg_r2="00001" else
                        out_reg2 when reg_r2="00010" else
                        out_reg3 when reg_r2="00011" else
                        out_reg4 when reg_r2="00100" else
                        out_reg5 when reg_r2="00101" else
                        out_reg6 when reg_r2="00110" else
                        out_reg7 when reg_r2="00111" else
                        "0000000000000000";
            
        end if;
    end process;
end architecture;
